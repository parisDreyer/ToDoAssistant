//
//  TodoAssistantDisplayManager.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 11/28/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import UIKit

protocol DisplayManagerInput: AnyObject {
    func displayAlert(alert: String, title: String, style: UIAlertController.Style)
    func displayError(error: String)
    var getContactsView: ContactsViewInput? { get }
}
/// A Class for handling basic operations that everything else uses, such as displaying errors or routing between modules
class TodoAssistantDisplayManager {
    private weak var navigationController: UINavigationController?
    /// returns true if base application settings allow for animated view transitions
    var shouldAnimateViewTransitions: Bool {
        // TODO: add accessibility feature to turn off animations for users that don't want animations
        return true
    }

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
        navigationController?.pushViewController(alert, animated: shouldAnimateViewTransitions)
    }
}

// MARK: - DisplayManagerInput

extension TodoAssistantDisplayManager: DisplayManagerInput {
    var getContactsView: ContactsViewInput? {
        return nil
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
