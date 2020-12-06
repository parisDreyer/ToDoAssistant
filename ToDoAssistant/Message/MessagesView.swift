//
//  MessagesView.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 9/19/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import Foundation
import SwiftUI

struct MessagesView: View {
    @State var userMessage: String = ""
    @State var messages: [Message] = []
    var state = MessageViewState()

    var body: some View {
        VStack {
            ScrollView(.vertical) {
                ScrollViewReader { scrollView in
                    LazyVStack {
                        ForEach(messages, id: \.self) { MessageView(message: $0) }
                    }.onChange(of: messages) { newValue in
                        guard !newValue.isEmpty else { return }
                        scrollView.scrollTo(newValue[newValue.endIndex - 1])
                    }
                }
            }
            .padding(10)
            HStack(alignment: .bottom) {
                TextField(">", text: $userMessage)
                    .padding(10)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: sendMessage, label: { Text("Send") })
                    .padding(10)
            }
        }
    }

    private func sendMessage() {
        guard !userMessage.isEmpty else { return }
        let message = Message(id: messages.count, sender: .user, message: userMessage)
        state.receive(message: message) { response in
            self.messages.append(response)
        }
        userMessage = ""
    }
}
