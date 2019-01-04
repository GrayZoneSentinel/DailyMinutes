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
    // To make possible the editing and the deletion by the User who created it
    private(set) var documentId: String!
    private(set) var userId: String!
    
    init(username: String, timestamp: Date, commentText: String, documentId: String, userId: String) {
        self.username = username
        self.timestamp = timestamp
        self.commentText = commentText
        self.documentId = documentId
        self.userId = userId
    }
    
    class func parseData(snapshot: QuerySnapshot?) -> [Comment] {
        var comments = [Comment]()
        guard let snap = snapshot else { return comments }
        for document in snap.documents {
            let data = document.data()
            let username = data[USERNAME] as? String ?? "Anónimo"
            let timestamp = data[TIMESTAMP] as? Date ?? Date()
            let commentTxt = data[COMMENT_TEXT] as? String ?? "No comment found."
            let documentId = document.documentID
            let userId = data[USER_ID] as? String ?? ""

            let newComment = Comment(username: username, timestamp: timestamp, commentText: commentTxt, documentId: documentId, userId: userId)

            comments.append(newComment)
        }
        return comments
    }
}
