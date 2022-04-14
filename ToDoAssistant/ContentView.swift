//
//  ContentView.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 9/19/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import SwiftUI

struct LoadingView: View {
    @State private var circleColorChanged = false
    @State private var heartColorChanged = false
    @State private var heartSizeChanged = false

    var body: some View {

        ZStack {
            Circle()
                    .frame(width: 200, height: 200)
                    .foregroundColor(circleColorChanged ? Color(.systemGray5) : .red)

            Image(systemName: "heart.fill")
                    .foregroundColor(heartColorChanged ? .red : .white)
                    .font(.system(size: 100))
                    .scaleEffect(heartSizeChanged ? 1.0 : 0.5)
        }
        .onTapGesture {
            self.circleColorChanged.toggle()
            self.heartColorChanged.toggle()
            self.heartSizeChanged.toggle()
        }

    }
}

struct ContentView: View {
    typealias Dependencies = MessagesView.Dependencies
    var dependencies: Dependencies?

    var body: some View {
        guard let dependencies = dependencies else {
            return AnyView(LoadingView())
        }
        return AnyView(MessagesView(dependencies: dependencies))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(dependencies: nil)
    }
}
