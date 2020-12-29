//
//  ContactsInteractor.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 11/27/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import Foundation
import UIKit
import AddressBook
import Contacts

protocol ContactsInteractorInput: AnyObject {
    func getData()
    func openURL(urlString: String)
}

final class ContactsInteractor {
    struct Entity {
        let contacts: [Contact]
    }

    private(set) var entity = Entity(contacts: [])
    let repository: ContactsRepositoryInput
    let router: ContactsRouterInput
    var presenter: ContactsPresenterInput?

    init(router: ContactsRouterInput, repository: ContactsRepository) {
        self.router = router
        self.repository = repository
        repository.interactor = self
    }

}

// MARK: - Private

extension ContactsInteractor: ContactsInteractorInput {
    func openURL(urlString: String) {
        guard  let url = URL(string: urlString) else {
            displayError(URLError(.badURL, userInfo: ["message": "ContactsInteractor: Could not build url with string: \(urlString)"]))
            return
        }
        router.open(url: url)
    }

    func getData() {
        repository.getContacts()
    }
}

// MARK: - ContactsRepositoryOutput

extension ContactsInteractor: ContactsRepositoryOutput {

    func displaySettingsActionSheet() {
        router.show(alert: "This app needs access to contacts in order to ...", title: "Permission to Contacts", style: .actionSheet)
    }

    func displayContacts(_ contacts: [CNContact]) {
        let formatter = CNContactFormatter()
        formatter.style = .fullName

        let contactsList: [Contact] = contacts.map { contact -> Contact in
            let image: UIImage?
            if let imageData = contact.imageData {
                image = UIImage(data: imageData)
            } else {
                image = nil
            }
            let name = formatter.string(from: contact)
            let phoneNumber: String? = contact.phoneNumbers.first?.value.stringValue
            let emailAddress: String?
            if let address = contact.emailAddresses.first?.value {
                emailAddress = String(address)
            } else {
                emailAddress = nil
            }
            return Contact(image: image, name: name, phoneNumber: phoneNumber, emailAddress: emailAddress)
        }
        entity = Entity(contacts: contactsList)
        presenter?.present(entity: entity)
    }

    func displayError(_ error: Error) {
        router.display(error: error.localizedDescription)
    }

}
