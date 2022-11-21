//
//  Wikipedia.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 11/14/22.
//  Copyright © 2022 Luke Dreyer. All rights reserved.
//

import Foundation

protocol WikipediaOutput: AnyObject {
    func success(_ response: [WikiPage])
}

final class Wikipedia {
    typealias Dependencies = WikipediaOutput & FailureOutput

    private weak var dependencies: Dependencies?
    private let repository: WikipediaRepositoryInput?
    private let question: ResponseCategoryModel


    init(_ dependencies: Dependencies? = nil,
         repository: WikipediaRepositoryInput? = nil,
         question: ResponseCategoryModel) {
        self.dependencies = dependencies
        self.repository = repository
        self.question = question
    }

    func shouldSendRequest() -> Bool {
        let isDiscussingFacts = question.previousResponseWasNegation == true ||
                                question.previousResponseWasAffirmation == true
        return question.response.count < Constants.upperBoundForWikiSearch &&
               isDiscussingFacts
    }

    func getData() {
        repository?.set(delegate: self)
        repository?.getData()
    }
}

// MARK: - WikipediaRepositoryOutput

extension Wikipedia: WikipediaRepositoryOutput {
    private enum Constants {
        static let upperBoundForWikiSearch = 97
        static let searchForNewInformationInterval = 3
    }

    var searchTerm: String {
        question.response
    }

    func handleSuccess(_ pages: [WikiPage]) {
        dependencies?.success(pages)
    }

    func handleError(_ error: Error) {
        dependencies?.failure(error)
    }
}
