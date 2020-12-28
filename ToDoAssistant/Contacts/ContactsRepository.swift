//
//  ContactsRepository.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 11/28/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import Foundation
import AddressBook
import Contacts

protocol ContactsRepositoryInput: AnyObject {
    func getContacts()
}

protocol ContactsRepositoryOutput: AnyObject {
    func displaySettingsActionSheet()
    func displayContacts(_ contacts: [CNContact])
    func displayError(_ error: Error)
}

class ContactsRepository {
    weak var interactor: ContactsRepositoryOutput?
}

extension ContactsRepository: ContactsRepositoryInput {
    func getContacts() {
        let status = CNContactStore.authorizationStatus(for: .contacts)
        if status == .denied || status == .restricted {
            interactor?.displaySettingsActionSheet()
            return
        }

        let store = CNContactStore()
        store.requestAccess(for: .contacts) { [weak self] granted, error in
            guard granted else {
                DispatchQueue.main.async {
                    self?.interactor?.displaySettingsActionSheet()
                }
                return
            }

            // get the contacts

            var contacts = [CNContact]()
            let request = CNContactFetchRequest(keysToFetch: [
                CNContactIdentifierKey as NSString,
                CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
                CNContactPhoneNumbersKey as NSString,
                CNContactEmailAddressesKey as NSString,
                CNContactImageDataKey as NSString
            ])
            do {
                try store.enumerateContacts(with: request) { contact, stop in
                    contacts.append(contact)
                }
            } catch {
                self?.interactor?.displayError(error)
            }
            self?.interactor?.displayContacts(contacts)
        }
    }
    
    
}
