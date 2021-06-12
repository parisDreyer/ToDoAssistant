//
//  MessageViewPresenter.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 9/19/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import Foundation
import SwiftUI

enum Sender {
    case user, bot
}

typealias SetMessage = (Message) -> Void
typealias GetLastSentMessage = () -> Message?

protocol MessageViewPresenterInput: AnyObject {
    func receive(message: Message)
}

final class MessageViewPresenter {
    var setMessage: SetMessage?
    var getLastSentMessage: GetLastSentMessage?
    private weak var displayManager: DisplayManagerInput?
    private var sendingMessagesQueue = Queue<Message>()
    
    private lazy var interactor: BotInteractor = {
        let router = BotRouter(displayManager: displayManager)
        return .init(router: router)
    }()
    private lazy var bot: Bot = { () -> Bot in
        let bot = Bot(interactor: interactor, presenter: self)
        interactor.bot = bot
        return bot
    }()

    init(displayManager: DisplayManagerInput?) {
        self.displayManager = displayManager
    }
}

// MARK: - MessageViewPresenterInput

extension MessageViewPresenter: MessageViewPresenterInput {

    func receive(message: Message) {
        sendingMessagesQueue.enqueue(message)
        switch(message.sender) {
        case .user:
            bot.respond(message: message)
        case .bot:
            break
        }
        resolveSendingMessages()
    }

}

// MARK: - Private

private extension MessageViewPresenter {

    func resolveSendingMessages() {
        guard let setMessage = setMessage, let getLastSentMessage = getLastSentMessage else { return }

//        DispatchQueue.main.async {
            let lastSentMessage: Message? = getLastSentMessage()
            let lastSentMessageId = lastSentMessage?.id ?? -1
            var currentResolvedMessageId = lastSentMessageId + 1

            while !self.sendingMessagesQueue.isEmpty, let message = self.sendingMessagesQueue.dequeue() {
                let resolvedMessage = Message(id: currentResolvedMessageId, sender: message.sender, message: message.message)
                currentResolvedMessageId += 1
                setMessage(resolvedMessage)
            }
//        }
    }

}
