//
//  EntryViewController.swift
//  Journal
//
//  Created by Jason Goodney on 8/22/18.
//  Copyright © 2018 Jason Goodney. All rights reserved.
//

import UIKit

class EntryViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var textBodyTextView: UITextView!
    
    lazy var date = Date()
    
    var entry: Entry?
    var folder: Folder?
    //var isUpdating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

    
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateView()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
    }

    // MARK: - Update Views
    func updateView() {
        setupTimestamp()
        setupTextView()
        hideKeyboardWhenSwipeDown()
        
        
        if isUpdating() {
            populateFieldsForUpdating()
            self.navigationItem.title = "Update Entry"
        } else {
            titleTextField.becomeFirstResponder()
        }
    }
    
    func isUpdating() -> Bool {
        if let _ = entry { return true }
        return false
    }

    func populateFieldsForUpdating() {
        guard let entry = entry else { return }
        
        titleTextField.text = entry.title
        textBodyTextView.text = entry.textBody
        
    }
    
    func setupTimestamp() {
        timestampLabel.text = formatTimestamp(date)
    }
    
    func setupTextView() {
        textBodyTextView.textContainerInset = UIEdgeInsetsMake(0, -4, 0, 0)
    }
    
    func formatTimestamp(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        
        let timestamp = "\(dateFormatter.string(from: date)) at \(timeFormatter.string(from: date))"
        
        return timestamp
    }
    
    // MARK: - Actions
    @IBAction func clearButtonTapped(_ sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "Clear journal entry text?", message: nil, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Clear", style: .destructive) { _ in
            self.textBodyTextView.text = ""
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let title = titleTextField.text, !title.isEmpty,
            let textBody = textBodyTextView.text, !textBody.isEmpty else { return }
        
        if let entry = entry {
            JournalController.shared.update(entry: entry, title: title, textBody: textBody, timestamp: date, to: folder)
        } else {
            JournalController.shared.addEntryWith(title: title, textBody: textBody, timestamp: date, to: folder)
        }
        
        navigationController?.popViewController(animated: true)
        
    }

}


extension UIViewController {
    // https://stackoverflow.com/users/1066828/fahim-parkar
    func hideKeyboardWhenTappedAround() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func hideKeyboardWhenSwipeDown() {
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(hideKeyboard))
        swipeGesture.direction = .down
        
        view.addGestureRecognizer(swipeGesture)
    }
}
