//
//  ORKFieldValue.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 5/30/21.
//  Copyright © 2021 Luke Dreyer. All rights reserved.
//

import Foundation

class ORKFieldValue: NSObject, NSCoding, NSCopying {
    let value: Any

    func encode(with coder: NSCoder) {
        return coder.encode(value)
    }

    init(value: Any) {
        self.value = value
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    func copy(with zone: NSZone? = nil) -> Any {
        return ORKFieldValue(value: value)
    }


}
