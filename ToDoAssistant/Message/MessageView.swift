//
//  MessageView.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 9/19/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import Foundation
import SwiftUI

struct MessageView: View {
    let message: Message

    var body: some View {
        HStack(alignment: .bottom, spacing: 15) {
            switch message.alignment {
            case .trailing:
                Spacer()
            default:
                EmptyView()
            }
            Text(message.message)
                .padding(10)
                .foregroundColor(.black)
                .background(Color(message.backgroundColor))
                .cornerRadius(10)
        }
    }
}

// MARK: - Hashable

extension MessageView: Hashable {
    static func == (lhs: MessageView, rhs: MessageView) -> Bool {
        return lhs.message.id == rhs.message.id
    }
    
    
}
