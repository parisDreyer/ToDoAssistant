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
    func getSurvey()
}

protocol BotInteractorOutput: AnyObject {
    func getQuestions() -> [String: [String]]
    func update(response: String)
}

final class BotInteractor {
    struct Entity {
        let newsResponse: News?

        fileprivate func getNewsString() -> String? {
            return newsResponse?.articles?
                        .map { $0.asString }
                        .joined(separator: GlobalConstants.newLine) ?? ""
        }
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
    func getSurvey() {
        router.displaySurvey(delegate: self)
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

