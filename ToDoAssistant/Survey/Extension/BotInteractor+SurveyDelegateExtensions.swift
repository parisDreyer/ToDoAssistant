//
//  BotInteractor+SurveyDelegateExtensions.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 5/30/21.
//  Copyright © 2021 Luke Dreyer. All rights reserved.
//

import Foundation

// MARK: - SurveyDelegate

extension BotInteractor: SurveyDelegate {

    func getSurveyQuestions() -> [String : [String]] {
        guard let bot = bot else {
            error(error: GeneralError(message: "Bot was nil when getting survey questions", domain: .bot))
            return [:]
        }
        return bot.getQuestions()
    }

}
