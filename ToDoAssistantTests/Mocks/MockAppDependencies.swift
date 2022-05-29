//
//  MockAppDependencies.swift
//  ToDoAssistantTests
//
//  Created by Luke Dreyer on 5/29/22.
//  Copyright © 2022 Luke Dreyer. All rights reserved.
//

import Foundation
@testable import ToDoAssistant

final class MockAppDependencies: SceneDelegate.Dependencies {
    var categoriesDao: CategoriesDaoInput { mockCategoriesDao }
    var mockCategoriesDao = MockCategoriesDao()

    var categoryDictionary: CategoryDictionary = CategoryDictionary()

    var decider: Decision { mockDecision }
    var mockDecision = MockDecision()

    var displayManager: DisplayManagerInput { mockDisplayManager }
    var mockDisplayManager = MockDisplayManager()
}
