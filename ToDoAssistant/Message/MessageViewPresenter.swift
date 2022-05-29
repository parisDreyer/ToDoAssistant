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
    typealias Dependencies = DisplayManagerDependency
                             & Bot.Dependencies
                             & BotInteractor.Dependencies
    private let dependencies: Dependencies

    var setMessage: SetMessage?
    var getLastSentMessage: GetLastSentMessage?
    private var sendingMessagesQueue = Queue<Message>()
    
    private lazy var interactor: BotInteractor = {
        let router = BotRouter(displayManager: dependencies.displayManager)
        let interactor = BotInteractor(dependencies: dependencies, router: router)
        router.interactor = interactor
        return interactor
    }()
    private lazy var bot: Bot = { () -> Bot in
        let bot = Bot(dependencies: dependencies, interactor: interactor, presenter: self)
        interactor.bot = bot
        return bot
    }()

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
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

        let lastSentMessage: Message? = getLastSentMessage()
        let lastSentMessageId = lastSentMessage?.id ?? -1
        var currentResolvedMessageId = lastSentMessageId + 1

        while !sendingMessagesQueue.isEmpty, let message = self.sendingMessagesQueue.dequeue() {
            let resolvedMessage = Message(id: currentResolvedMessageId, sender: message.sender, message: message.message)
            currentResolvedMessageId += 1
            setMessage(resolvedMessage)
        }
    }

}
