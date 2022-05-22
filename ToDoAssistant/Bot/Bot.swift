//
//  Bot.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 9/19/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import Foundation

final class Bot {
    typealias Dependencies = ResponseCategory.Dependencies
    private let dependencies: Dependencies
    private(set) var interactor: BotInteractorInput
    private weak var presenter: MessageViewPresenterInput?

    init(dependencies: Dependencies,
         interactor: BotInteractorInput,
         presenter: MessageViewPresenterInput) {
        self.dependencies = dependencies
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
        let currentUserResponse = ResponseCategory(dependencies: dependencies,
                                                   response: userInput.message,
                                                   previousResponse: interactor.previousUserInput)
        guard let currentBotResponse = botResponse(for: currentUserResponse) else {
            return nil
        }

        interactor.previousUserInput = currentUserResponse
        dependencies.categoryDictionary.update(category: currentUserResponse)

        let previousResponse = ResponseCategory(dependencies: dependencies,
                                                response: currentBotResponse,
                                                previousResponse: interactor.previousResponse)
        dependencies.categoryDictionary.update(category: previousResponse)
        interactor.previousResponse = previousResponse

        return Message(id: userInput.id + 1, sender: .bot, message: currentBotResponse)
    }

    func botResponse(for category: ResponseCategory) -> String? {
        guard let action = dependencies.categoryDictionary.action(category: category) else {
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
        case .getSurvey(let surveyId):
            interactor.getSurvey(id: surveyId)
            return "...Fetching Survey ..."
        case .getMoreInfo(let about):
            return "Could you tell me more about what \(about.response) means?"
        case .askQuestion(let about):
            return "Why do you say \(about.response)?"
        case .tellFact(let about):
            guard let response = interactor.answer(question: about.response) else {
                return "I have often heard that \(about.response)"
            }
            return response
        case .confirm(let userResponse):
            return "I agree with \(userResponse.response)"
        case .deny(let userResponse):
            return "I don't know about \(userResponse.response)"
        case .greet:
            return "Hi!"
        case .rememberedResponse(let remembered):
            return remembered.response
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
        if let previousUserInput = interactor.previousUserInput {
            let model = previousUserInput.model
            questions[model.response] = getQuestionsFromModel(model)
        }
        if let previousResponse = interactor.previousResponse {
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
