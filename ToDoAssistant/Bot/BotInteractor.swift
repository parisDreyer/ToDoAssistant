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
    var news: News? { get }
    func getContacts()
    func getSurvey()
}

protocol BotInteractorOutput: AnyObject {
}

final class BotInteractor {
    struct Entity {
        let newsResponse: News?
        var hasDisplayedNews = false
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
        router.displaySurvey()
    }

    func getContacts() {
        router.displayContacts()
    }
    
    var news: News? {
        guard !entity.hasDisplayedNews, let response = entity.newsResponse else { return nil }
        entity.hasDisplayedNews = true
        return response
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
        entity = Entity(newsResponse: news, hasDisplayedNews: false)
    }
    
    func error(error: Error) {
        router.displayError(message: error.localizedDescription)
    }

}
