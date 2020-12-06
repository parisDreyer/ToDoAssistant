//
//  ContactsRouter.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 11/28/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import UIKit

protocol ContactsRouterInput: AnyObject {
    func show(alert: String, title: String, style: UIAlertController.Style)
    func display(error: String)
}

class ContactsRouter {
    private weak var displayManager: DisplayManagerInput?

    init(displayManager: DisplayManagerInput) {
        self.displayManager = displayManager
    }

    func present(viewInput: ContactsViewInput) {
        let repository = ContactsRepository()
        let interactor = ContactsInteractor(router: self, repository: repository)
        let presenter = ContactsPresenter(interactor: interactor)
        presenter.view = viewInput
        interactor.presenter = presenter
    }
}

// MARK: - ContactsRouterInput

extension ContactsRouter: ContactsRouterInput {

    func display(error: String) {
        displayManager?.displayError(error: error)
    }

    func show(alert: String, title: String, style: UIAlertController.Style) {
        displayManager?.displayAlert(alert: alert, title: title, style: style)
    }
}
