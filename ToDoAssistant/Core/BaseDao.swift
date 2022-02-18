//
//  BaseDao.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 6/27/21.
//  Copyright © 2021 Luke Dreyer. All rights reserved.
//

import Foundation
import SQLite

class BaseDao {
    private enum Constants {
        static var documentsDirectoryPath: String? {
            NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        }
        static let sqlite3FileEnding = "sqlite3"
    }
    let connection: Connection?
    private let name: String
    private var _table: Table?

    init(name: String) {
        self.name = name
        do {
            guard let path = Constants.documentsDirectoryPath else {
                throw GeneralError(message: "Could not find document directory path in BaseDao")
            }
            connection = try Connection("\(path)\(name).\(Constants.sqlite3FileEnding)")
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
