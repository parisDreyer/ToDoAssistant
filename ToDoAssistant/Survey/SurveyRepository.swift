//
//  SurveyRepository.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 5/1/21.
//  Copyright © 2021 Luke Dreyer. All rights reserved.
//

import Foundation
import ResearchKit

protocol SurveyDelegate: AnyObject {
    func getSurveyQuestions() -> [String: [String]]
}

protocol SurveyRepositoryInput: AnyObject {
    func getSurvey()
    func getSurveyQuestions()
    func getCitizenshipSurveyQuestions()
}

protocol SurveyRepositoryOutput: AnyObject {
    func displaySurvey(_ surveyURL: String)
    func displaySurvey(_ questions: SurveyQuestions)
    func displaySurvey(_ questions: CitizenshipSurvey)
    func displayError(_ error: Error)
}

class SurveyRepository {
    private enum Constants {
        static let surveyURL = "https://forms.gle/ES2WQiKwPFoBZT8S9"
        static let citizenshipSurveyJSON = "CitizenshipSurvey"
    }
    weak var interactor: SurveyRepositoryOutput?
    let delegate: SurveyDelegate
    init(delegate: SurveyDelegate) {
        self.delegate = delegate
    }
}

extension SurveyRepository: SurveyRepositoryInput {
    func getSurveyQuestions() {
        guard let interactor = interactor else { return }

        let questions = delegate.getSurveyQuestions()
        let textSurveyQuestions = questions.map { TextSurveyQuestion(question: $0.0, options: $0.1) }
        let surveyQuestions = SurveyQuestions(textSurveyQuestions: textSurveyQuestions)

        interactor.displaySurvey(surveyQuestions)
    }

    func getSurvey() {
        interactor?.displaySurvey(Constants.surveyURL)
    }

    func getCitizenshipSurveyQuestions() {
        guard let data = FileLoader.readDataFrom(fileName: Constants.citizenshipSurveyJSON) else {
            // TODO: error handling
            return
        }
        do {
            interactor?.displaySurvey(try JSONDecoder().decode(CitizenshipSurvey.self, from: data))
        } catch {
            // TODO: error handling
        }
    }

}
