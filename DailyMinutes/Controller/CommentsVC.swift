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

    
    // MARK: - CLASS METHODS
    override func viewDidLoad() {
        super.viewDidLoad()
        // UI setup
        commentsTableView.tableFooterView = UIView()
        // Extension delegations
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
    }
    
    
    // MARK: - ACTIONS
    @IBAction func sendCommentBtnTapped(_ sender: Any) {
    }
    
}

// MARK: - EXTENSIONS
extension CommentsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as? CommentCell {
            
            cell.configureCell(comment: comments[indexPath.row])
            
            return cell
        }
        return UITableViewCell()
    }
}
