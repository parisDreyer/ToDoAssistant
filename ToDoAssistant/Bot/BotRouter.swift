//
//  BotRouter.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 11/28/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import Foundation

protocol BotRouterInput: AnyObject {
    func displayError(message: String)
    func displayContacts()
}

class BotRouter {
    weak var displayManager: DisplayManagerInput?
    
}

extension BotRouter: BotRouterInput {

    func displayContacts() {
        guard let displayManager = displayManager, let contactsView = displayManager.getContactsView else {
            displayError(message: "Could not get contacts view")
            return
        }
        let router = ContactsRouter(displayManager: displayManager)
        router.present(viewInput: contactsView)
    }

    func displayError(message: String) {
        displayManager?.displayError(error: message)
    }
}
