//
//  ResponseCategoryModel+NewsExtensions.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 12/6/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import Foundation

extension ResponseCategoryModel {
    func calculateIsNewsRequest() -> Bool {
        let responseStrings = response.split(separator: " ")
        guard responseStrings.count < 10 else { return false }

        var hasNews = false
        var hasQuestion = response.hasQuestionMark
        var hasReadCommand = false
        var hasSelfReference = false
        var isAskingForNews: Bool {
            return hasNews && (hasQuestion || (hasReadCommand && hasSelfReference))
        }

        for word in responseStrings {
            if isAskingForNews {
                return true
            } else if word == "NEWS" {
                hasNews = true
            } else if word == "TELL" || word == "READ" {
                hasReadCommand = true
            } else if String(word).isSelfReferenceWord {
                hasSelfReference = true
            } else if !hasQuestion && String(word).isQuestionWord {
                hasQuestion = true
            }
        }
        return isAskingForNews
    }
}
