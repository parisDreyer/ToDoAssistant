//
//  EvaluateResponse.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 5/27/22.
//  Copyright © 2022 Luke Dreyer. All rights reserved.
//

import Foundation

final class EvaluateResponse {
    let sentiment: Sentiment


    init(_ response: String) {
        self.sentiment = Sentiment(expression: response)
    }

    func isPositive() -> Bool? {
        guard let sentiment = sentiment.getEmotion() else {
            return nil
        }
        switch sentiment {
        case .superSad, .sad, .unhappy:
            return false
        case .OK:
            return nil
        case .happy, .awesome:
            return true
        }
    }
}
