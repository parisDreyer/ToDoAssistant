//
//  NewsRequest.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 11/6/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import Foundation

protocol NewsRequestDelegate: AnyObject {
    func receiveNews(_ news: News)
    func handleError(error: Error)
}

/// https://newsapi.org/
final class NewsRequest {
    private enum Constants {
        static let apiKeyFileName = "NewsRequestApiKey"
        static let newsUrl = "https://newsapi.org/v2/top-headlines?sources=bbc-news&apiKey="
    }
    weak var delegate: NewsRequestDelegate?

    func getNews() {
        guard let apiKey = loadApiKey(), let requestUrl = URL(string: Constants.newsUrl + apiKey) else {
            delegate?.handleError(error: URLError(.badURL, userInfo: ["message" : "Could not perform request with url \(Constants.newsUrl)"]))
            return
        }
        var request = URLRequest(url: requestUrl)
        request.httpMethod = "GET"
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, _, error) in

            if let error = error {
                self?.delegate?.handleError(error: error)
            }

            if let data = data, let news = try? JSONDecoder().decode(News.self, from: data) {
                self?.delegate?.receiveNews(news)
            }
            
        }
        task.resume()
    }
}

private extension NewsRequest {
    func loadApiKey() -> String? {
        guard let filepath = Bundle.main.path(forResource: Constants.apiKeyFileName, ofType: GlobalConstants.txt) else {
            return nil
        }
        do {
            let contents = try String(contentsOfFile: filepath)
            return contents.trimWhiteSpaceAndNewLines()
        } catch {
            return nil
        }
    }
}
