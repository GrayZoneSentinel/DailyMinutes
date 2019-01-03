//
//  Comment.swift
//  DailyMinutes
//
//  Created by Ernesto on 03/01/2019.
//  Copyright © 2019 GrayZoneSentinel. All rights reserved.
//

import Foundation
import Firebase

class Comment {
    private(set) var username: String!
    private(set) var timestamp: Date!
    private(set) var commentText: String!
    
    init(username: String, timestamp: Date, commentText: String) {
        self.username = username
        self.timestamp = timestamp
        self.commentText = commentText
    }
    
//    class func parseData(snapshot: QuerySnapshot?) -> [Comment] {
//        var comments = [Comment]()
//        guard let snap = snapshot else { return comments }
//        for document in snap.documents {
//            let data = document.data()
//            let username = data[USERNAME] as? String ?? "Anónimo"
//            let timestamp = data[TIMESTAMP] as? Date ?? Date()
//            let commentTxt = data[COMMENT_TEXT] as? String ?? "No comment found."
//
//            let newComment = Comment(username: username, timestamp: timestamp, commentText: commentTxt)
//
//            comments.append(newComment)
//        }
//        return comments
//    }
}
