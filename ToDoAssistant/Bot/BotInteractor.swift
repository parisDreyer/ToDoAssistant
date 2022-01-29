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
}

protocol BotInteractorOutput: AnyObject {
    func getQuestions() -> [String: [String]]
    func update(response: String)
    func saveData()
}

final class BotInteractor {
    struct Entity {
        let newsResponse: News?

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
        bot?.saveData()
    }
}

// MARK: NewsRequestDelegate

extension BotInteractor: NewsRequestDelegate {

    func receiveNews(_ news: News) {
        pendingNewsRequest = nil
        entity = Entity(newsResponse: news)

        guard let newsString = entity.getNewsString() else {
            error(error: GeneralError(message: "News Response Empty", domain: .bot))
            return
        }
        bot?.update(response: newsString)
    }

    func error(error: Error) {
        router.displayError(message: error.localizedDescription)
    }

}

