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
        let responseStrings = response.split(separator: GlobalConstants.spaceSeparator)
        guard responseStrings.count < 10 else { return false }

        var hasContacts = false
        var hasQuestion = response.hasQuestionMark
        var hasSelfReference = false
        var isAskingForContacts: Bool {
            return hasContacts && (hasQuestion || hasSelfReference)
        }

        for word in responseStrings {
            let wordString = String(word)
            if isAskingForContacts {
                return true
            } else if wordString == "CONTACT" || wordString == "CONTACTS" {
                hasContacts = true
            } else if wordString.isSelfReferenceWord {
                hasSelfReference = true
            } else if !hasQuestion && wordString.isQuestionWord {
                hasQuestion = true
            }
        }
        return isAskingForContacts
    }
}
