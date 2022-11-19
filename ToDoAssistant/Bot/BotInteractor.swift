//
//  BotInteractor.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 11/7/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import Foundation

protocol FailureOutput {
    func failure(_ error: Error)
}

protocol BotInteractorInput: AnyObject {
    func getNews()
    func getContacts()
    func getSurvey(id: SurveyId)
    func answer(question: String) -> String?
    func searchWiki()
    var previousUserInput: ResponseCategory? { get set }
    var previousResponse: ResponseCategory? { get set }
}

protocol BotInteractorOutput: AnyObject {
    func getQuestions() -> [String: [String]]
    func update(response: String)
}

final class BotInteractor {
    public typealias Dependencies = ReflectOnResponse.Dependencies
    struct Entity {
        var newsResponse: News?
        var previousUserInput: ResponseCategory?
        var previousResponse: ResponseCategory?
        var conversationLength = 0

        fileprivate func getNewsString() -> String? {
            return newsResponse?.articles?
                        .map { $0.asString }
                        .joined(separator: GlobalConstants.newLine) ?? GlobalConstants.emptyString
        }
        // refactor to handle all saved state from this file
    }

    private let dependencies: Dependencies
    private let router: BotRouterInput
    private(set) var entity: Entity = Entity(newsResponse: nil)
    private var pendingNewsRequest: NewsRequest?
    weak var bot: BotInteractorOutput?
    private var questionAnswerModel: QuestionAnswerModel?


    init(dependencies: Dependencies, router: BotRouterInput) {
        self.dependencies = dependencies
        self.router = router

        // background initialize expensive model and dictionary
        DispatchQueue.global(qos: .background).async {
            _ = BERTVocabulary.lookupDictionary
            DispatchQueue.main.async { [weak self] in
                self?.questionAnswerModel = try? QuestionAnswerModel()
            }
        }

    }
}

// MARK: - BotInteractorInput

extension BotInteractor: BotInteractorInput {
    var previousUserInput: ResponseCategory? {
        get { entity.previousUserInput }
        set {
            entity.previousUserInput = newValue
            entity.conversationLength += 1
        }
    }

    var previousResponse: ResponseCategory? {
        get { entity.previousResponse }
        set {
            entity.previousResponse = newValue
            entity.conversationLength += 1
        }
    }

    func searchWiki() {
        guard let model = previousUserInput?.model else {
            return
        }
        let wikipedia = Wikipedia(self, question: model)
        wikipedia.getData()
    }

    func answer(question: String) -> String? {
        let history = mapConversationHistory()
        guard !history.isEmpty else {
            return nil
        }
        do {
            let context = history.joined(separator: GlobalConstants.newLine)
            guard let answer = try questionAnswerModel?.predict(question: question,
                                                                context: context) else {
                return nil
            }
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
        // TODO: - evaluate dynamically if we want to `removeUndesiredSentimentTriggers`
        let history = getOrderedModelHistory(removeUndesiredSentimentTriggers: true)
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

//MARK: - FailureOutput

extension BotInteractor: FailureOutput {
    func failure(_ error: Error) {
        router.displayError(message: error.localizedDescription)
    }
}

// MARK: - WikipediaOutput

extension BotInteractor: WikipediaOutput {
    func success(_ response: [WikiPage]) {
        let synthesized = response.reduce("") {
            var section = ""
            if let title = $1.title {
                section += "\(title) "
            }
            if let extract = $1.extract {
                section += "\n\(extract)\n"
            }
            return $0 + section
        }
        bot?.update(response: synthesized)
    }
}

// MARK - Private

private extension BotInteractor {
    func mapConversationHistory(maxLength: Int = 100) -> [String] {
        let history = getOrderedModelHistory(maxLength: maxLength)
        return history.compactMap { $0.model.response }
    }

    func getOrderedModelHistory(maxLength: Int = 100,
                                removeUndesiredSentimentTriggers: Bool = false) -> [ResponseCategory] {
        var history: [ResponseCategory] = []
        var currentUserResponse = entity.previousUserInput
        // skip the last bot response because the user hasn't responded to it yet
        var currentResponse = entity.previousResponse?.previousResponse

        while currentResponse != nil
              && currentUserResponse != nil
              && history.count < maxLength {

            let avoidSaying = removeUndesiredSentimentTriggers
                              && !shouldContinue(saying: currentUserResponse?.model.response)
            if let userResponse = currentUserResponse {
                history.append(userResponse)
            }
            currentUserResponse = currentUserResponse?.previousResponse

            if !avoidSaying, let response = currentResponse {
                history.append(response)
            }
            currentResponse = currentResponse?.previousResponse

        }
        return history
    }

    func shouldContinue(saying wordSequence: String?) -> Bool {
        guard let wordSequence = wordSequence else {
            return false
        }
        return ReflectOnResponse(dependencies: dependencies,
                                 response: wordSequence).shouldDoAgain()
    }
}

