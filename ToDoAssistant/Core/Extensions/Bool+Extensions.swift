//
//  Bool+Extensions.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 5/30/21.
//  Copyright © 2021 Luke Dreyer. All rights reserved.
//

import Foundation

extension Bool {
    var yesOrNo: String {
        self ? "yes" : "no"
    }
}
