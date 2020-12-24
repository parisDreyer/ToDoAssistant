//
//  ContactsPresenter.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 11/28/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import UIKit

protocol ContactsPresenterInput: AnyObject {
    func present(entity: ContactsInteractor.Entity)
}

protocol ContactsPresenterOutput: AnyObject {
    
}

protocol ContactsViewInput: AnyObject {
    func showContactsList(contacts: [Contact])
}

class ContactsPresenter {
    let interactor: ContactsPresenterOutput
    weak var view: ContactsViewInput?

    init(interactor: ContactsPresenterOutput) {
        self.interactor = interactor
    }
}

// MARK: - ContactsPresenterInput

extension ContactsPresenter: ContactsPresenterInput {

    func present(entity: ContactsInteractor.Entity) {
        let contacts = entity.contacts.compactMap { contact -> Contact? in
            let image = contact.imageData.map { UIImage(data: $0) ?? nil } ?? nil
            let name = contact.givenName + contact.familyName
            let phoneNumbers = contact.phoneNumbers.map { $0.value.stringValue }.joined(separator: GlobalConstants.newLine)
            let email = contact.emailAddresses.map { $0.value as String }.joined(separator: GlobalConstants.newLine)
            let contactObject = Contact(image: image, name: name, phoneNumber: phoneNumbers, emailAddress: email)

            guard contactObject.hasSufficientDataForDisplay else { return nil }

            return contactObject
        }

        guard !contacts.isEmpty else { return }
        view?.showContactsList(contacts: contacts)
    }
}
