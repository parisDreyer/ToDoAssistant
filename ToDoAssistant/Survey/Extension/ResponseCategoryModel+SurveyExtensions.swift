//
//  ResponseCategoryModel+SurveyExtensions.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 5/23/21.
//  Copyright © 2021 Luke Dreyer. All rights reserved.
//

import Foundation

extension ResponseCategoryModel {
    func calculateIsSurveyRequest() -> Bool {
        guard response.count <= GlobalConstants.eighty else { return false }
        let words = response.split(separator: GlobalConstants.spaceSeparator)
        return words.contains { $0.uppercased() == "SURVEY" }
    }

    func surveyId() -> SurveyId {
        guard response.count <= GlobalConstants.eighty else { return .none }
        let words = response.split(separator: GlobalConstants.spaceSeparator)
        if (words.contains(where: { $0.uppercased() == "SURVEY" })) {
            if (words.contains(where: { $0.uppercased() == "CITIZENSHIP" })) {
                return .citizenship
            } else if (words.contains(where: { $0.uppercased() == "BOT" })) {
                return .bot
            } else if (words.contains(where: { $0.uppercased() == "GOOGLE" })) {
                return .google
            } else {
                return .none
            }
        } else {
            return .none
        }
    }
}
