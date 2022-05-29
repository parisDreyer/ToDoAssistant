//
//  Sentiment.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 5/27/22.
//  Copyright © 2022 Luke Dreyer. All rights reserved.
//

import Foundation
import NaturalLanguage

final class Sentiment {
    enum Emotion {
        case superSad,
             sad,
             unhappy,
             OK,
             happy,
             awesome

        init?(score: Double) {
            if score < -0.8 {
                self = .superSad
            } else if score < -0.4 {
                self = .sad
            } else if score < 0 {
                self = .unhappy
            } else if score < 0.4 {
                self = .OK
            } else if score < 0.8 {
                self = .happy
            } else if score <= 1 {
                self = .awesome
            } else {
                return nil
            }
        }
    }

    let expression: String
    private(set) var score: Double?
    private let tagger = NLTagger(tagSchemes: [.sentimentScore])

    init(expression: String) {
        self.expression = expression
    }

    func calculateConfidenceInSentimentScore() -> Double {
        let averageSentiment = averageSentimentOfWordsIn(string: expression)
        let unwrappedScore = score ?? 0
        let delta = abs(unwrappedScore - averageSentiment)
        return 1 - max(delta, 0)
    }

    func getEmotion() -> Emotion? {
        score = calculateSentiment(expression)
        guard let score = score else { return nil }
        return Emotion(score: score)
    }
}

// MARK: - Private

private extension Sentiment {
    func averageSentimentOfWordsIn(string: String) -> Double {
        let words = expression.split(separator: GlobalConstants.spaceSeparator)
        let wordSentimentScores = words.compactMap { calculateSentiment(String($0)) }
        let sumOfScores = wordSentimentScores.reduce(0) { $0 + $1 }
        return sumOfScores / Double(words.count)
    }

    func calculateSentiment(_ string: String) -> Double? {
        tagger.string = string
        guard let sentiment = tagger.tag(at: expression.startIndex, unit: .paragraph, scheme: .sentimentScore).0 else {
            return nil
        }
        return Double(sentiment.rawValue)
    }
}
