//
//  OptionsList.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 5/29/22.
//  Copyright © 2022 Luke Dreyer. All rights reserved.
//

import Foundation

protocol Decidable {
    var list: [Option] { get }
}

struct OptionsList: Decidable {
    var list: [Option]
}
