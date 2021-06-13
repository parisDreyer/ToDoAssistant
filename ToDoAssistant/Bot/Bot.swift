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
    private weak var presenter: MessageViewPresenterInput?

    init(interactor: BotInteractorInput, presenter: MessageViewPresenterInput) {
        self.interactor = interactor
        self.presenter = presenter
    }

    func respond(message: Message) {
        guard let response = buildMessage(message) else { return }
        presenter?.receive(message: response)
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

        return responseFor(action)
    }

    func responseFor(_ action: Action) -> String {
        switch action {
        case .getNews:
            interactor.getNews()
            return "... Fetching News ..."
        case .getContacts:
            interactor.getContacts()
            return "... Fetching Contacts ..."
        case .getSurvey:
            interactor.getSurvey()
            return "...Fetching Survey ..."
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
        }
    }
}

// MARK: - BotInteractorOutput

extension Bot: BotInteractorOutput {
    func update(response: String) {
        let message = Message(id: -1, sender: .bot, message: response)
        presenter?.receive(message: message)
    }

    func getQuestions() -> [String : [String]] {
        var questions: [String: [String]] = [:]
        if let previousUserInput = previousUserInput {
            let model = previousUserInput.model
            questions[model.response] = getQuestionsFromModel(model)
        }
        if let previousResponse = previousResponse {
            let model = previousResponse.model
            questions[model.response] = getQuestionsFromModel(model)
        }
        return questions
    }

    private func getQuestionsFromModel(_ model: ResponseCategoryModel) -> [String] {
        var m = model
        return [
            "is this an Affirmation? We thought \(m.isAffirmation.yesOrNo)",
            "is this an Negation? We thought \(m.isNegation.yesOrNo)",
            "is this a Survey Request? We thought \(m.isSurveyRequest().yesOrNo)",
            "is this a Contacts Request? We thought \(m.isContactsRequest().yesOrNo)",
            "is this a News Request? We thought \(m.isNewsRequest().yesOrNo)",
            "is this the Exact Same Response? We thought \(m.isExactSameResponse.yesOrNo)"
        ]
    }
}
