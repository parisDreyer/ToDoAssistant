//
//  SurveyInteractor.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 5/1/21.
//  Copyright © 2021 Luke Dreyer. All rights reserved.
//

import Foundation
import UIKit
import ResearchKit

protocol SurveyInteractorInput: AnyObject {
    func getData()
    func openURL(urlString: String)
    func displayError(_ error: Error)
}

final class SurveyInteractor {
    struct Entity {
        let surveyURL: String
    }

    private(set) var entity = Entity(surveyURL: "")
    let repository: SurveyRepositoryInput
    let router: SurveyRouterInput
    var presenter: SurveyPresenterInput?

    init(router: SurveyRouterInput, repository: SurveyRepository) {
        self.router = router
        self.repository = repository
        repository.interactor = self
    }

}

// MARK: - Private

extension SurveyInteractor: SurveyInteractorInput {
    func openURL(urlString: String) {
        guard  let url = URL(string: urlString) else {
            displayError(URLError(.badURL, userInfo: ["message": "SurveyInteractor: Could not build url with string: \(urlString)"]))
            return
        }
        router.open(url: url)
    }

    func getData() {
        repository.getSurvey()
    }
}

// MARK: - SurveyRepositoryOutput

extension SurveyInteractor: SurveyRepositoryOutput {

    func displaySurvey(_ surveyURL: String) {
        entity = Entity(surveyURL: surveyURL)
        presenter?.present(entity: entity)
    }

    func displayError(_ error: Error) {
        router.display(error: error.localizedDescription)
    }

}

