//
//  SurveyViewController.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 5/1/21.
//  Copyright © 2021 Luke Dreyer. All rights reserved.
//

import Foundation
import UIKit
import ResearchKit

protocol SurveyViewOutput: AnyObject {
    func getSurvey()
    func openSurvey(url: String)
    func showError(message: String)
}

protocol SurveyViewInput: AnyObject {
    func showSurvey(url: String)
}

final class SurveyViewController: UIViewController {
    private enum Constants {
        static let spacing: CGFloat = 8
    }
    struct ViewModel {
        let url: String?
    }
    private(set) var viewModel: ViewModel = .init(url: nil) {
        didSet {
            updateView()
        }
    }

    let presenter: SurveyViewOutput
    let button: UIButton = { () -> UIButton in
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Show Survey", for: .normal)
        return btn
    }()

    init(presenter: SurveyViewOutput) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: Bundle.main)
        commonInit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // load in dispatch queue because otherwise view loads before presenter is set
        DispatchQueue.main.async {
            self.presenter.getSurvey()
        }
    }
}

// MARK: - Private

private extension SurveyViewController {
    func commonInit() {
        setupView()
        setupConstraints()
    }

    func setupView() {
        button.addTarget(self, action: #selector(consentTapped), for: .touchUpInside)
        view.backgroundColor = .white
        view.addSubview(button)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            button.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 42),
            button.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -42),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    func updateView() {
        guard let url = viewModel.url else {
            presenter.showError(message: "Could not display survey")
            return
        }
//        presenter.openSurvey(url: url)
    }

    @objc func consentTapped(sender : AnyObject) {
        let taskViewController = ORKTaskViewController(task: ConsentTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
}

// MARK: - SurveyViewInput

extension SurveyViewController: SurveyViewInput {
    func showSurvey(url: String) {
        viewModel = .init(url: url)
    }
}

// MARK: - ORKTaskViewControllerDelegate

extension SurveyViewController : ORKTaskViewControllerDelegate {
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        // Handle results with taskViewController.result
        taskViewController.dismiss(animated: false, completion: nil)
    }

}
