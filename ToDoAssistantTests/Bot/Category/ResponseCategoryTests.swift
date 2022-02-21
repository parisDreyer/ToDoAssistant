//
//  ResponseCategoryTests.swift
//  ToDoAssistantTests
//
//  Created by Luke Dreyer on 2/20/22.
//  Copyright © 2022 Luke Dreyer. All rights reserved.
//

import Foundation
import SQLite
import XCTest

@testable import ToDoAssistant

final class MockCategoriesDao: CategoriesDaoInput {
    var didInsertModel = false
    func insert(model: ResponseCategory) throws {
        didInsertModel = true
    }

    var didGetByIdentifier = false
    func get(identifier: String) -> Row? {
        didGetByIdentifier = true
        return nil
    }

    var didGetByPrimaryKey = false
    func get(primaryKey: Int64) -> Row? {
        didGetByPrimaryKey = true
        return nil
    }
}

struct MockResponseCategoryDependencies: ResponseCategory.Dependencies {
    var categoriesDao: CategoriesDaoInput
    var mockCategoriesDao: MockCategoriesDao? {
        categoriesDao as? MockCategoriesDao
    }

    var categoryDictionary: CategoryDictionary
}

class ResponseCategoryTests: XCTestCase {
    var dependencies: MockResponseCategoryDependencies!
    var responseCategory: ResponseCategory!

    override func setUp() {
        dependencies = MockResponseCategoryDependencies(categoriesDao: MockCategoriesDao(), categoryDictionary: CategoryDictionary())
        responseCategory = ResponseCategory(dependencies: dependencies,
                                            response: nil,
                                            previousResponse: nil)
        super.setUp()
    }

    override func tearDown() {
        dependencies = nil
        responseCategory = nil
        super.tearDown()
    }

    func testThatSavesResponse() {
        responseCategory.save()

        XCTAssertTrue(dependencies.mockCategoriesDao?.didInsertModel == true)
    }

    func testThatLoadsByPrimaryKey() {
        responseCategory.loadBy(primaryKey: 1)

        XCTAssertTrue(dependencies.mockCategoriesDao?.didGetByPrimaryKey == true)
    }

    func testThatLoadsById() {
        responseCategory.loadBy(id: "test")

        XCTAssertTrue(dependencies.mockCategoriesDao?.didGetByIdentifier == true)
    }
}
