//
//  Contact.swift
//  iCloudAssessment
//
//  Created by Chris Anderson on 12/13/19.
//  Copyright © 2019 Renaissance Apps. All rights reserved.
//

import Foundation
import CloudKit

class Contact {
    var name: String
    var number: String?
    var email: String?
    let recordID: CKRecord.ID
    
    init (name: String, number: String = "", email: String = "", recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.name = name
        self.number = number
        self.email = email
        self.recordID = recordID
    }
}

extension Contact {
    convenience init?(ckRecord: CKRecord) {
        guard let name = ckRecord[ContactConstants.nameKey] as? String,
            let number = ckRecord[ContactConstants.numberKey] as? String,
            let email = ckRecord[ContactConstants.emailKey] as? String
            else { return nil }
        self.init(name: name, number: number, email: email, recordID: ckRecord.recordID)
    }
}

extension CKRecord {
    convenience init(contact: Contact) {
        self.init(recordType: ContactConstants.contactKey, recordID: contact.recordID)
        
        setValue(contact.name, forKey: ContactConstants.nameKey)
        setValue(contact.number, forKey: ContactConstants.numberKey)
        setValue(contact.email, forKey: ContactConstants.emailKey)
    }
}

extension Contact: Equatable {
    static func == (lhs: Contact, rhs: Contact) -> Bool {
        return lhs.recordID == rhs.recordID
    }
}

enum ContactConstants {
    static let contactKey = "Contact"
    static let nameKey = "name"
    static let numberKey = "number"
    static let emailKey = "email"
}
