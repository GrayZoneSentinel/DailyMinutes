//
//  CommentsVC.swift
//  DailyMinutes
//
//  Created by Ernesto on 03/01/2019.
//  Copyright © 2019 GrayZoneSentinel. All rights reserved.
//

import UIKit
import Firebase

class CommentsVC: UIViewController {
    
    // MARK: - OUTLETS
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var keyboardView: UIView!
    @IBOutlet weak var commentTxt: UITextField!
    @IBOutlet weak var sendCommentBtn: UIButton!
    
    // MARK: - VARIABLES
        // Class models references
            var minute: Minute!
            var comments = [Comment]()
        // DB references for the transaction
            var minuteRef: DocumentReference!
            var firestore = Firestore.firestore()
            var username: String!
        // DB references for the fecthing of comments
            var commentListener: ListenerRegistration!
    
    
    // MARK: - CLASS METHODS
    override func viewDidAppear(_ animated: Bool) {
        commentListener = firestore.collection(MINUTES_COL_REF).document(self.minute.documentId).collection(COMMENTS_COL_REF)
            .order(by: TIMESTAMP, descending: true)
            .addSnapshotListener({ (snapshot, error) in
            guard let snapshot = snapshot else {
                debugPrint("An error occurred while fetching the comments of the relevant minute: \(error!.localizedDescription)")
                return
            }
            
            self.comments.removeAll()
            self.comments = Comment.parseData(snapshot: snapshot)
            self.commentsTableView.reloadData()
        })
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // UI setup
        commentsTableView.tableFooterView = UIView()
        commentsTableView.backgroundColor = UIColor.init(white: 1, alpha: 0)
        // Extension delegations
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        // Testing the pass of data
            // print(minute.minuteText)
        // DB functionalities
            // Get the document id of the relevant minute which should display the comments or is wanted to be commented
            guard let minuteDocRef = minute.documentId else { return }
            minuteRef = firestore.collection(MINUTES_COL_REF).document(minuteDocRef)
            // Get the username of the current user
            if let user = Auth.auth().currentUser?.displayName {
                username = user
            }
        // Keyboard functionality
        self.view.bindToKeyboard()
    }
    override func viewDidDisappear(_ animated: Bool) {
        commentListener.remove()
    }
    
    // MARK: - ACTIONS
    @IBAction func sendCommentBtnTapped(_ sender: Any) {
        
        guard let commentTxt = commentTxt.text else { return }
        
        firestore.runTransaction({ (transaction, errorPointer) -> Any? in
            
            let minuteDocument: DocumentSnapshot
            
            do {
            
                try minuteDocument = transaction.getDocument(Firestore.firestore().collection(MINUTES_COL_REF).document(self.minute.documentId))
            
            } catch let error as NSError {
                debugPrint("An error occurred while fetching the relevant minute document: \(error.localizedDescription)")
                return nil
            }
            
            guard let oldNumComments = minuteDocument.data()?[NUM_COMMENTS] as? Int else { return nil }
            
            transaction.updateData([NUM_COMMENTS : oldNumComments + 1], forDocument: self.minuteRef)
            
            let newCommentRef = self.firestore.collection(MINUTES_COL_REF).document(self.minute.documentId).collection(COMMENTS_COL_REF).document()
            
            transaction.setData([
                USERNAME : self.username,
                TIMESTAMP : FieldValue.serverTimestamp(),
                COMMENT_TEXT : commentTxt,
                USER_ID : Auth.auth().currentUser?.uid ?? ""
                ],
                forDocument: newCommentRef)
            
            return nil
            
        }) { (object, error) in
            if let error = error {
                debugPrint("An error occurred while running the transaction: \(error.localizedDescription)")
            } else {
                self.commentTxt.text = ""
                // Once the editing is finished and the send button pressed, the keyboard should be dismissed
                self.commentTxt.resignFirstResponder()
            }
        }
    }
}

// MARK: - TABLE VIEW EXTENSION
extension CommentsVC: UITableViewDelegate, UITableViewDataSource {
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    // Cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentCell {
            cell.configureCell(comment: comments[indexPath.row], delegate: self)
            return cell
        }
        return UITableViewCell()
    }
}
// MARK: - DELEGATE EXTENSION
extension CommentsVC: CommentsActionsDelegate {
    func commentActionBtnTapped(comment: Comment) {
        // Here is where we create the alert to handle the deletion or the editing action
        /* Testing ->
            guard let user = comment.username else { return }
            print(user)
            print(comment.username)
        */
        // Alert Controller
        let alert = UIAlertController(title: "Edit or delete comment", message: "", preferredStyle: .actionSheet)
        // Alert controller actions
        let deleteAction = UIAlertAction(title: "Delete comment", style: .destructive) { (deleteAction) in
            /* Delete the coment if there is no need to update the number of comments, in this case it requires a transaction to be able to decrease the number of comments
            self.firestore.collection(MINUTES_COL_REF).document(self.minute.documentId).collection(COMMENTS_COL_REF).document(comment.documentId).delete(completion: { (error) in
                if let error = error {
                    debugPrint("An error occurred while deleting the comment: \(error.localizedDescription)")
                } else {
                    alert.dismiss(animated: true, completion: nil)
                }
            })*/
            self.firestore.runTransaction({ (transaction, errorPointer) -> Any? in
                
                let minuteDocument: DocumentSnapshot
                do {
                    try minuteDocument = transaction.getDocument(Firestore.firestore().collection(MINUTES_COL_REF).document(self.minute.documentId))
                } catch let error as NSError {
                    debugPrint("An error occurred while fetching the minute document: \(error.localizedDescription)")
                    return nil
                }
                
                guard let oldNumComments = minuteDocument.data()?[NUM_COMMENTS] as? Int else { return nil }
                
                transaction.updateData([
                    NUM_COMMENTS : oldNumComments - 1
                    ], forDocument: self.minuteRef)
                
                let commentRef = self.firestore.collection(MINUTES_COL_REF).document(self.minute.documentId).collection(COMMENTS_COL_REF).document(comment.documentId)

                transaction.deleteDocument(commentRef)
                
                return nil
                
            }) { (object, error) in
                if let error = error {
                    debugPrint("An error occurred while performing the deletion transaction of the comment: \(error.localizedDescription)")
                } else {
                    alert.dismiss(animated: true, completion: nil)
                }
            }
        }
        let editAction = UIAlertAction(title: "Edit comment", style: .default) { (editAction) in
            // Edit the comment
            self.performSegue(withIdentifier: "goToEditComment", sender: (comment: comment, minute: self.minute))
            alert.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        // Alert controller actions' declaration
        alert.addAction(editAction)
        alert.addAction(deleteAction)
        alert.addAction(cancelAction)
        // Alert controller call
        present(alert, animated: true, completion: nil)
    }
    // DELEGATE EXTENSION FUNCTIONS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEditComment" {
            if let destinationVC = segue.destination as? EditCommentVC {
                if let commentData = sender as? (comment: Comment, minute: Minute) {
                    destinationVC.commentData = commentData
                }
            }
        }
    }
}
