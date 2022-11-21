//
//  Action.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 9/19/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import Foundation

enum Action {
    case getNews
    case getContacts
    case getMoreInfo(about: ResponseCategoryModel)
    case askQuestion(about: ResponseCategoryModel)
    case tellFact(about: ResponseCategoryModel)
    case confirm(userResponse: ResponseCategoryModel)
    case deny(userResponse: ResponseCategoryModel)
    case getSurvey(surveyId: SurveyId = .none)
    case greet
    case rememberedResponse(response: ResponseCategoryModel)
    case wiki
}

// MARK: Hashable

extension Action: Hashable {

    static func == (lhs: Action, rhs: Action) -> Bool {
        let lhsId = lhs.possibleUniqueIdentifier
        let rhsId = rhs.possibleUniqueIdentifier

        if lhsId == nil && rhsId == nil {
            return true
        } else if let lhsId = lhsId, let rhsId = rhsId {
            return lhsId == rhsId
        } else {
            return false
        }
    }

}

// MARK: - Private

private extension Action {

    var possibleUniqueIdentifier: String? {
        switch self {
        case .getMoreInfo(let category), .askQuestion(let category), .tellFact(let category), .confirm(let category), .deny(let category), .rememberedResponse(let category):
            return category.possibleUniqueIdentifier
        case .greet:
            return StaticActionID.greet.rawValue
        case .getNews:
            return StaticActionID.news.rawValue
        case .getContacts:
            return StaticActionID.contacts.rawValue
        case .getSurvey:
            return StaticActionID.survey.rawValue
        case .wiki:
            return StaticActionID.wiki.rawValue
        }
    }

}
