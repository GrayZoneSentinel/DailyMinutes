//
//  CommentCell.swift
//  DailyMinutes
//
//  Created by Ernesto on 03/01/2019.
//  Copyright © 2019 GrayZoneSentinel. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    // MARK: - OUTLETS
    @IBOutlet weak var usernameTxt: UILabel!
    @IBOutlet weak var timestampTxt: UILabel!
    @IBOutlet weak var commentTxt: UILabel!
    
    // MARK: - VARIABLES
    private var minute: Minute!
    
    // MARK: - CLASS METHODS
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.init(white: 1, alpha: 0)
    }
    
    // MARK: - FUNCTIONS
    func configureCell(comment: Comment) {
        usernameTxt.text = comment.username
        commentTxt.text = comment.commentText
        // Format the date of publication of the minute timestamp
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ES_es")
        formatter.dateFormat = "d MMM Y, HH:mm"
        let timestamp = formatter.string(from: comment.timestamp)
        timestampTxt.text = timestamp
    }
    
    // MARK: - ACTIONS

}
