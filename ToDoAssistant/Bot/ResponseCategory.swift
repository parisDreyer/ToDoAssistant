//
//  ResponseCategory.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 9/19/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import Foundation

final class ResponseCategory {
    private(set) var model: ResponseCategoryModel
    weak var categoryDictionary: CategoryDictionary?

    init(response: String,
        categoryDictionary: CategoryDictionary,
        previousResponse: ResponseCategory? = nil) {
        model = ResponseCategoryModel(response: response.uppercased(),
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
}

// MARK: - Categorizable

extension ResponseCategory: Categorizable {

    var possibleUniqueIdentifier: Double {
        return model.uniqueIdentifier()
    }

}
