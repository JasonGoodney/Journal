//
//  JournalTableViewController.swift
//  Journal
//
//  Created by Jason Goodney on 8/22/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit

class JournalTableViewController: UITableViewController {
    
    let cellId = "journalEntryCell"
    
    var folderIndex: Int?
    
    var folder: Folder? {
        didSet {
            print("\(String(describing: folder))")
            print(folder?.name ?? "bad")
            self.tableView.reloadData()
        }
    }
//
//    var entries: [Entry]? {
//        get {
//            guard let i = folderIndex else { return nil }
//            return FolderController.shared.folders[i].entries
//        }
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()

    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        tableView.tableFooterView = UIView()
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    func formatTimestamp(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: date)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let entries = entries?.count else { print("No entries"); return 0}
        return folder?.entries.count ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? JournalEntryTableViewCell else { return UITableViewCell() }

        if let entry = folder?.entries[indexPath.row] {
            cell.titleLabel.text = entry.title
            cell.timestampLabel.text = formatTimestamp(entry.timestamp)
            cell.textPreviewLabel.text = entry.textBody
        }
        return cell
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            if let entries = folder?.entries {
                let entryToDelete = entries[indexPath.row]
                
                JournalController.shared.remove(entry: entryToDelete)
                
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toNewEntryVC" {
            let destinationVC = segue.destination as? EntryViewController
            guard let folder = folder else { print("No folder"); return }
            destinationVC?.folder = folder
            
        } else if segue.identifier == "toUpdateEntryVC" {
            let destinationVC = segue.destination as? EntryViewController
            
            guard let indexPath = tableView.indexPathForSelectedRow,
                let folder = folder else { print("No folder"); return }
            let entries = folder.entries
                        
            destinationVC?.entry = entries[indexPath.row]
            destinationVC?.folder = folder

        }
    }


}
