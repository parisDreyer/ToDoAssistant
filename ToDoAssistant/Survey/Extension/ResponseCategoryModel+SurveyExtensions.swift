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
        let words = response.split(separator: .init(" "))
        return words.contains { $0.uppercased() == "SURVEY" }
    }
}
