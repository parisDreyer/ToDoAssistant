//
//  ResponseCategory.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 9/19/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import Foundation

protocol Categorizable: AnyObject {
    var possibleUniqueIdentifier: String { get }
}

protocol StoredDataItem: AnyObject {
    func save()
    func loadBy(id: String)
    func loadBy(primaryKey: Int64)
}

struct Category: Decodable {
    let id: Int64
    let calculatedUniqueIdentifier: String
}

// Wrapper for ResponseCategoryModel
final class ResponseCategory {
    typealias Dependencies = CategoriesDaoDependency
                             & CategoryDictionaryDependency
    private let dependencies: Dependencies
    private(set) var model: ResponseCategoryModel
    private(set) var previousResponse: ResponseCategory?

    init(dependencies: Dependencies,
         response: String? = nil,
         previousResponse: ResponseCategory? = nil) {
        self.dependencies = dependencies
        self.previousResponse = previousResponse
        model = ResponseCategoryModel(response: response?.uppercased() ?? GlobalConstants.emptyString,
                                      previousResponse: previousResponse?.model.response,
                                      previousResponseWasAffirmation: previousResponse?.model.isAffirmation,
                                      previousResponseWasNegation: previousResponse?.model.isNegation)
    }

    var isNewsRequest: Bool {
        model.isNewsRequest()
    }

    var isContactsRequest: Bool {
        model.isContactsRequest()
    }

    var isSurveyRequest: Bool {
        model.isSurveyRequest()
    }

    func getSurveyId() -> SurveyId {
        model.surveyId()
    }

    var isUncategorized: Bool {
        let requiresMoreContext: Bool
        if case .getMoreInfo = dependencies.categoryDictionary.action(category: self) {
            requiresMoreContext = true
        } else {
            requiresMoreContext = false
        }
        return !model.isNegation
            && !model.isAffirmation
            && model.userRepeatedThemself
            && requiresMoreContext
    }

    /// Helper initializer to create a ResponseCategory object from another ResponseCategory instance
    class func from(category: ResponseCategory) -> ResponseCategory {
        .init(dependencies: category.dependencies, previousResponse: category.previousResponse)
    }
}

// MARK: - Categorizable

extension ResponseCategory: Categorizable {

    var possibleUniqueIdentifier: String {
        model.uniqueIdentifier()
    }

}

// MARK: - StoredDataItem

extension ResponseCategory: StoredDataItem {
    func loadBy(primaryKey: Int64) {
        guard let row = dependencies.categoriesDao.get(primaryKey: primaryKey) else {
            // todo error handling
            return
        }
        let decoder = row.decoder()
        do {
            let category = try Category(from: decoder)
            let calculatedUniqueIdentifier = category.calculatedUniqueIdentifier
            // this operation is expensive, maybe only do this if needed
            let responseString = String.from(calculatedUniqueIdentifier: calculatedUniqueIdentifier)

            guard let responseString = responseString else {
                // todo error handling
                return
            }
            let oldModel = model
            model = ResponseCategoryModel(response: responseString,
                                          primaryKey: category.id,
                                          previousResponse: oldModel.previousResponse,
                                          previousResponseWasAffirmation: oldModel.previousResponseWasAffirmation,
                                          previousResponseWasNegation: oldModel.previousResponseWasNegation)
        } catch {
            // todo error handling
        }
    }

    /// Load saved state by id from the database
    func loadBy(id: String) {
        guard let row = dependencies.categoriesDao.get(identifier: id) else {
            // todo error handling
            return
        }
        let decoder = row.decoder()
        do {
            let category = try Category(from: decoder)
            let calculatedUniqueIdentifier = category.calculatedUniqueIdentifier
            // this operation is expensive, maybe only do this if needed
            let responseString = String.from(calculatedUniqueIdentifier: calculatedUniqueIdentifier)

            guard let responseString = responseString else {
                // todo error handling
                return
            }
            let oldModel = model
            model = ResponseCategoryModel(response: responseString,
                                          primaryKey: category.id,
                                          previousResponse: oldModel.previousResponse,
                                          previousResponseWasAffirmation: oldModel.previousResponseWasAffirmation,
                                          previousResponseWasNegation: oldModel.previousResponseWasNegation)
        } catch {
            // todo error handling
        }

    }

    func save() {
        do {
            try dependencies.categoriesDao.insert(model: self)
        } catch {
            // todo error handling
        }
    }
}
