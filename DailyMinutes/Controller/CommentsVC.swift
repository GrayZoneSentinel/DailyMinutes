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
    var minute: Minute!
    var comments = [Comment]()
    var minuteRef: DocumentReference!
    var firestore = Firestore.firestore()
    var username: String!
    
    // MARK: - CLASS METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        // UI setup
        commentsTableView.tableFooterView = UIView()
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
                COMMENT_TEXT : commentTxt
                ],
                forDocument: newCommentRef)
            
            return nil
            
        }) { (object, error) in
            if let error = error {
                debugPrint("An error occurred while running the transaction: \(error.localizedDescription)")
            }
            self.commentTxt.text = ""
        }
    }
}

// MARK: - EXTENSIONS
extension CommentsVC: UITableViewDelegate, UITableViewDataSource {
    // Number of rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    // Cell for row
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentCell {
            cell.configureCell(comment: comments[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
}
