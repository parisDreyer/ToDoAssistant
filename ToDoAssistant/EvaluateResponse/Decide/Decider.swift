//
//  Decider.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 5/29/22.
//  Copyright © 2022 Luke Dreyer. All rights reserved.
//

import Foundation

protocol DecisionDependency {
    var decider: Decision { get }
}

protocol Decision {
    func make(from choices: Decidable) -> Bool
    func getChoices(from evaluation: EvaluateResponse) -> Decidable
}

final class Decider: Decision {
    func make(from choices: Decidable) -> Bool {
        var greatestConfidenceChoice: Option?
        var bestIronicChoice: Option?
        choices.list.forEach {
            if  !$0.shouldDiscontinue
                && $0.confidenceScore > (greatestConfidenceChoice?.confidenceScore ?? 0) {
                greatestConfidenceChoice = $0
            }
            if $0.proceedIronically
               && $0.shouldProceed
               && $0.confidenceScore > (bestIronicChoice?.confidenceScore ?? 0) {
                bestIronicChoice = $0
            }
        }
        return greatestConfidenceChoice?.shouldProceed == true
               || bestIronicChoice?.shouldProceed == true
    }

    func getChoices(from evaluation: EvaluateResponse) -> Decidable {
        let isPositive = evaluation.isPositive()
        let confidenceOfSentimentScore = evaluation.sentiment
                                                   .calculateConfidenceInSentimentScore()
        let isIronic = calculateIfIsIronic(isPositive: isPositive,
                                           confidence: confidenceOfSentimentScore)
        let unwrappedIsPositive = isPositive == true
        let isTruePositive = unwrappedIsPositive && !isIronic
        let isFalsePositive = unwrappedIsPositive && isIronic
        let isTrueNegative = !unwrappedIsPositive && !isIronic
        let isHighConfidence = confidenceOfSentimentScore > Constants.highConfidenceThreshold

        return OptionsList(list: [
            Choice(confidenceScore: confidenceOfSentimentScore,
                   shouldProceed: isTruePositive && isHighConfidence,
                   shouldDiscontinue: isFalsePositive || isTrueNegative,
                   proceedIronically: isIronic,
                   action: evaluation.sentiment.expression,
                   suggestAlternative: nil)
        ])
    }
}

// MARK: - Private

private extension Decider {
    enum Constants {
        // TODO: - Calculate these dynamically so they can learn/adjust with time
        static let lowConfidenceThresholdForPositiveSentiment = 0.2
        static let lowConfidenceThresholdForNegativeSentiment = 0.5
        static let highConfidenceThreshold = 0.75
    }

    func calculateIfIsIronic(isPositive: Bool?, confidence: Double) -> Bool {
        guard let isPositive = isPositive else {
            // For now default to false, we can re-evaluate irony in neutral cases later
            return false
        }

        let isIronicPositive = isPositive
                               && confidence < Constants.lowConfidenceThresholdForPositiveSentiment
        let isIronicNegative = !isPositive
                               && confidence < Constants.lowConfidenceThresholdForNegativeSentiment
        return isIronicPositive || isIronicNegative
    }
}
