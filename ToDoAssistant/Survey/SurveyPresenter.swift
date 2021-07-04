//
//  SurveyPresenter.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 5/1/21.
//  Copyright © 2021 Luke Dreyer. All rights reserved.
//

import UIKit

protocol SurveyPresenterInput: AnyObject {
    func present(entity: SurveyInteractor.Entity)
    func presentBotSurvey(entity: SurveyInteractor.Entity)
    func presentCitizenshipSurvey(entity: SurveyInteractor.Entity)
}

final class SurveyPresenter {
    let interactor: SurveyInteractorInput
    var view: SurveyViewInput?

    init(interactor: SurveyInteractorInput) {
        self.interactor = interactor
    }
}

// MARK: - SurveyPresenterInput

extension SurveyPresenter: SurveyPresenterInput {
    func presentCitizenshipSurvey(entity: SurveyInteractor.Entity) {
        guard let survey = entity.citizenshipSurvey else {
            showError(message: "Citizenship Survey empty")
            return
        }
        let randomizedCategoryOrder = survey.questionsByCategory.shuffled()
        let questions: [SurveyQuestions] = randomizedCategoryOrder.map {
            let randomizedQuestionOrder = $0.questions.shuffled()
            let textSurveyQuestions = randomizedQuestionOrder.map {
                TextSurveyQuestion(question: $0.question, options: $0.answers)
            }
            return SurveyQuestions(textSurveyQuestions: textSurveyQuestions)
        }
        view?.showMultiPartSurvey(title: "Citizenship Survey", questions: questions)
    }


    func present(entity: SurveyInteractor.Entity) {
        guard !entity.surveyURL.isEmpty else {
            showError(message: "Survey URL was empty")
            return
        }
        view?.showSurvey(url: entity.surveyURL)
    }

    func presentBotSurvey(entity: SurveyInteractor.Entity) {
        guard let surveyQuestions = entity.surveyQuestions else {
            showError(message: "Survey Questions were empty")
            return
        }
        view?.showBotSurvey(questions: surveyQuestions)    }
}

// MARK: - SurveyViewOutput

extension SurveyPresenter: SurveyViewOutput {
    func viewLoaded() {
        getSurvey()
    }

    func getCitizenshipSurvey() {
        interactor.getCitizenshipSurvey()
    }

    func showError(message: String) {
        interactor.displayError(URLError(.badURL, userInfo: ["message": message]))
    }

    func openSurvey(url: String) {
        interactor.openURL(urlString: url)
    }

    func getSurvey() {
        interactor.getData()
    }

    func getBotSurvey() {
        interactor.getBotSurvey()
    }
}

