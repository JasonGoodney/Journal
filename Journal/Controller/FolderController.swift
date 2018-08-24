//
//  FolderController.swift
//  Journal
//
//  Created by Jason Goodney on 8/23/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation

class FolderController {
    
    static let shared = FolderController()
    
    private init() {
        self.folders = loadFromPersistantStore()
    }
    
    var folders: [Folder] = []
    
    func addFolder(with name: String) {
        let folder = Folder(name: name)
        self.folders.append(folder)
        saveToPersistantStore()
    }
    
    func addEntryToFolder(folder: Folder, entry: Entry) {
        folder.entries.append(entry)
    }
    
    func removeFolder(_ folder: Folder) {
        if let index = folders.index(of: folder) {
            folders.remove(at: index)
            saveToPersistantStore()
        } else {
            print("Error removing folder: \(folder.name)")
        }
    }
}

extension FolderController {
    // MARK: - Save
    func saveToPersistantStore() {
        let je = JSONEncoder()
        do {
            let data = try je.encode(self.folders)
            try data.write(to: fileURL())
        } catch let e {
            print("Error saving folder: \(e))")
        }
    }
    
    // MARK: - Load
    func loadFromPersistantStore() -> [Folder] {
        let jd = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL())
            let folders = try jd.decode([Folder].self, from: data)
            return folders
        } catch let e {
            print("Error loading folders: \(e)")
        }
        
        return []
    }
    func fileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let filename = "folders.json"
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        return fileURL
    }
}
