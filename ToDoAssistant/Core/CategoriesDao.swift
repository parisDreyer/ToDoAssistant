//
//  CategoryDao.swift
//  ToDoAssistant
//
//  Created by Luke Dreyer on 6/27/21.
//  Copyright © 2021 Luke Dreyer. All rights reserved.
//

import Foundation
import SQLite

final class CategoriesDao: BaseDao {

    private enum Constants: String {
        case categories
        case id
        case calculatedUniqueIdentifier
        case actionId
        case couldNotAccessDBConnectionInCategoryDao
        case insufficientDataForTableInsert
    }
    private let id = Expression<Int64>(Constants.id.rawValue)
    private let calculatedUniqueIdentifier = Expression<Double>(Constants.calculatedUniqueIdentifier.rawValue)

    init() {
        super.init(name: Constants.categories.rawValue)
    }

    func createIfNotExists() throws {
        guard let connection = connection else {
            throw GeneralError(message: Constants.couldNotAccessDBConnectionInCategoryDao.rawValue, domain: .dao, errorCode: 260)
        }

        try connection.run(getTable().create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(calculatedUniqueIdentifier, unique: true)
        })
        try connection.run(getTable().createIndex(calculatedUniqueIdentifier, unique: true, ifNotExists: true))
    }

    func insert(model: ResponseCategory) throws {
        guard let connection = connection else {
            throw GeneralError(message: Constants.couldNotAccessDBConnectionInCategoryDao.rawValue, domain: .dao, errorCode: 260)
        }
//        guard let a else {
//            throw GeneralError(message: Constants.insufficientDataForTableInsert.rawValue, domain: .dao, errorCode: 27)
//        }
        _ = try connection.run(getTable().insert(calculatedUniqueIdentifier <- model.possibleUniqueIdentifier))
    }



    /*
    let db = try Connection("path/to/db.sqlite3")

    let users = Table("users")
    let id = Expression<Int64>("id")
    let name = Expression<String?>("name")
    let email = Expression<String>("email")

    try db.run(users.create { t in
        t.column(id, primaryKey: true)
        t.column(name)
        t.column(email, unique: true)
    })
    // CREATE TABLE "users" (
    //     "id" INTEGER PRIMARY KEY NOT NULL,
    //     "name" TEXT,
    //     "email" TEXT NOT NULL UNIQUE
    // )

    let insert = users.insert(name <- "Alice", email <- "alice@mac.com")
    let rowid = try db.run(insert)
    // INSERT INTO "users" ("name", "email") VALUES ('Alice', 'alice@mac.com')

    for user in try db.prepare(users) {
        print("id: \(user[id]), name: \(user[name]), email: \(user[email])")
        // id: 1, name: Optional("Alice"), email: alice@mac.com
    }
    // SELECT * FROM "users"

    let alice = users.filter(id == rowid)

    try db.run(alice.update(email <- email.replace("mac.com", with: "me.com")))
    // UPDATE "users" SET "email" = replace("email", 'mac.com', 'me.com')
    // WHERE ("id" = 1)

    try db.run(alice.delete())
    // DELETE FROM "users" WHERE ("id" = 1)

    try db.scalar(users.count) // 0
    // SELECT count(*) FROM "users"
    SQLite.swift also works as a lightweight, Swift-friendly wrapper over the C API.

    let stmt = try db.prepare("INSERT INTO users (email) VALUES (?)")
    for email in ["betty@icloud.com", "cathy@icloud.com"] {
        try stmt.run(email)
    }

    db.totalChanges    // 3
    db.changes         // 1
    db.lastInsertRowid // 3

    for row in try db.prepare("SELECT id, email FROM users") {
        print("id: \(row[0]), email: \(row[1])")
        // id: Optional(2), email: Optional("betty@icloud.com")
        // id: Optional(3), email: Optional("cathy@icloud.com")
    }

    try db.scalar("SELECT count(*) FROM users") // 2
    */
}
