//
//  Choice.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 5/29/22.
//  Copyright © 2022 Luke Dreyer. All rights reserved.
//

import Foundation

protocol Option {
    var confidenceScore: Double { get }
    var shouldProceed: Bool { get }
    var shouldDiscontinue: Bool { get }
    var proceedIronically: Bool { get }
    var action: String? { get }
    var suggestAlternative: String? { get }
}

struct Choice: Option {
    var confidenceScore: Double
    var shouldProceed: Bool
    var shouldDiscontinue: Bool
    var proceedIronically: Bool
    var action: String?
    var suggestAlternative: String?
}
