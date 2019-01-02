//
//  MinuteCell.swift
//  DailyMinutes
//
//  Created by Ernesto on 31/12/2018.
//  Copyright © 2018 GrayZoneSentinel. All rights reserved.
//

import UIKit
import Firebase

class MinuteCell: UITableViewCell {
    
    // MARK: - OUTLETS & ELEMENTS
    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var timestampLbl: UILabel!
    @IBOutlet weak var minuteTxt: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var likesNumLbl: UILabel!
    
    // MARK: - VARIABLES
    private var minute: Minute!
    
    // MARK: - METHODS
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Implementation of the Likes functionality
        let tap = UITapGestureRecognizer(target: self, action: #selector(likeTapped))
        starImageView.addGestureRecognizer(tap)
        starImageView.isUserInteractionEnabled = true
        
    }
    
    // MARK: - FUNCTIONS
    func configureCell(minute: Minute) {
        //  In order to get the document Id that it is going to be updated due to the like incrementation function it is necesary to include the following code:
            self.minute = minute
        
        userLbl.text = minute.username
        minuteTxt.text = minute.minuteText
        likesNumLbl.text = String(minute.numLikes)
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ES_es")
        formatter.dateFormat = "d MMM Y, HH:mm"
        let timestamp = formatter.string(from: minute.timestamp)
        timestampLbl.text = timestamp
    }
    
    @objc func likeTapped() {
        // The function to update the DB register with an increment of one like for the relevant Minute
        Firestore.firestore().collection(MINUTES_COL_REF).document(minute.documentId!).updateData([NUM_LIKES : minute.numLikes + 1])
    }

}
