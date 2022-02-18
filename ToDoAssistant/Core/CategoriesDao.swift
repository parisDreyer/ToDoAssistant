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
    private let calculatedUniqueIdentifier = Expression<String>(Constants.calculatedUniqueIdentifier.rawValue)

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
        try createIfNotExists()
        guard let connection = connection else {
            throw GeneralError(message: Constants.couldNotAccessDBConnectionInCategoryDao.rawValue, domain: .dao, errorCode: 260)
        }
        _ = try connection.run(getTable().insert(calculatedUniqueIdentifier <- model.possibleUniqueIdentifier))
    }

    func get(identifier: String) -> Row? {
        do {
            let query = getTable().where(calculatedUniqueIdentifier == identifier)
            return try connection?.pluck(query)
        } catch {
            print("error")
            // todo error handling
        }
        return nil
    }
}
