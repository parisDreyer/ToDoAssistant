//
//  ResponseCategoryModel.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 9/19/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import Foundation

/// Corresonds to the Category DB Table
struct ResponseCategoryModel {
    let response: String
    let previousResponse: String?
    let previousResponseWasAffirmation: Bool?
    let previousResponseWasNegation: Bool?

    // NOTE: Only used in the var: possibleUniqueIdentifier
    // Since the possibleUniqueIdentifier var is expensive to compute we store it here after calculating
    private var calculatedUniqueIdentifier: Double?
    var possibleUniqueIdentifier: Double? {
        return calculatedUniqueIdentifier
    }

    init(response: String,
         previousResponse: String? = nil,
         previousResponseWasAffirmation: Bool? = nil,
         previousResponseWasNegation: Bool? = nil) {
        self.response = response
        self.previousResponse = previousResponse
        self.previousResponseWasAffirmation = previousResponseWasAffirmation
        self.previousResponseWasNegation = previousResponseWasNegation
    }
}

// MARK: - Internal

extension ResponseCategoryModel {
    var isExactSameResponse: Bool {
        response == previousResponse
    }

    var userRepeatedThemself: Bool {
        return isExactSameResponse
            || (isAffirmation && previousResponseWasAffirmation == true)
            || (isNegation && previousResponseWasNegation == true)
    }

    var isAffirmation: Bool {
        switch response {
        case "YES", "MHM", "AFFIRMATIVE", "UHUH", "YEAH", "YAH":
            return true
        default:
            return false
        }
    }

    var isNegation: Bool {
        switch response {
        case "NO", "NOPE", "NAH":
            return true
        default:
            return false
        }
    }

    mutating func isNewsRequest() -> Bool {
        if let calculatedUniqueIdentifier = calculatedUniqueIdentifier {
            return calculatedUniqueIdentifier == StaticActionID.news.rawValue
        }

        let isAskingForNews = calculateIsNewsRequest()
        if isAskingForNews {
            calculatedUniqueIdentifier = StaticActionID.news.rawValue
        }
        return isAskingForNews
    }

    mutating func isContactsRequest() -> Bool {
        if let calculatedUniqueIdentifier = calculatedUniqueIdentifier {
            return calculatedUniqueIdentifier == StaticActionID.contacts.rawValue
        }

        let isContacts = calculateIsContactsRequest()
        if isContacts {
            calculatedUniqueIdentifier = StaticActionID.contacts.rawValue
        }
        return isContacts
    }

    mutating func isSurveyRequest() -> Bool {
        if let calculatedUniqueIdentifier = calculatedUniqueIdentifier {
            return calculatedUniqueIdentifier == StaticActionID.survey.rawValue
        }
        let isSurvey = calculateIsSurveyRequest()
        if isSurvey {
            calculatedUniqueIdentifier = StaticActionID.survey.rawValue
        }
        return isSurvey
    }

    mutating func uniqueIdentifier() -> Double {
        if let calculatedUniqueIdentifier = calculatedUniqueIdentifier {
            return calculatedUniqueIdentifier
        }

        let identifier: Double
        if isNewsRequest() {
            identifier = StaticActionID.news.rawValue
        } else if isContactsRequest() {
            identifier = StaticActionID.contacts.rawValue
        } else if isSurveyRequest() {
            identifier = StaticActionID.survey.rawValue
        } else {
            let words = response.split(separator: " ")
            let verbosityCoefficient = (Double(words.count) - 1.0) / max(Double(words.count), 1.0)
            let uniqueWordNumber = words.map { word -> Double in
                word.asciiValues.reduce(1) { $1 == 0 ? $0 : $0 * Double($1) }
            }.reduce(1) { $0 * $1 }

            identifier = Double(verbosityCoefficient * (1.0 / uniqueWordNumber))
        }
        calculatedUniqueIdentifier = identifier
        return identifier
    }

}

// MARK: - Hashable

extension ResponseCategoryModel: Hashable {

    static func == (lhs: ResponseCategoryModel, rhs: ResponseCategoryModel) -> Bool {
        if let lhsId = lhs.calculatedUniqueIdentifier, let rhsId = rhs.calculatedUniqueIdentifier {
            return lhsId == rhsId
        }

        let hasSameGeneralCategorizationConstraints =
            lhs.userRepeatedThemself == rhs.userRepeatedThemself
            && lhs.isNegation == rhs.isNegation
            && lhs.isAffirmation == rhs.isAffirmation

        let testModel = ResponseCategoryModel(response: lhs.response,
                                              previousResponse: rhs.response,
                                              previousResponseWasAffirmation: rhs.isAffirmation,
                                              previousResponseWasNegation: rhs.isNegation)
        return testModel.isExactSameResponse && hasSameGeneralCategorizationConstraints
    }

}
