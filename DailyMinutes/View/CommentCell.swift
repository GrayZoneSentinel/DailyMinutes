//
//  CommentCell.swift
//  DailyMinutes
//
//  Created by Ernesto on 03/01/2019.
//  Copyright © 2019 GrayZoneSentinel. All rights reserved.
//

import UIKit
import Firebase

protocol CommentsActionsDelegate {
    func commentActionBtnTapped(comment: Comment)
}

class CommentCell: UITableViewCell {

    // MARK: - OUTLETS
    @IBOutlet weak var usernameTxt: UILabel!
    @IBOutlet weak var timestampTxt: UILabel!
    @IBOutlet weak var commentTxt: UILabel!
    @IBOutlet weak var actionsBtnImageView: UIImageView!
    
    // MARK: - VARIABLES
    private var minute: Minute!
    private var delegate: CommentsActionsDelegate?
    private var comment: Comment!
    
    // MARK: - CLASS METHODS
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.init(white: 1, alpha: 0)
    }
    
    // MARK: - FUNCTIONS
    func configureCell(comment: Comment, delegate: CommentsActionsDelegate?) {
        usernameTxt.text = comment.username
        commentTxt.text = comment.commentText
        // Format the date of publication of the minute timestamp
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ES_es")
        formatter.dateFormat = "d MMM Y, HH:mm"
        let timestamp = formatter.string(from: comment.timestamp)
        timestampTxt.text = timestamp
        // Configure the actions
        self.comment = comment
        self.delegate = delegate
        actionsBtnImageView.isHidden = true
        if comment.userId == Auth.auth().currentUser?.uid {
            actionsBtnImageView.isHidden = false
            let actionsTap = UITapGestureRecognizer(target: self, action: #selector(actionsBtnTapped))
            actionsBtnImageView.addGestureRecognizer(actionsTap)
            actionsBtnImageView.isUserInteractionEnabled = true
        }
    }
    
    // MARK: - ACTIONS
    @objc func actionsBtnTapped() {
        // Here is declared the delegate-protocol method
        delegate?.commentActionBtnTapped(comment: comment)
    }
}
