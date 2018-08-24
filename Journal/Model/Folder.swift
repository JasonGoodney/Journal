//
//  Folder.swift
//  Journal
//
//  Created by Jason Goodney on 8/23/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation

class Folder: Equatable, Codable {
    static func == (lhs: Folder, rhs: Folder) -> Bool {
        return
            lhs.name == rhs.name &&
            lhs.entries == rhs.entries
    }
    
    let name: String
    var entries: [Entry]
    
    var description: String {
        return "\(name) has \(entries.count) journals"
    }
    
    init(name: String, entries: [Entry] = []) {
        self.name = name
        self.entries = entries
    }
}
