/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Abstracts the BERT vocabulary setup to two tokenID methods and four constants.
*/

import Foundation

struct BERTVocabulary {
    static var unkownTokenID: Int {
        lookupDictionary["[UNK]"] ?? 100
    }
    static var paddingTokenID: Int {
        lookupDictionary["[PAD]"] ?? 0
    }
    static var separatorTokenID: Int {
        lookupDictionary["[SEP]"] ?? 102
    }
    static var classifyStartTokenID: Int {
        lookupDictionary["[CLS]"] ?? 101
    }

    /// Searches for a token ID for the given word or wordpiece string.
    ///
    /// - parameters:
    ///     - string: A word or wordpiece string.
    /// - returns: A token ID.
    static func tokenID(of string: String) -> Int {
        let token = Substring(string)
        return tokenID(of: token)
    }

    /// Searches for a token ID for the given word or wordpiece token.
    ///
    /// - parameters:
    ///     - string: A word or wordpiece token (Substring).
    /// - returns: A token ID.
    static func tokenID(of token: Substring) -> Int {
        let unkownTokenID = BERTVocabulary.unkownTokenID
        return BERTVocabulary.lookupDictionary[String(token)] ?? unkownTokenID
    }

    private init() { }
    static let lookupDictionary = loadVocabulary()

    /// Imports the model's vocabulary into a [word/wordpiece token: token ID] Dictionary.
    ///
    /// - returns: A dictionary.
    /// - Tag: LoadVocabulary
    private static func loadVocabulary() -> [String: Int] {
        let fileName = "bert-base-uncased-vocab"
        let expectedVocabularySize = 30_522

        guard let url = Bundle.main.url(forResource: fileName, withExtension: "txt") else {
            fatalError("Vocabulary file is missing")
        }

        guard var words = (try? String(contentsOf: url))?.split(separator: GlobalConstants.newLineChar).map(String.init),
              words.count == expectedVocabularySize else {
            fatalError("Vocabulary file is not the correct size.")
        }

        guard words.first == "[PAD]" && words.last == "##～" else {
            fatalError("Vocabulary file contents appear to be incorrect.")
        }

        // use set dictionary size to reduce resizing as words are added
        var vocabulary: Dictionary<String, Int> = .init(minimumCapacity: words.count)
        while words.count > 0 {
            // removeLast() has O(1) time and reduces space complexity of `words` incrementally so `vocabulary` + `words` doesn't take up too much memory
            let word = words.removeLast()
            vocabulary[word] = words.count
        }
        return vocabulary
    }
}
