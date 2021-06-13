//
//  Message.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 11/7/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import SwiftUI

struct Message {
    let id: Int
    let sender: Sender
    let message: String

    var backgroundColor: UIColor {
        switch sender {
        case .bot:
            return .systemPink
        case .user:
            return .systemTeal
        }
    }

    var alignment: Alignment {
        switch sender {
        case .bot:
            return .leading
        case .user:
            return .trailing
        }
    }
}

// MARK: - Hashable

extension Message: Hashable {

    static func == (lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }

}
