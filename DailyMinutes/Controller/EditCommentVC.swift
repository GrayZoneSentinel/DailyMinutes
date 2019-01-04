//
//  EditCommentVC.swift
//  DailyMinutes
//
//  Created by Ernesto on 04/01/2019.
//  Copyright © 2019 GrayZoneSentinel. All rights reserved.
//

import UIKit
import Firebase

class EditCommentVC: UIViewController {

    // MARK: - OUTLETS
    @IBOutlet weak var editCommentTxt: UITextView!
    @IBOutlet weak var saveBtn: UIButton!
    
    // MARK: - VARIABLES
    var commentData: (comment: Comment, minute: Minute)!
    
    // MARK: - CLASS METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        editCommentTxt.layer.cornerRadius = 10
        guard let commentText = commentData.comment.commentText else { return }
        editCommentTxt.text = commentText
        /* Testing the passing of the relevant minute and comment data to edit
            guard let commentText = commentData.comment.commentText else { return }
            print(commentText) */
    }
    
    // MARK: - ACTIONS
    @IBAction func saveBtnTapped(_ sender: Any) {
        Firestore.firestore().collection(MINUTES_COL_REF).document(commentData.minute.documentId).collection(COMMENTS_COL_REF).document(commentData.comment.documentId).updateData([
            COMMENT_TEXT : editCommentTxt.text
        ]) { (error) in
            if let error = error {
                debugPrint("An error occurred while updating the comment text: \(error.localizedDescription)")
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    // MARK: - FUNCTIONS
    
}
