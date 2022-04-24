//
//  SurveyTaskFactory.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 5/27/21.
//  Copyright © 2021 Luke Dreyer. All rights reserved.
//

import Foundation
import ResearchKit

extension UIColor {
    func image(_ size: CGSize = CGSize(width: 42, height: 42)) -> UIImage {
        return UIGraphicsImageRenderer(size: size).image { rendererContext in
            self.setFill()
            rendererContext.fill(CGRect(origin: .zero, size: size))
        }
    }
}

final class SurveyTaskFactory {

    public static func makeBotSurvey(surveyQuestions: SurveyQuestions) -> ORKOrderedTask {
        let steps = makeSurveySteps(surveyQuestions)
        return ORKOrderedTask(identifier: "BotSurvey", steps: steps)
    }

    public static func makeMultiPartSurvey(title: String, surveyQuestions: [SurveyQuestions]) -> ORKOrderedTask {
        let steps = surveyQuestions.reduce([ORKQuestionStep]()) { (questionSteps, nextQuestion) -> [ORKQuestionStep] in
            return questionSteps + makeSurveySteps(nextQuestion)
        }
        return ORKOrderedTask(identifier: title, steps: steps)
    }
}

// MARK: - Private

private extension SurveyTaskFactory {

    static func makeSurveySteps(_ surveyQuestions: SurveyQuestions) -> [ORKQuestionStep]  {
        return surveyQuestions.textSurveyQuestions.map {
            makeMultipleChoiceStep($0.question, questionOptions: $0.options)
        }
    }

    static func makeMultipleChoiceStep(_ question: String, questionOptions: [String]) -> ORKQuestionStep {
        let textChoices = questionOptions.enumerated().map { (index, text) -> ORKTextChoice in
            return ORKTextChoice(text: text, value: ORKFieldValue(value: index))
        }
        let answer: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
        return ORKQuestionStep(identifier: question, title: nil, question: question, answer: answer)//(identifier: question, title: question, answer: answer)
    }

}
