//
//  StringProtocol+Extensions.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 9/19/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import Foundation

extension StringProtocol {
    var asciiValues: [UInt8] { compactMap(\.asciiValue) }
}
