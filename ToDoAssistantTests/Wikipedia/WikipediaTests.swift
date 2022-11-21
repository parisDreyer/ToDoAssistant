//
//  WikipediaTests.swift
//  ToDoAssistantTests
//
//  Created by Luke Dreyer on 11/20/22.
//  Copyright © 2022 Luke Dreyer. All rights reserved.
//

import Foundation
import XCTest
@testable import ToDoAssistant

final class MockWikipediaDependencies: Wikipedia.Dependencies {
    var handledFailure = false
    func failure(_ error: Error) {
        handledFailure = true
    }

    var handledSuccess = false
    func success(_ response: [WikiPage]) {
        handledSuccess = true
    }
}

final class MockWikipediaRepositoryInput: WikipediaRepositoryInput {
    var gotData = false
    func getData() {
        gotData = true
    }

    var didSetDelegate = false
    func set(delegate: WikipediaRepositoryOutput) {
        didSetDelegate = true
    }
}

final class WikipediaTests: XCTestCase {
    private var wikipedia: Wikipedia!
    private var dependencies: MockWikipediaDependencies!
    private var repository: MockWikipediaRepositoryInput!
    private let question = ResponseCategoryModel(response: "what", previousResponse: "yes", previousResponseWasAffirmation: true, previousResponseWasNegation: false)

    override func setUp() {
        dependencies = .init()
        repository = .init()
        wikipedia = .init(dependencies, repository: repository, question: question)
        super.setUp()
    }

    override func tearDown() {
        wikipedia = nil
        dependencies = nil
        repository = nil
        super.tearDown()
    }

    func testShouldSendRequest() {
        XCTAssertTrue(wikipedia.shouldSendRequest())
    }

    func testGetData() {
        wikipedia.getData()
        XCTAssertTrue(repository.gotData)
    }

    func testHandleError() {
        wikipedia.handleError(URLError(.badServerResponse))
        XCTAssertTrue(dependencies.handledFailure)
    }

    func testHandleSuccess() {
        wikipedia.handleSuccess([])
        XCTAssertTrue(dependencies.handledSuccess)
    }

    func testInitSetsDelegate() {
        repository.didSetDelegate = false
        _ = Wikipedia(dependencies, repository: repository, question: question)
        XCTAssertTrue(repository.didSetDelegate)
    }
}
