//
//  ResponseCategoryModel+WikipediaExtensions.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 11/14/22.
//  Copyright © 2022 Luke Dreyer. All rights reserved.
//

import Foundation

extension ResponseCategoryModel {
    func calculateIsWikiRequest() -> Bool {
        Wikipedia(question: self).shouldSendRequest()
    }
}
