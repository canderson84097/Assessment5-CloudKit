//
//  ContactListTableViewController.swift
//  iCloudAssessment
//
//  Created by Chris Anderson on 12/13/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

import UIKit

class ContactListTableViewController: UITableViewController {
    
    var contacts = ContactController.shared.contacts
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ContactController.shared.fetchContact { (contacts) in
            self.contacts = contacts
            self.updateViews()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.main.async {
            self.updateViews()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath)
        
        let contact = contacts[indexPath.row]
        
        cell.textLabel?.text = contact.name

        return cell
    }
    
    // MARK: - Custom Methods
    
    func updateViews() {
        DispatchQueue.main.async {
            self.loadViewIfNeeded()
            self.tableView.reloadData()
        }
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            guard let index = tableView.indexPathForSelectedRow,
                let destinationVC = segue.destination as? ContactDetailViewController else { return }
            let contactToSend = contacts[index.row]
            destinationVC.contactLanding = contactToSend
        }
    }

}
