//
//  News.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 11/6/20.
//  Copyright © 2020 Luke Dreyer. All rights reserved.
//

import Foundation

struct News: Decodable {
    let articles: [Article]?
}

struct Article: Decodable {
    let source: ArticleSource?
    let author: String?
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    let content: String?
}

struct ArticleSource: Decodable {
    let id: String
    let name: String
}
