//
//  SurveyRouter.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 5/1/21.
//  Copyright © 2021 Luke Dreyer. All rights reserved.
//

import Foundation
import UIKit

protocol SurveyRouterInput: AnyObject {
    func show(alert: String, title: String, style: UIAlertController.Style)
    func display(error: String)
    func open(url: URL)

}

final class SurveyRouter {
    private weak var displayManager: DisplayManagerInput?
    private var viewController: SurveyViewController?

    init(displayManager: DisplayManagerInput) {
        self.displayManager = displayManager
    }

    func present() {
        let interactor = SurveyInteractor(router: self, repository: SurveyRepository())
        let presenter = SurveyPresenter(interactor: interactor)
        interactor.presenter = presenter
        let viewController = SurveyViewController(presenter: presenter)
        presenter.view = viewController

        displayManager?.present(viewController: viewController)
        self.viewController = viewController
    }
}

// MARK: - SurveyRouterInput

extension SurveyRouter: SurveyRouterInput {
    func open(url: URL) {
        guard UIApplication.shared.canOpenURL(url) else {
            display(error: "SurveyRouter: Cannot open url \(url.absoluteString)")
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    func display(error: String) {
        displayManager?.displayError(error: error)
    }

    func show(alert: String, title: String, style: UIAlertController.Style) {
        displayManager?.displayAlert(alert: alert, title: title, style: style)
    }
}
