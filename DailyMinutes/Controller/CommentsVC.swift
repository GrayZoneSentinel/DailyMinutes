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
    
    
    
    // MARK: - VARIABLES
    var minute: Minute!

    
    // MARK: - CLASS METHODS
    override func viewDidLoad() {
        super.viewDidLoad()

        print(minute.minuteText)
    }
    
    
    // MARK: - ACTIONS

}
