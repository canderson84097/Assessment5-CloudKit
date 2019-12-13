//
//  ContactDetailViewController.swift
//  iCloudAssessment
//
//  Created by Chris Anderson on 12/13/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

import UIKit

class ContactDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var contactLanding: Contact? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        guard let name = nameTextField.text, !name.isEmpty,
            let number = numberTextField.text,
            let email = emailTextField.text
            else { return }
        
        if let contact = contactLanding {
            ContactController.shared.updateContact(contact: contact, name: name, number: number, email: email) { (success) in
                if success {
                    DispatchQueue.main.async {
                        self.nameTextField.text = name
                        self.numberTextField.text = number
                        self.emailTextField.text = email
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else {
            ContactController.shared.createContactWith(name: name) { (contact) in
                if let contact = contact {
                    ContactController.shared.contacts.append(contact)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
    
    // MARK: - Custom Methods
    
    func updateViews() {
        guard let contact = contactLanding else { return }
        loadViewIfNeeded()
        nameTextField.text = contact.name
        numberTextField.text = contact.number
        emailTextField.text = contact.email
    }
}
