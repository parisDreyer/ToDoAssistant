//
//  WikiSearch.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 11/14/22.
//  Copyright © 2022 Luke Dreyer. All rights reserved.
//

import Foundation

final class WikipediaRequest {
    private enum Constants {
        static let baseUrl = "https://en.wikipedia.org/w/api.php?action=query&origin=*&format=json&prop=extracts&generator=search&gsrnamespace=0&gsrlimit=5&gsrsearch="
        static let httpMethod = "GET"
        static let errorMessageKey = "message"

        // response keys
        static let queryKey = "query"
        static let pagesKey = "pages"
    }
    private let searchTerm: String

    init(searchTerm: String) {
        self.searchTerm = searchTerm
    }

    func get(_ handleSuccess: @escaping ([WikiPage]) -> Void, _ handleError: @escaping (Error) -> Void) {
        let urlString = Constants.baseUrl + "'\(searchTerm)'"
        guard let requestUrl = URL(string: urlString) else {
            let error = URLError(.badURL, userInfo: [Constants.errorMessageKey : "Could not perform request with url \(urlString)"])
            handleError(error)
            return
        }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = Constants.httpMethod
        let task = URLSession.shared.dataTask(with: request) { (data, _, error) in

            if let error = error {
                handleError(error)
            }

            if let data = data {
                do {
                    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? Dictionary<String, Any>,
                          let query = dictionary[Constants.queryKey] as? [String: Any],
                          let pages = query[Constants.pagesKey] else {
                        return
                    }
                    let queryData = try JSONSerialization.data(withJSONObject: pages)
                    let pagesDictionary = try JSONDecoder().decode([String: WikiPage].self, from: queryData)
                    handleSuccess(pagesDictionary.values.compactMap { $0 })
                } catch {
                    handleError(error)
                }
            }
        }
        task.resume()
    }
}

struct WikiPage: Decodable {
    let title: String?
    let extract: String?
}
