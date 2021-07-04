//
//  SurveyQuestions.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 5/30/21.
//  Copyright © 2021 Luke Dreyer. All rights reserved.
//

import Foundation

struct SurveyQuestions: Codable {
    let textSurveyQuestions: [TextSurveyQuestion]

    init(textSurveyQuestions: [TextSurveyQuestion]) {
        self.textSurveyQuestions = textSurveyQuestions
    }
}

struct TextSurveyQuestion: Codable {
    let question: String
    let options: [String]

    init(question: String, options: [String]) {
        self.question = question
        self.options = options
    }
}
