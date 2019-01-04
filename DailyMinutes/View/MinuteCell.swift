//
//  MinuteCell.swift
//  DailyMinutes
//
//  Created by Ernesto on 31/12/2018.
//  Copyright © 2018 GrayZoneSentinel. All rights reserved.
//

import UIKit
import Firebase

protocol MinuteDelegate {
    // Call it in the MainVC
    func minuteActionsTapped(minute: Minute)
}

class MinuteCell: UITableViewCell {
    
    // MARK: - OUTLETS & ELEMENTS
    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var timestampLbl: UILabel!
    @IBOutlet weak var minuteTxt: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var likesNumLbl: UILabel!
    @IBOutlet weak var commentsView: UIImageView!
    @IBOutlet weak var numCommentsLbl: UILabel!
    @IBOutlet weak var actionsBtn: UIImageView!
    
    // MARK: - VARIABLES
        // Model variable
        private var minute: Minute!
        // Delegate variable
        private var delegate: MinuteDelegate?
    
    // MARK: - METHODS
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.init(white: 1, alpha: 0)
        // Implementation of the Likes functionality
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        starImageView.addGestureRecognizer(tap)
        starImageView.isUserInteractionEnabled = true
    }
    
    // MARK: - FUNCTIONS
    // Include the delegate to be received by the function below
    func configureCell(minute: Minute, delegate: MinuteDelegate?) {
        //  In order to get the document Id that it is going to be updated due to the like incrementation function it is necesary to include the following code (also used by the delegate function):
            self.minute = minute
        //  Configure the delegate declared as a parameter of the function
            self.delegate = delegate
        //  Here is declared the population of the labels with the data fetched from Firebase Firestore Data Base
            userLbl.text = minute.username
            minuteTxt.text = minute.minuteText
            likesNumLbl.text = String(minute.numLikes)
        //  Include this code to make available the function to create and view comments to the minutes
            numCommentsLbl.text = String(minute.numComments)
            commentsColor()
        // Format the date of publication of the minute timestamp
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ES_es")
            formatter.dateFormat = "d MMM Y, HH:mm"
            let timestamp = formatter.string(from: minute.timestamp)
            timestampLbl.text = timestamp
        // Actions functionality
            actionsBtn.isHidden = true
            if minute.userId == Auth.auth().currentUser?.uid {
                actionsBtn.isHidden = false
                let actionsTap = UITapGestureRecognizer(target: self, action: #selector(actionsBtnTapped))
                actionsBtn.addGestureRecognizer(actionsTap)
                actionsBtn.isUserInteractionEnabled = true
            }
    }
    @objc func likeTapped() {
        // The function to update the DB register with an increment of one like for the relevant Minute
        Firestore.firestore().collection(MINUTES_COL_REF).document(minute.documentId!).updateData([NUM_LIKES : minute.numLikes + 1])
    }
    func commentsColor() {
        if numCommentsLbl.text == "0" {
            numCommentsLbl.textColor = UIColor.lightGray
        } else {
            numCommentsLbl.textColor = UIColor.orange
            numCommentsLbl.font = UIFont.boldSystemFont(ofSize: 12)
        }
    }
    @objc func actionsBtnTapped() {
        // Here is needed a protocol-delegate method
        delegate?.minuteActionsTapped(minute: minute)
    }
}
