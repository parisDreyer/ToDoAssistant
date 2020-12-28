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
    func open(url: URL)
    
}

final class ContactsRouter {
    private weak var displayManager: DisplayManagerInput?
    private var viewController: ContactsViewController?

    init(displayManager: DisplayManagerInput) {
        self.displayManager = displayManager
    }

    func present() {
        let interactor = ContactsInteractor(router: self, repository: ContactsRepository())
        let presenter = ContactsPresenter(interactor: interactor)
        interactor.presenter = presenter
        let viewController = ContactsViewController(presenter: presenter)
        presenter.view = viewController

        displayManager?.present(viewController: viewController)
        self.viewController = viewController
    }
}

// MARK: - ContactsRouterInput

extension ContactsRouter: ContactsRouterInput {
    func open(url: URL) {
        guard UIApplication.shared.canOpenURL(url) else {
            display(error: "ContactsRouter: Cannot open url \(url.absoluteString)")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    func display(error: String) {
        displayManager?.displayError(error: error)
    }

    func show(alert: String, title: String, style: UIAlertController.Style) {
        displayManager?.displayAlert(alert: alert, title: title, style: style)
    }
}
