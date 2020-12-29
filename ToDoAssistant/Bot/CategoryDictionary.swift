//
//  CategoryDictionary.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 9/19/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import Foundation

protocol Categorizable: AnyObject {
    var possibleUniqueIdentifier: Double { get }
}

final class CategoryDictionary {
    private(set) var actionsByIdentifier: [Double: [Action]] = [:]
    
    func action(category: ResponseCategory) -> Action? {
        let identifier = category.possibleUniqueIdentifier
        switch identifier {
        case StaticActionID.greet.rawValue:
            return .greet
        case StaticActionID.news.rawValue:
            return .getNews
        case StaticActionID.contacts.rawValue:
            return .getContacts
        default:
            break
        }

        guard let actions = actionsByIdentifier[identifier], !actions.isEmpty else {
            return .greet
        }

        return actions.randomElement()
    }

    func update(category: ResponseCategory) {
        let model = category.model
        let action: Action

        if category.isNewsRequest {
            action = .getNews
        } else if category.isContactsRequest {
            action = .getContacts
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
