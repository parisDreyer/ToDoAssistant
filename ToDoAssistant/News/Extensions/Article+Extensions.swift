//
//  Article+Extensions.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 11/6/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import Foundation

extension Article {
    var asString: String {
        let n = GlobalConstants.newLine
        return properNouns +
               unwrap(title, "title: ", n) +
               unwrap(author, "by: ", n) +
               unwrap(description, "description: ", n) +
               unwrap(content, "content: ", n) +
               "\(n)===================\(n)"
    }

    /// Returns a string listing Proper Pronouns of more than one Character in Length and excluding the pronoun "I"
    ///     NOTE: This function is very rough though should catch majority of cases so is good enough for now
    ///     Asssumes text is not all upcased or downcased
    var properNouns: String {
        let text = unwrap(title) + unwrap(description) + unwrap(content)
        var properNouns = GlobalConstants.emptyString
        // check each word in text splitting on space and punctuation
        text.enumerateSubstrings(in: text.startIndex..<text.endIndex, options: .byWords, { (subString, _, _, _) -> Void in
            guard let word = subString,
                  word.count > 1, // "I" is not a relevant pronoun, all other pronouns have more than one char
                  !String.stopWords[word.lowercased(), default: false]
            else { return }
            let upperCaseWord = word.uppercased()
            guard word[0] == upperCaseWord[0],
                // second char is a not a letter (e.g. ', :, `) or second char is not capitalized
                (!String.containsOnlyLetters(input: word[1]) || word[1] != upperCaseWord[1])
            else { return }
            properNouns += "Key: \(word)\(GlobalConstants.newLine)"
        })
        guard !properNouns.isEmpty else {
            return GlobalConstants.emptyString
        }
        return "===================\(GlobalConstants.newLine)Proper Nouns In Body\(GlobalConstants.newLine)-------------------\(GlobalConstants.newLine)" + properNouns + "\(GlobalConstants.newLine)-------------------\(GlobalConstants.newLine)"
    }
}

// MARK: - Private

private extension Article {
    func unwrap(_ value: String?, _ prefix: String = GlobalConstants.emptyString, _ suffix: String = GlobalConstants.spaceSeparatorString) -> String {
        return value.map { "\(prefix)\($0)\(suffix)" } ?? GlobalConstants.emptyString
    }
}
