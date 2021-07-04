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
    let connection: Connection?
    private let name: String
    private var _table: Table?

    init(name: String) {
        self.name = name
        do {
            connection = try Connection("db.sqlite3")
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
