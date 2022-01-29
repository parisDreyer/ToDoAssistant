//
//  CategoryDictionary.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 9/19/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import Foundation

final class CategoryDictionary {
    private(set) var actionsByIdentifier: [Double: [Action]] = [:]

    /// This function is the sole place to return an action that the bot will say or do
    func action(category: ResponseCategory) -> Action? {
        let identifier = category.possibleUniqueIdentifier
        switch identifier {
        case StaticActionID.greet.rawValue:
            return .greet
        case StaticActionID.news.rawValue:
            return .getNews
        case StaticActionID.contacts.rawValue:
            return .getContacts
        case StaticActionID.survey.rawValue:
            return .getSurvey(surveyId: category.getSurveyId())
        default:
            break
        }

        guard let actions = actionsByIdentifier[identifier], !actions.isEmpty else {
            // load deeper saved memory associated with the category's response model
            category.loadBy(id: identifier)
            return .rememberedResponse(response: category.model)
        }

        // if no other options present themselves and we have actions in memory, choose something random for the bot to say or do
        return actions.randomElement()
    }

    // Categorizes Response Actions
    //
    // This function is the sole place to set a category for an action
    func update(category: ResponseCategory) {
        let model = category.model
        let action: Action

        // in future find way to prefilter string to more effeciently rule out some of these options rather than checking them each time
        if category.isNewsRequest {
            action = .getNews
        } else if category.isContactsRequest {
            action = .getContacts
        } else if category.isSurveyRequest {
            action = .getSurvey(surveyId: category.getSurveyId())
        } else if category.isUncategorized {
            action = .getMoreInfo(about: model)
        } else if model.isNegation {
            action = model.previousResponseWasNegation == true ?
                .deny(userResponse: model) :
                .tellFact(about: model)
        } else if model.isAffirmation {
            action = model.previousResponseWasAffirmation == true ?
                .confirm(userResponse: model) :
                .askQuestion(about: model)
        } else if model.userRepeatedThemself {
            action = .askQuestion(about: model)
        } else {
            action = .tellFact(about: model)
        }
        
        actionsByIdentifier[category.possibleUniqueIdentifier, default: []].append(action)
    }
}
