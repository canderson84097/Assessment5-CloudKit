//
//  ContactController.swift
//  iCloudAssessment
//
//  Created by Chris Anderson on 12/13/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

import Foundation
import CloudKit

class ContactController {
    
    static let shared = ContactController()
    
    var contacts: [Contact] = []
    
    let publicDB = CKContainer.default().publicCloudDatabase
    
    func createContactWith(name: String, completion: @escaping (Contact?) -> Void ) {
        let contact = Contact(name: name)
        let record = CKRecord(contact: contact)
        publicDB.save(record) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
                return
            }
            guard let record = record else { completion(nil); return }
            let contact = Contact(ckRecord: record)
            guard let newContact = contact else { completion(nil); return }
            completion(newContact)
        }
    }
    
    func fetchContact(completion: @escaping ([Contact]) -> Void) {
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: ContactConstants.contactKey, predicate: predicate)
        
        publicDB.perform(query, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                completion([])
                return
            }
            guard let records = records else { completion([]); return }
            let contacts = records.compactMap({ Contact(ckRecord: $0) })
            completion(contacts)
        }
    }
    
    func updateContact(contact: Contact, name: String, number: String, email: String, completion: @escaping (Bool) -> Void) {
        
        contact.name = name
        contact.number = number
        contact.email = email
        
        let record = CKRecord(contact: contact)
        
        let operation = CKModifyRecordsOperation(recordsToSave: [record], recordIDsToDelete: nil)
        
        operation.savePolicy = .changedKeys
        operation.qualityOfService = .userInteractive
        operation.modifyRecordsCompletionBlock = { (records, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) /n---/n \(error)")
                completion(false)
                return
            }
            guard records != nil else { completion(false); return }
            completion(true)
        }
        publicDB.add(operation)
    }
}
