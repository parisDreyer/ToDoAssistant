//
//  BotInteractor.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 11/7/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import Foundation

protocol BotInteractorInput: AnyObject {
    func getNews()
    func getContacts()
    func getSurvey(id: SurveyId)
    func answer(question: String) -> String?
    var previousUserInput: ResponseCategory? { get set }
    var previousResponse: ResponseCategory? { get set }
}

protocol BotInteractorOutput: AnyObject {
    func getQuestions() -> [String: [String]]
    func update(response: String)
}

final class BotInteractor {
    struct Entity {
        var newsResponse: News?
        var previousUserInput: ResponseCategory?
        var previousResponse: ResponseCategory?

        fileprivate func getNewsString() -> String? {
            return newsResponse?.articles?
                        .map { $0.asString }
                        .joined(separator: GlobalConstants.newLine) ?? GlobalConstants.emptyString
        }
        // refactor to handle all saved state from this file
    }

    private let router: BotRouterInput
    private(set) var entity: Entity = Entity(newsResponse: nil)
    private var pendingNewsRequest: NewsRequest?
    weak var bot: BotInteractorOutput?

    init(router: BotRouterInput) {
        self.router = router
    }
}

// MARK: - BotInteractorInput

extension BotInteractor: BotInteractorInput {
    var previousUserInput: ResponseCategory? {
        get { entity.previousUserInput }
        set { entity.previousUserInput = newValue }
    }

    var previousResponse: ResponseCategory? {
        get { entity.previousResponse }
        set { entity.previousResponse = newValue }
    }

    func answer(question: String) -> String? {
        let history = mapConversationHistory()
        guard !history.isEmpty else {
            return nil
        }
        do {
            let context = history.joined(separator: GlobalConstants.newLine)
            let answer =  try QuestionAnswerModel().predict(question: question,
                                                            context: context)
            return String(answer)
        } catch {
            handleError(error: error)
            return nil
        }
    }

    func getSurvey(id: SurveyId) {
        router.displaySurvey(id: id, delegate: self)
    }

    func getContacts() {
        router.displayContacts()
    }

    func getNews() {
        if pendingNewsRequest == nil {
            pendingNewsRequest = NewsRequest()
            pendingNewsRequest?.delegate = self
            pendingNewsRequest?.getNews()
        }
    }
}

// MARK: - BotRouterOutput

extension BotInteractor: BotRouterOutput {
    func saveData() {
        let history = getOrderedModelHistory()
        history.forEach { $0.save() }
    }
}

// MARK: NewsRequestDelegate

extension BotInteractor: NewsRequestDelegate {

    func receiveNews(_ news: News) {
        pendingNewsRequest = nil
        entity.newsResponse = news

        guard let newsString = entity.getNewsString() else {
            handleError(error: GeneralError(message: "News Response Empty", domain: .bot))
            return
        }
        bot?.update(response: newsString)
    }

    func handleError(error: Error) {
        router.displayError(message: error.localizedDescription)
    }

}

// MARK - Private

private extension BotInteractor {
    func mapConversationHistory(maxLength: Int = 100) -> [String] {
        let history = getOrderedModelHistory(maxLength: maxLength)
        return history.compactMap { $0.model.response }
    }

    func getOrderedModelHistory(maxLength: Int = 100) -> [ResponseCategory] {
        var history: [ResponseCategory] = []
        var currentUserResponse = entity.previousUserInput
        var currentResponse = entity.previousResponse

        while currentResponse != nil
              && currentUserResponse != nil
              && history.count < maxLength {

            if let userResponse = currentUserResponse {
                history.append(userResponse)
            }
            currentUserResponse = currentUserResponse?.previousResponse

            if let response = currentResponse {
                history.append(response)
            }
            currentResponse = currentResponse?.previousResponse

        }
        return history
    }
}

