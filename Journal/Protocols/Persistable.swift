//
//  Persistable.swift
//  Journal
//
//  Created by Jason Goodney on 8/23/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation

protocol Persistable {
    func saveToPersistantStore()
    func loadFromPersistantStore()
}
