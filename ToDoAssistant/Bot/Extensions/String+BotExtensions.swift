//
//  String+BotExtensions.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 7/5/21.
//  Copyright © 2021 Luke Dreyer. All rights reserved.
//

import Foundation

extension String {
    private enum Constants {
        static let codedKeySeperator = "C"
    }

    static func from(calculatedUniqueIdentifier: String) -> String? {
        // todo make some mapping function to get string from calculatedUniqueIdentifier
        return String.from(id: calculatedUniqueIdentifier)
    }

    func calculateUniqueIdentifier() -> String? {
        return String.uniqueId(from: self)
    }

    /**
     * Maps a string to a String of ascii values
     */
    private static func uniqueId(from phrase: String) -> String? {
        let joinedCharsASCII = phrase.asciiValues
                                     .map { "\($0)" }
                                     .joined(separator: Constants.codedKeySeperator)
        return joinedCharsASCII
    }

    /**
     * Maps a string from a String of ascii values
     */
    private static func from(id: String) -> String? {
        let encodedChars = id.components(separatedBy: Constants.codedKeySeperator)

        let decodedWords = encodedChars.map { (encodedChar: String) -> String? in
            guard let integer = Int(encodedChar) else {
                return nil
            }
            let asciiChar = UInt8(integer)
            return String(UnicodeScalar(asciiChar))
        }
        return decodedWords.compactMap { $0 }
                           .joined()
    }
}
