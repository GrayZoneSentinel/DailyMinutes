//
//  Minute.swift
//  DailyMinutes
//
//  Created by Ernesto on 31/12/2018.
//  Copyright © 2018 GrayZoneSentinel. All rights reserved.
//

import Foundation


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
    
}
