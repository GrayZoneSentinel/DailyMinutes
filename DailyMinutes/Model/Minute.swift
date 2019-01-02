//
//  Minute.swift
//  DailyMinutes
//
//  Created by Ernesto on 31/12/2018.
//  Copyright © 2018 GrayZoneSentinel. All rights reserved.
//

import Foundation
import Firebase

class Minute {
    
    private(set) var username: String!
    private(set) var timestamp: Date!
    private(set) var minuteText: String!
    private(set) var numComments: Int!
    private(set) var numLikes: Int!
    private(set) var documentId: String!
    
    init(username: String, timestamp: Date, minuteText: String, numComments: Int, numLikes: Int, documentId: String) {
        self.username = username
        self.timestamp = timestamp
        self.minuteText = minuteText
        self.numComments = numComments
        self.numLikes = numLikes
        self.documentId = documentId
    }
    
    // FUNCTION TO DETERMINE THE SNAPSHOT
    class func parseDate(snapshot: QuerySnapshot?) -> [Minute] {
        var minutes = [Minute]()
        
        // The code extracted from MainVC snapshot
        guard let snap = snapshot else { return minutes }
        for document in snap.documents {
            let data = document.data()
            let username = data[USERNAME] as? String ?? "Anónimo"
            let timestamp = data[TIMESTAMP] as? Date ?? Date()
            let minute = data[COMENTARIO] as? String ?? "No hay comentarios"
            let numComments = data[NUM_COMMENTS] as? Int ?? 0
            let numLikes = data[NUM_LIKES] as? Int ?? 0
            let documentId = document.documentID
            
            let newMinute = Minute(username: username, timestamp: timestamp, minuteText: minute, numComments: numComments, numLikes: numLikes, documentId: documentId)
            
            minutes.append(newMinute)
            
        }
        return minutes
    }
    
}
