//
//  MessagesViewModel.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 6/12/21.
//  Copyright © 2021 Luke Dreyer. All rights reserved.
//

import Foundation
import SwiftUI

final class MessagesViewModel: ObservableObject {
    @Published var messages: [Message] = []
    func append(message: Message) {
        messages.append(message)
    }
}
