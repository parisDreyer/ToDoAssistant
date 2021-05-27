//
//  SurveyRepository.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 5/1/21.
//  Copyright © 2021 Luke Dreyer. All rights reserved.
//

import Foundation
import ResearchKit

protocol SurveyRepositoryInput: AnyObject {
    func getSurvey()
}

protocol SurveyRepositoryOutput: AnyObject {
    func displaySurvey(_ surveyURL: String)
    func displayError(_ error: Error)
}

class SurveyRepository {
    private enum Constants {
        static let surveyURL = "https://forms.gle/ES2WQiKwPFoBZT8S9"
    }
    weak var interactor: SurveyRepositoryOutput?
}

extension SurveyRepository: SurveyRepositoryInput {
    func getSurvey() {
        interactor?.displaySurvey(Constants.surveyURL)
    }


}

