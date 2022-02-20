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
    private(set) var model: ResponseCategoryModel
    private(set) var previousResponse: ResponseCategory?
    weak var categoryDictionary: CategoryDictionary?
    private lazy var categoriesDao: CategoriesDao = { () -> CategoriesDao in
        CategoriesDao()
    }()

    init(response: String? = nil,
        categoryDictionary: CategoryDictionary,
        previousResponse: ResponseCategory? = nil) {
        self.previousResponse = previousResponse
        model = ResponseCategoryModel(response: response?.uppercased() ?? GlobalConstants.emptyString,
                                      previousResponse: previousResponse?.model.response,
                                      previousResponseWasAffirmation: previousResponse?.model.isAffirmation,
                                      previousResponseWasNegation: previousResponse?.model.isNegation)
        self.categoryDictionary = categoryDictionary
    }

    var isNewsRequest: Bool {
        return model.isNewsRequest()
    }

    var isContactsRequest: Bool {
        return model.isContactsRequest()
    }

    var isSurveyRequest: Bool {
        return model.isSurveyRequest()
    }

    func getSurveyId() -> SurveyId {
        return model.surveyId()
    }

    var isUncategorized: Bool {
        let requiresMoreContext: Bool
        if case .getMoreInfo = categoryDictionary?.action(category: self) {
            requiresMoreContext = true
        } else {
            requiresMoreContext = false
        }
        return !model.isNegation
            && !model.isAffirmation
            && model.userRepeatedThemself
            && (categoryDictionary == nil || requiresMoreContext)
    }

    class func from(category: ResponseCategory) -> ResponseCategory? {
        guard let dictionary = category.categoryDictionary else {
            return nil
        }
        return .init(categoryDictionary: dictionary,
                     previousResponse: category.previousResponse)
    }
}

// MARK: - Categorizable

extension ResponseCategory: Categorizable {

    var possibleUniqueIdentifier: String {
        return model.uniqueIdentifier()
    }

}

// MARK: - StoredDataItem

extension ResponseCategory: StoredDataItem {
    func loadBy(primaryKey: Int64) {
        guard let row = categoriesDao.get(primaryKey: primaryKey) else {
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

    func loadBy(id: String) {
        guard let row = categoriesDao.get(identifier: id) else {
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
            try categoriesDao.insert(model: self)
        } catch {
            // todo error handling
        }
    }
}
