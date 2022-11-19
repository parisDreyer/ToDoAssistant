//
//  ResponseCategoryModel+SurveyExtensions.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 5/23/21.
//  Copyright © 2021 Luke Dreyer. All rights reserved.
//

import Foundation

extension ResponseCategoryModel {
    private enum Constants {
        static let survey = "SURVEY"
        static let citizenship = "CITIZENSHIP"
        static let bot = "BOT"
        static let google = "GOOGLE"
    }

    func calculateIsSurveyRequest() -> Bool {
        guard response.count <= GlobalConstants.eighty else { return false }
        let words = response.split(separator: GlobalConstants.spaceSeparator)
        return words.contains { $0.uppercased() == Constants.survey }
    }

    func surveyId() -> SurveyId {
        guard response.count <= GlobalConstants.eighty else { return .none }
        let words = response.split(separator: GlobalConstants.spaceSeparator)
        if (words.contains(where: { $0.uppercased() == Constants.survey })) {
            if (words.contains(where: { $0.uppercased() == Constants.citizenship })) {
                return .citizenship
            } else if (words.contains(where: { $0.uppercased() == Constants.bot })) {
                return .bot
            } else if (words.contains(where: { $0.uppercased() == Constants.google })) {
                return .google
            } else {
                return .none
            }
        } else {
            return .none
        }
    }
}
