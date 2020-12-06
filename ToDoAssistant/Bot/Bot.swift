//
//  Bot.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 9/19/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import Foundation

final class Bot {
    private var categoryDictionary = CategoryDictionary()
    private var previousUserInput: ResponseCategory?
    private var previousResponse: ResponseCategory?
    private(set) var interactor: BotInteractorInput

    init(interactor: BotInteractorInput) {
        self.interactor = interactor
    }

    func respond(message: Message, _ callback: SetMessage?) {
        guard let response = buildMessage(message) else { return }
        callback?(response)
    }
}

// MARK: - Private

private extension Bot {
    func buildMessage(_ userInput: Message) -> Message? {
        let currentUserResponse = ResponseCategory(response: userInput.message, categoryDictionary: categoryDictionary, previousResponse: previousUserInput)
        guard let currentBotResponse = botResponse(for: currentUserResponse) else {
            return nil
        }

        previousUserInput = currentUserResponse
        categoryDictionary.update(category: currentUserResponse)

        previousResponse = ResponseCategory(response: currentBotResponse, categoryDictionary: categoryDictionary, previousResponse: previousResponse)
        if let previousResponse = previousResponse {
            categoryDictionary.update(category: previousResponse)
        }

        return Message(id: userInput.id + 1, sender: .bot, message: currentBotResponse)
    }



    func botResponse(for category: ResponseCategory) -> String? {
        guard let action = categoryDictionary.action(category: category) else {
            return nil
        }

        let conversationResponse = responseFor(action)
        return news + conversationResponse
    }

    func responseFor(_ action: Action) -> String {
        switch action {
        case .getMoreInfo(let about):
            return "Could you tell me more about what \(about.response) means?"
        case .askQuestion(let about):
            return "Why do you say \(about.response)?"
        case .tellFact(let about):
            return "I have often heard that \(about.response)"
        case .confirm(let userResponse):
            return "I agree with \(userResponse.response)"
        case .deny(let userResponse):
            return "I don't know about \(userResponse.response)"
        case .greet:
            return "Hi!"
        case .getNews:
            interactor.getNews()
            return "... Fetching News ..."
        case .getContacts:
            interactor.getContacts()
            return "... Fetching Contacts ..."
        }
    }
}

// MARK: - BotInteractorOutput

extension Bot: BotInteractorOutput { 
}
