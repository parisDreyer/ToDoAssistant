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
    @ObservedObject var viewModel = MessagesViewModel()

    private(set) var presenter: MessageViewPresenter

    init(displayManager: DisplayManagerInput?) {
        presenter = MessageViewPresenter(displayManager: displayManager)
        presenter.setMessage = setMessage
        presenter.getLastSentMessage = getLastSentMessage
    }

    var body: some View {
        VStack {
            ScrollView(.vertical) {
                ScrollViewReader { scrollView in
                    ForEach(viewModel.messages, id: \.self) {
                        MessageView(message: $0)
                    }
                    .onChange(of: viewModel.messages) { newValue in
                        scrollView.scrollTo(newValue[newValue.count - 1])
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
}

//MARK: - Private

extension MessagesView {
    func sendMessage() {
        guard !userMessage.isEmpty else { return }
        let message = Message(id: viewModel.messages.count, sender: .user, message: userMessage)
        presenter.receive(message: message)
        userMessage = ""
    }

    func setMessage(_ message: Message) {
        DispatchQueue.main.async {
            viewModel.append(message: message)
        }
    }

    func getLastSentMessage() -> Message? {
        return viewModel.messages.last
    }
}
