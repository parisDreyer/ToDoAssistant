//
//  GeneralError.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 6/12/21.
//  Copyright © 2021 Luke Dreyer. All rights reserved.
//

import Foundation

class GeneralError: NSError {
    private enum Constants {
        static let message = "message"
    }
    init(message: String, domain: ToDoAssistantDomains = ToDoAssistantDomains.general, errorCode: Int = NSFeatureUnsupportedError) {
        super.init(domain: domain.description, code: errorCode, userInfo: [Constants.message: message])
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
