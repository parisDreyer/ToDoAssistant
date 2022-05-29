//
//  ContactsTests.swift
//  ToDoAssistantTests
//
//  Created by Luke Dreyer on 12/28/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import Foundation
@testable import ToDoAssistant
import XCTest

class ContactsTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    func testPresent() {
        let mockDisplayManager = MockDisplayManager()
        let router = ContactsRouter(displayManager: mockDisplayManager)
        router.present()

        XCTAssertTrue(mockDisplayManager.presentedViewController is ContactsViewController)
    }
}
