//
//  ReflectOnResponse.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 5/27/22.
//  Copyright © 2022 Luke Dreyer. All rights reserved.
//

import Foundation

final class ReflectOnResponse {
    typealias Dependencies = DecisionDependency
    private let dependencies: Dependencies
    let response: String

    init(dependencies: Dependencies, response: String) {
        self.dependencies = dependencies
        self.response = response
    }

    func shouldDoAgain() -> Bool {
        let evaluation = EvaluateResponse(response)
        let choices = dependencies.decider
                                  .getChoices(from: evaluation)
        return dependencies.decider.make(from: choices)
    }
}
