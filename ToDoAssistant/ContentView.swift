//
//  ContentView.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 9/19/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var displayManager: DisplayManagerInput?

    var body: some View {
        MessagesView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
