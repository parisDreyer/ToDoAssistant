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
    public static func makeExampleSurvey() -> ORKOrderedTask {

        var steps = [ORKStep]()

        let instructionStep = ORKInstructionStep(identifier: "IntroStep")
        instructionStep.title = "The Questions Three"
        instructionStep.text = "Who would cross the Bridge of Death must answer me these questions three, ere the other side they see."
        steps += [instructionStep]

        let nameAnswerFormat = ORKTextAnswerFormat(maximumLength: 20)
        nameAnswerFormat.multipleLines = false
        let nameQuestionStepTitle = "What is your name?"
        let nameQuestionStep = ORKQuestionStep(identifier: "QuestionStep", title: nameQuestionStepTitle, answer: nameAnswerFormat)
        steps += [nameQuestionStep]

        let questQuestionStepTitle = "What is your quest?"
        let textChoices = [
            ORKTextChoice(text: "Create a ResearchKit App", value: ORKFieldValue(value: 0)),
            ORKTextChoice(text: "Seek the Holy Grail", value: ORKFieldValue(value: 1)),
            ORKTextChoice(text: "Find a shrubbery", value: ORKFieldValue(value: 2))
        ]
        let questAnswerFormat: ORKTextChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: .singleChoice, textChoices: textChoices)
        let questQuestionStep = ORKQuestionStep(identifier: "TextChoiceQuestionStep", title: questQuestionStepTitle, answer: questAnswerFormat)
        steps += [questQuestionStep]

        let colorQuestionStepTitle = "What is your favorite color?"
        let imageChoices : [ORKImageChoice] = [
            (UIColor.red.image(), UIColor.red),
            (UIColor.magenta.image(), UIColor.magenta),
            (UIColor.yellow.image(), UIColor.yellow),
            (UIColor.green.image(), UIColor.green),
            (UIColor.blue.image(), UIColor.blue)
        ].map { (image, color) -> ORKImageChoice in
            return ORKImageChoice(normalImage: image, selectedImage: nil, text: String(describing: color), value: color)
        }
        let colorAnswerFormat: ORKImageChoiceAnswerFormat = ORKAnswerFormat.choiceAnswerFormat(with: imageChoices)
        let colorQuestionStep = ORKQuestionStep(identifier: "ImageChoiceQuestionStep", title: colorQuestionStepTitle, answer: colorAnswerFormat)
        steps += [colorQuestionStep]

        let summaryStep = ORKCompletionStep(identifier: "SummaryStep")
        summaryStep.title = "Right. Off you go!"
        summaryStep.text = "That was easy!"
        steps += [summaryStep]

        return ORKOrderedTask(identifier: "SurveyTask", steps: steps)
    }

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
        return ORKQuestionStep(identifier: question, title: question, answer: answer)
    }

}
