//
//  MockDisplayManager.swift
//  ToDoAssistantTests
//
//  Created by Luke Dreyer on 12/28/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import UIKit
@testable import ToDoAssistant

class MockDisplayManager: DisplayManagerInput {
    var presentedViewController: UIViewController?
    func present(viewController: UIViewController) {
        presentedViewController = viewController
    }

    var displayedAlert = false
    func displayAlert(alert: String, title: String, style: UIAlertController.Style) {
        displayedAlert = true
    }

    var displayedError = false
    func displayError(error: String) {
        displayedError = true
    }
}
