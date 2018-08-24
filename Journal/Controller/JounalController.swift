//
//  JounalController.swift
//  Journal
//
//  Created by Jason Goodney on 8/23/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import Foundation

class JournalController {
    
    enum CRUDError: Error {
        case indexFailure
        case updatedValuesError
    }
    
    static let shared = JournalController()
    
    var folderIndex: Int?
    
    init() { }
    
    var entries: [Entry] {
        get {
            guard let folder = folder else { return [] }
            let entries = folder.entries
            return entries
        }
        set (newEntries) {
            guard let folder = folder else { return }
            
            folder.entries = newEntries
        }
    }
    
    var folder: Folder?

    // MARK: - Create
    func addEntryWith(title: String, textBody: String, timestamp: Date, to folder: Folder?) {
        let entry = Entry(title: title, textBody: textBody, timestamp: timestamp)
        guard let folder = folder else {return }
        FolderController.shared.addEntryToFolder(folder: folder, entry: entry)
        
        FolderController.shared.saveToPersistantStore()
    }
    
    // MARK: - Update
    func update(entry: Entry, title: String?, textBody: String?, timestamp: Date, to folder: Folder?) {
        if let updatedtitle = title, let updatedTextBody = textBody, let folder = folder {
            let updatedEntry = Entry(title: updatedtitle, textBody: updatedTextBody, timestamp: timestamp)
            
            guard let index = folder.entries.index(of: entry) else {
                print("\(CRUDError.indexFailure) for entry: \(entry.title)")
                return
            }
            folder.entries[index] = updatedEntry
            FolderController.shared.saveToPersistantStore()
        } else {
            print("\(CRUDError.updatedValuesError) for OG entry: \(entry.title)")
        }
    }
    
    // MARK: - Delete
    func remove(entry: Entry) {
        if let index = entries.index(of: entry) {
            entries.remove(at: index)
            FolderController.shared.saveToPersistantStore()
        } else {
            print("\(CRUDError.indexFailure) for entry: \(entry.title)")
        }
    }
    
    
}

extension JournalController {
    // MARK: - Save
    func saveEntriesToPersistantStore(_ entries: [Entry]) {
        let je = JSONEncoder()
        do {
            let data = try je.encode(entries)
            try data.write(to: fileURL())
        } catch let e {
            print("Error saving entries: \(e))")
        }
    }
    
    // MARK: - Load
    func loadEntriesFromPersistantStore() -> [Entry] {
        let jd = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL())
            let entries = try jd.decode([Entry].self, from: data)
            return entries
        } catch let e {
            print("Error loading entries: \(e)")
        }
        
        return []
    }
    func fileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        let filename = "entries.json"
        let fileURL = documentsDirectory.appendingPathComponent(filename)
        return fileURL
    }
}
