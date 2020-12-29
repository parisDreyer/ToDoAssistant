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

final class ContactsPresenter {
    let interactor: ContactsInteractorInput
    var view: ContactsViewInput?

    init(interactor: ContactsInteractorInput) {
        self.interactor = interactor
    }
}

// MARK: - ContactsPresenterInput

extension ContactsPresenter: ContactsPresenterInput {

    func present(entity: ContactsInteractor.Entity) {
        let contacts = entity.contacts.filter { $0.hasSufficientDataForDisplay }

        guard !contacts.isEmpty else { return }
        view?.showContactsList(contacts: contacts)
    }
}

// MARK: - ContactsViewOutput

extension ContactsPresenter: ContactsViewOutput {
    func sendEmail(to address: String) {
        interactor.openURL(urlString: "mailto://\(address)")
    }

    func makeCall(to number: String) {
        let numberWithoutPunctuation = number.trimPhonePunctuation()
        interactor.openURL(urlString: "tel://\(numberWithoutPunctuation)")
    }

    func getContacts() {
        interactor.getData()
    }

}
