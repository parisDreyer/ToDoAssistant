//
//  Contact.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 11/28/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import UIKit

struct Contact {
    let image: UIImage?
    let name: String?
    let phoneNumber: String?
    let emailAddress: String?

    var hasSufficientDataForDisplay: Bool {
        return !(image == nil && name == nil && phoneNumber == nil && emailAddress == nil)
    }
}
