//
//  ResponseCategoryModel+ContactsExtensions.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 12/6/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import Foundation

extension ResponseCategoryModel {
    func calculateIsContactsRequest() -> Bool {
        let responseStrings = response.split(separator: " ")
        guard responseStrings.count < 10 else { return false }

        var hasContacts = false
        var hasQuestion = response.hasQuestionMark
        var hasSelfReference = false
        var isAskingForContacts: Bool {
            return hasContacts && (hasQuestion || hasSelfReference)
        }

        for word in responseStrings {
            if isAskingForContacts {
                return true
            } else if word == "CONTACT" || word == "CONTACTS" {
                hasContacts = true
            } else if String(word).isSelfReferenceWord {
                hasSelfReference = true
            } else if !hasQuestion && String(word).isQuestionWord {
                hasQuestion = true
            }
        }
        return isAskingForContacts
    }
}
