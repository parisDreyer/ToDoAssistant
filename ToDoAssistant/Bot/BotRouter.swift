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
    func displaySurvey(delegate: SurveyDelegate)
}

class BotRouter {
    private(set) weak var displayManager: DisplayManagerInput?

    init(displayManager: DisplayManagerInput?) {
        self.displayManager = displayManager
    }
}

extension BotRouter: BotRouterInput {

    func displayContacts() {
        guard let displayManager = displayManager else {
            displayError(message: "Could not get display manager")
            return
        }
        let router = ContactsRouter(displayManager: displayManager)
        router.present()
    }

    func displaySurvey(delegate: SurveyDelegate) {
        guard let displayManager = displayManager else {
            displayError(message: "Could not get display manager")
            return
        }
        let router = SurveyRouter(displayManager: displayManager, surveyDelegate: delegate)
        router.present()
    }

    func displayError(message: String) {
        displayManager?.displayError(error: message)
    }
}
