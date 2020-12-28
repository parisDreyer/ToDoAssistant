//
//  Bot+NewsExtensions.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 11/6/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import Foundation

extension Bot {
    var news: String {
        return interactor.news?.articles?
                            .map { $0.asString }
                            .joined(separator: GlobalConstants.newLine) ?? ""
    }
}
