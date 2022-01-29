//
//  TodoAssistantDisplayManager.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 11/28/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import UIKit

protocol DisplayManagerDelegate: AnyObject {
    func save()
}

protocol DisplayManagerInput: AnyObject {
    func present(viewController: UIViewController)
    func displayAlert(alert: String, title: String, style: UIAlertController.Style)
    func displayError(error: String)
    func cleanupAndExit()
    func setDelegate(_ delegate: DisplayManagerDelegate)
}
/// A Class for handling basic operations that everything else uses, such as displaying errors or routing between modules
class TodoAssistantDisplayManager {
    private weak var navigationController: UINavigationController?
    /// returns true if base application settings allow for animated view transitions
    var shouldAnimateViewTransitions: Bool {
        // TODO: add accessibility feature to turn off animations for users that don't want animations
        return true
    }

    private weak var delegate: DisplayManagerDelegate?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

// MARK: - Private

private extension TodoAssistantDisplayManager {
    /// display error function for internal class use
    /// see `func displayError(error:)` for external class use accessed through `DisplayManagerInput`
    func displayError(_ message: String = "Oops something went wrong") {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(
            title: NSLocalizedString("OK", comment: "Default action"),
            style: .default,
            handler: { [weak self] _ in
                guard self?.navigationController?.presentedViewController == alert else { return }
                self?.navigationController?.popViewController(animated: false)
            }
        )
        alert.addAction(action)
        alert.modalPresentationStyle = .overFullScreen
        navigationController?.present(alert, animated: shouldAnimateViewTransitions)
    }
}

// MARK: - DisplayManagerInput

extension TodoAssistantDisplayManager: DisplayManagerInput {
    func setDelegate(_ delegate: DisplayManagerDelegate) {
        self.delegate = delegate
    }

    func cleanupAndExit() {
        delegate?.save()
    }

    func present(viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: false)
    }
    
    func displayAlert(alert: String, title: String, style: UIAlertController.Style) {
        let alert = UIAlertController(title: title, message: alert, preferredStyle: style)
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default) { [weak self] _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else {
                self?.displayError("Could not open URL")
                return
            }
            UIApplication.shared.open(url)
        })
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        navigationController?.pushViewController(alert, animated: shouldAnimateViewTransitions)
    }

    func displayError(error: String) {
        displayError(error)
    }

}
