//
//  BaseDao.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 6/27/21.
//  Copyright © 2021 Luke Dreyer. All rights reserved.
//

import Foundation
import SQLite

extension URL {
    static var documentsURL: URL? {
        return try? FileManager
            .default
            .url(for: .documentDirectory,
                 in: .userDomainMask,
                 appropriateFor: nil,
                 create: true)
    }
}

class BaseDao {
    private enum Constants {
        static let sqlite3FileEnding = "sqlite3"
    }
    let connection: Connection?
    private let name: String
    private var _table: Table?

    init(name: String) {
        self.name = name
        do {
            let dbPathName = "\(name).\(Constants.sqlite3FileEnding)"
            guard let path = URL.documentsURL?.appendingPathComponent(dbPathName) else {
                throw GeneralError(message: "Could not find document directory path in BaseDao")
            }
            connection = try Connection(path.relativePath)
        } catch {
            connection = nil
        }
    }

    func getTable() -> Table {
        if let table = _table {
            return table
        } else {
            let table = Table(name)
            _table = table
            return table
        }
    }
}
