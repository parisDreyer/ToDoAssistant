//
//  ReflectOnResponseTests.swift
//  ToDoAssistantTests
//
//  Created by Luke Dreyer on 5/29/22.
//  Copyright © 2022 Luke Dreyer. All rights reserved.
//

import Foundation
import XCTest
@testable import ToDoAssistant

final class MockOptionsList: Decidable {
    var list: [Option] = []
}

final class MockDecision: Decision {
    var makeFromChoicesResponse = false
    var didMakeFromChoices = false
    func make(from choices: Decidable) -> Bool {
        didMakeFromChoices = true
        return makeFromChoicesResponse
    }

    var decidableResponse: Decidable = MockOptionsList()
    var didGetChoices = false
    func getChoices(from evaluation: EvaluateResponse) -> Decidable {
        didGetChoices = true
        return decidableResponse
    }
}

final class ReflectOnResponseTests: XCTestCase {
    private var dependencies: MockAppDependencies!
    private var reflectOnResponse: ReflectOnResponse!

    override func setUp() {
        super.setUp()
        dependencies = MockAppDependencies()
        reflectOnResponse = ReflectOnResponse(dependencies: dependencies,
                                              response: "Here is a test string")
    }

    override func tearDown() {
        super.tearDown()
        dependencies = nil
        reflectOnResponse = nil
    }

    func testShouldDoAgainWhenResponseIsFalse() {
        XCTAssertFalse(dependencies.mockDecision.makeFromChoicesResponse)
        XCTAssertFalse(reflectOnResponse.shouldDoAgain())
    }

    func testShouldDoAgainWhenResponseIsTrue() {
        dependencies.mockDecision.makeFromChoicesResponse = true
        XCTAssertTrue(reflectOnResponse.shouldDoAgain())
    }
}
