//
//  MessageViewState.swift
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
final class MessageViewState {
    
    private lazy var interactor: BotInteractor = {
        let router = BotRouter()
        let interactor = BotInteractor()
        interactor.router = router
        return interactor
    }()
    private lazy var bot: Bot = { () -> Bot in
        let bot = Bot(interactor: interactor)
        interactor.bot = bot
        return bot
    }()

    

    func receive(message: Message, _ callback: SetMessage?) {
        callback?(message)
        switch(message.sender) {
        case .user:
            bot.respond(message: message, callback)
        case .bot:
            break
        }
    }

}
