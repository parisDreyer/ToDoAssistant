//
//  CitizenshipSurvey.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 7/3/21.
//  Copyright © 2021 Luke Dreyer. All rights reserved.
//

import Foundation

class CitizenshipSurvey: Codable {
    let questionsByCategory: [CitizenshipSurveyCategory]
}

class CitizenshipSurveyCategory: Codable {
    let title: String?
    let subtitle: String?
    let questions: [CitizenshipSurveyQuestion]
}

class CitizenshipSurveyQuestion: Codable {
    let question: String
    let answers: [String]
}
