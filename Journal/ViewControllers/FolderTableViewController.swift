//
//  FolderTableViewController.swift
//  Journal
//
//  Created by Jason Goodney on 8/23/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit

class FolderTableViewController: UITableViewController {
    
    let cellId = "FolderCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        updateView()
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
        
    }
    
    func updateView() {
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return FolderController.shared.folders.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)

        let folder = FolderController.shared.folders[indexPath.row]
        
        cell.textLabel?.text = folder.name
        cell.detailTextLabel?.text = "\(folder.entries.count)"

        return cell
    }


    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let folder = FolderController.shared.folders[indexPath.row]
            FolderController.shared.removeFolder(folder)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @IBAction func addFolderTapped(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "New Folder", message: "Enter a name for this folder.", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Name"
            textField.autocapitalizationType = .words
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            
            guard let text = alertController.textFields?[0].text else { return }
            let name = text != "" ? text : "New Folder"
            
            FolderController.shared.addFolder(with: name)
            self.tableView.reloadData()
        }
    
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFolderEntries" {
            let destinationVC = segue.destination as? JournalTableViewController
            guard let index = tableView.indexPathForSelectedRow?.row else { return }
            let folder = FolderController.shared.folders[index]
            destinationVC?.folder = folder
        }
    }
    
}
