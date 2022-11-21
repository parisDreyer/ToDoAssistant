//
//  WikipediaRepository.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 11/20/22.
//  Copyright © 2022 Luke Dreyer. All rights reserved.
//

import Foundation

protocol WikipediaRepositoryDependency {
    var wikipediaRepository: WikipediaRepositoryInput { get }
}

protocol WikipediaRepositoryInput {
    func getData()
    func set(delegate: WikipediaRepositoryOutput)
}

protocol WikipediaRepositoryOutput: AnyObject {
    func handleSuccess(_ pages: [WikiPage])
    func handleError(_ error: Error)
    var searchTerm: String { get }
}

/// Wrapper for Wikipedia request so that we can test
final class WikipediaRepository: WikipediaRepositoryInput {
    private weak var output: WikipediaRepositoryOutput?

    func getData() {
        guard let output = output else {
            return
        }
        let request = WikipediaRequest(searchTerm: output.searchTerm)
        request.get(output.handleSuccess, output.handleError)
    }

    func set(delegate: WikipediaRepositoryOutput) {
        self.output = delegate
    }
}
