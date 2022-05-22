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
    func displaySurvey(id: SurveyId, delegate: SurveyDelegate)
}

protocol BotRouterOutput: AnyObject {
    func saveData()
}

class BotRouter {
    private(set) weak var displayManager: DisplayManagerInput?
    weak var interactor: BotRouterOutput?

    init(displayManager: DisplayManagerInput?) {
        self.displayManager = displayManager
        self.displayManager?.setDelegate(self)
    }

    func present() {
        // TODO: - refactor BotRouter and MessagesViewPresenter so that this router is the sole interface for the bot

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

    func displaySurvey(id: SurveyId, delegate: SurveyDelegate) {
        guard let displayManager = displayManager else {
            displayError(message: "Could not get display manager")
            return
        }
        let router = SurveyRouter(displayManager: displayManager, surveyDelegate: delegate)
        router.present(id: id)
    }

    func displayError(message: String) {
        displayManager?.displayError(error: message)
    }
}

extension BotRouter: DisplayManagerDelegate {
    func save() {
        interactor?.saveData()
    }
}
