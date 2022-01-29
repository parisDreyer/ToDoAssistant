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
        static let codedKeySeperator = "01010"
    }

    static func from(calculatedUniqueIdentifier: Double) -> String? {
        // todo make some mapping function to get string from calculatedUniqueIdentifier
        return String.from(id: calculatedUniqueIdentifier)
    }

    func calculateUniqueIdentifier() -> Double? {
        return String.uniqueId(from: self)
    }

    /**
     * Maps a string to a double of ascii values
     */
    private static func uniqueId(from phrase: String) -> Double? {
        let joinedCharsASCII = phrase.asciiValues
                                     .map { "\($0)" }
                                     .joined(separator: Constants.codedKeySeperator)
        return Double("0.\(joinedCharsASCII)")
    }

    /**
     * Maps a string from a double of ascii values
     */
    private static func from(id: Double) -> String? {
        guard id > 0, id < 1 else { return nil }
        let stringified = String("\(id)".dropFirst(2))
        let encodedWords = stringified.components(separatedBy: Constants.codedKeySeperator)

        let decodedWords = encodedWords.map { (encodedWord: String) -> String? in
            guard !encodedWord.isEmpty, let integer = Int(encodedWord) else {
                return nil
            }
            let asciiChar = UInt8(integer)
            return String(UnicodeScalar(asciiChar))
        }
        return decodedWords.compactMap { $0 }
                           .joined()
    }
}
