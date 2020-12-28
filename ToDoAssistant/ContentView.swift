//
//  ContentView.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 9/19/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    weak var displayManager: DisplayManagerInput?

    var body: some View {
        MessagesView(displayManager: displayManager)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
