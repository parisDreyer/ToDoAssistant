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
    func getBotSurvey()
}

protocol SurveyViewInput: AnyObject {
    func showSurvey(url: String)
    func showBotSurvey(questions: SurveyQuestions)
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
    let consentButton      = makeButton("Show Consent Form")
    let surveyButton       = makeButton("Show Survey")
    let surveyBotButton    = makeButton("Show Bot Created Survey")
    let googleSurveyButton = makeButton("Show Google Forms Survey")

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
        consentButton.addTarget(self, action: #selector(consentTapped), for: .touchUpInside)
        surveyButton.addTarget(self, action: #selector(viewSurveyTapped), for: .touchUpInside)
        surveyBotButton.addTarget(self, action: #selector(viewBotSurveyTapped), for: .touchUpInside)
        googleSurveyButton.addTarget(self, action: #selector(viewGoogleSurveyTapped), for: .touchUpInside)
        view.backgroundColor = .white
        [consentButton, surveyButton, surveyBotButton, googleSurveyButton]
            .forEach { view.addSubview($0) }
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            consentButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 42),
            consentButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -42),
            consentButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            surveyButton.topAnchor.constraint(equalTo: consentButton.bottomAnchor, constant: 32),
            surveyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 42),
            surveyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -42),

            surveyBotButton.topAnchor.constraint(equalTo: surveyButton.bottomAnchor, constant: 32),
            surveyBotButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 42),
            surveyBotButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -42),

            googleSurveyButton.topAnchor.constraint(equalTo: surveyBotButton.bottomAnchor, constant: 32),
            googleSurveyButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 42),
            googleSurveyButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -42),
        ])
    }

    func updateView() {
    }

    class func makeButton(_ title: String) -> UIButton {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(title, for: .normal)
        return btn
    }

    @objc func consentTapped(sender : AnyObject) {
        let taskViewController = ORKTaskViewController(task: ConsentTask, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }

    @objc func viewSurveyTapped(sender : AnyObject) {
        let taskViewController = ORKTaskViewController(task: SurveyTaskFactory.makeExampleSurvey(), taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }

    @objc func viewBotSurveyTapped(sender: AnyObject) {
        presenter.getBotSurvey()
    }

    @objc func viewGoogleSurveyTapped(sender : AnyObject) {
        guard let url = viewModel.url else {
            presenter.showError(message: "Could not display google survey")
            return
        }
        presenter.openSurvey(url: url)
    }
}

// MARK: - SurveyViewInput

extension SurveyViewController: SurveyViewInput {
    func showSurvey(url: String) {
        viewModel = .init(url: url)
    }

    func showBotSurvey(questions: SurveyQuestions) {
        let task = SurveyTaskFactory.makeBotSurvey(surveyQuestions: questions)
        let taskViewController = ORKTaskViewController(task: task, taskRun: nil)
        taskViewController.delegate = self
        present(taskViewController, animated: true, completion: nil)
    }
}

// MARK: - ORKTaskViewControllerDelegate

extension SurveyViewController : ORKTaskViewControllerDelegate {
    func taskViewController(_ taskViewController: ORKTaskViewController, didFinishWith reason: ORKTaskViewControllerFinishReason, error: Error?) {
        // Handle results with taskViewController.result
        taskViewController.dismiss(animated: false, completion: nil)
    }

}
