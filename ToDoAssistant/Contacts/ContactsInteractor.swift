//
//  ContactsInteractor.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 11/27/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import Foundation
import AddressBook
import Contacts

protocol ContactsInteractorInput: AnyObject {
    func getData()
}

class ContactsInteractor {
    struct Entity {
        let contacts: [CNContact]
    }

    let repository: ContactsRepositoryInput
    let router: ContactsRouterInput
    weak var presenter: ContactsPresenterInput?

    init(router: ContactsRouterInput, repository: ContactsRepositoryInput) {
        self.router = router
        self.repository = repository
    }
    
    
}

// MARK: - Private

extension ContactsInteractor: ContactsInteractorInput {
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
        presenter?.present(entity: .init(contacts: contacts))
    }

    func displayError(_ error: Error) {
        router.display(error: error.localizedDescription)
    }

}

// MARK: - ContactsPresenterOutput

extension ContactsInteractor: ContactsPresenterOutput {

}
