//
//  StringUniqueIdEncodeDecodeTests.swift
//  ToDoAssistantTests
//
//  Created by Luke Dreyer on 1/29/22.
//  Copyright © 2022 Luke Dreyer. All rights reserved.
//

import Foundation
@testable import ToDoAssistant
import XCTest

class StringUniqueIdEncodeDecodeTests: XCTestCase {
    private enum Constants {
        static let testUniqueId: Double = 0.6701010650101084
        static let testUniqueWord = "CAT"
    }
    override func setUp() {
        super.setUp()
    }

    func testEncode() {
        let word = Constants.testUniqueWord
        let uniqueId = word.calculateUniqueIdentifier()

        XCTAssertEqual(uniqueId, Constants.testUniqueId)
    }

    func testDecode() {
        let id = Constants.testUniqueId
        let word = String.from(calculatedUniqueIdentifier: id)

        XCTAssertEqual(word, Constants.testUniqueWord)
    }
}
