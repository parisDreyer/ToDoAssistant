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
        return response.uppercased() == "SURVEY"
    }
}
