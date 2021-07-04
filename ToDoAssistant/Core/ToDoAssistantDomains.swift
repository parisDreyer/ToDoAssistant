//
//  ToDoAssistantDomains.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 6/12/21.
//  Copyright © 2021 Luke Dreyer. All rights reserved.
//

import Foundation

enum ToDoAssistantDomains: String {
    case bot
    case general
    case survey
    case news
    case message
    case contacts
    case dao

    var description: String {
        self.rawValue.uppercased()
    }
}
