//
//  BotInteractorTests.swift
//  ToDoAssistantTests
//
//  Created by Luke Dreyer on 5/29/22.
//  Copyright © 2022 Luke Dreyer. All rights reserved.
//

import Foundation
import XCTest
@testable import ToDoAssistant

final class MockBotRouter: BotRouterInput {
    var didDisplayError = false
    func displayError(message: String) {
        didDisplayError = true
    }

    var didDisplayContacts = false
    func displayContacts() {
        didDisplayContacts = true
    }

    var didDisplaySurvey = false
    func displaySurvey(id: SurveyId, delegate: SurveyDelegate) {
        didDisplaySurvey = true
    }
}

final class MockBotInteractorOutput: BotInteractorOutput {
    var didGetQuestions = false
    func getQuestions() -> [String : [String]] {
        didGetQuestions = true
        return [:]
    }

    var didUpdate = false
    func update(response: String) {
        didUpdate = true
    }
}

final class BotInteractorTests: XCTestCase {
    private var dependencies: MockAppDependencies!
    private var router: MockBotRouter!
    private var interactor: BotInteractor!
    private var bot: MockBotInteractorOutput!

    override func setUp() {
        super.setUp()
        dependencies = MockAppDependencies()
        router = MockBotRouter()
        interactor = BotInteractor(dependencies: dependencies, router: router)
        bot = MockBotInteractorOutput()
        interactor.bot = bot
    }

    override func tearDown() {
        super.tearDown()
        dependencies = nil
        router = nil
        interactor = nil
        bot = nil
    }

    func testPreviousUserInput() {
        XCTAssertNil(interactor.entity.previousUserInput)
        interactor.previousUserInput = makeResponse("What is new?")
        XCTAssertNotNil(interactor.entity.previousUserInput)
    }

    func testPreviousResponse() {
        XCTAssertNil(interactor.entity.previousResponse)
        interactor.previousResponse = makeResponse("What is new?")
        XCTAssertNotNil(interactor.entity.previousResponse)
    }

    func testAnswerQuestionWithNoConversationHistory() {
        XCTAssertNil(interactor.answer(question: "What is your favorite color?"))
    }

    func testAnswerQuestionWithConversationHistory() {
        self.interactor.previousUserInput = self.makeResponse("What is new?")
        self.interactor.previousResponse = self.makeResponse("sweet",
                                                             previous: self.makeResponse("Not much how about you?"))
        let loadBert = expectation(description: "waits for interactor to load BERT model")
        // TODO: - remove this hacky test asyncAfter stuff after we extract BERT to interactor Dependencies injection
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
            loadBert.fulfill()
        }

        wait(for: [loadBert], timeout: 11)
        XCTAssertNotNil(self.interactor.answer(question: "What is?"))
    }

    func testGetSurvey() {
        interactor.getSurvey(id: .bot)
        XCTAssertTrue(router.didDisplaySurvey)
    }

    func testGetContacts() {
        interactor.getContacts()
        XCTAssertTrue(router.didDisplayContacts)
    }

    func testGetNews() {
        // TODO: - Make this function testable
    }

    func testSaveData() {
        // TODO: - Add test on mock model
    }

    func testReceiveNews() {
        let news = News(articles: [
            Article(source: nil,
                    author: "self",
                    title: "test",
                    description: "super good news",
                    url: nil,
                    urlToImage: nil,
                    publishedAt: nil,
                    content: nil)
        ])
        interactor.receiveNews(news)
        XCTAssertEqual(interactor.entity.newsResponse?.articles?.first?.description,
                       news.articles?.first?.description)
        XCTAssertTrue(bot.didUpdate)
    }

    func testHandleError() {
        interactor.handleError(error: GeneralError(message: "Test"))
        XCTAssertTrue(router.didDisplayError)
    }
}

// MARK: - Private

private extension BotInteractorTests {
    func makeResponse(_ message: String?, previous: ResponseCategory? = nil) -> ResponseCategory {
        return .init(dependencies: dependencies,
                     response: message,
                     previousResponse: previous)
    }
}
