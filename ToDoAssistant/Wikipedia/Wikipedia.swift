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
    private let question: ResponseCategoryModel


    init(_ dependencies: Dependencies?, question: ResponseCategoryModel) {
        self.dependencies = dependencies
        self.question = question
    }

    func shouldSendRequest() -> Bool {
        let isDiscussingFacts = question.previousResponseWasNegation ??
                                question.previousResponseWasAffirmation ??
                                false
        return question.response.count < Constants.upperBoundForWikiSearch &&
               isDiscussingFacts
    }

    func getData() {
        let request = WikipediaRequest(searchTerm: question.response)
        request.get(handleSuccess, handleError)
    }
}

private extension Wikipedia {
    enum Constants {
        static let upperBoundForWikiSearch = 97
        static let searchForNewInformationInterval = 3
    }

    func handleSuccess(_ pages: [WikiPage]) {
        dependencies?.success(pages)
    }

    func handleError(_ error: Error) {
        dependencies?.failure(error)
    }
}
