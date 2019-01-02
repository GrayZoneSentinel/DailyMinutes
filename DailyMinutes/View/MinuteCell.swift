//
//  MinuteCell.swift
//  DailyMinutes
//
//  Created by Ernesto on 31/12/2018.
//  Copyright © 2018 GrayZoneSentinel. All rights reserved.
//

import UIKit

class MinuteCell: UITableViewCell {
    
    // OUTLETS & ELEMENTS
    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var timestampLbl: UILabel!
    @IBOutlet weak var minuteTxt: UILabel!
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var likesNumLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    // FUNCTIONS
    func configureCell(minute: Minute) {
        userLbl.text = minute.username
        minuteTxt.text = minute.minuteText
        likesNumLbl.text = String(minute.numLikes)
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ES_es")
        formatter.dateFormat = "d MMM Y, HH:mm"
        let timestamp = formatter.string(from: minute.timestamp)
        timestampLbl.text = timestamp
    }

}
