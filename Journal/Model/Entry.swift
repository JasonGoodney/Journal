//
//  Entry.swift
//  Journal
//
//  Created by Jason Goodney on 8/22/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation

class Entry: Equatable, Codable {
    static func ==(lhs: Entry, rhs: Entry) -> Bool {
        return
            lhs.title == rhs.title &&
            lhs.textBody == rhs.textBody &&
            lhs.timestamp == rhs.timestamp
    }
    
    let title: String
    let textBody: String
    let timestamp: Date
    
    var description: String {
        return "\(title) created on \(timestamp)."
    }
    
    init(title: String, textBody: String, timestamp: Date = Date()) {
        self.title = title
        self.textBody = textBody
        self.timestamp = timestamp
    }
}


