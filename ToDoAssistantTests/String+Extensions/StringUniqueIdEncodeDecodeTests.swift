//
//  StringUniqueIdEncodeDecodeTests.swift
//  ToDoAssistantTests
//
//  Created by Luke Dreyer on 1/29/22.
//  Copyright © 2022 Luke Dreyer. All rights reserved.
//

import Foundation
@testable import ToDoAssistant
import XCTest

class StringUniqueIdEncodeDecodeTests: XCTestCase {
    private enum Constants {
        static let testUniqueId = "67C65C84"
        static let testUniqueWord = "CAT"
        static let testBiggerString = "IN VOLUPTATES CUPIDITATE CUMQUE SED CORRUPTI INCIDUNT SINT DUCIMUS. PERFERENDIS LAUDANTIUM RERUM ET VOLUPTAS REICIENDIS. NON NATUS EA AUT ET UT. ADIPISCI ILLO OMNIS DESERUNT QUIA INVENTORE. CORPORIS EST NISI FACILIS IURE DUCIMUS ANIMI QUOS NIHIL. QUOD IPSAM OFFICIIS EST LABORE OPTIO. EUM ID EUM NEQUE. DOLOREMQUE CUM PERFERENDIS MINUS NISI QUISQUAM. CORRUPTI QUAM ALIQUAM POSSIMUS OMNIS NUMQUAM EST TEMPORE. QUIA ET ASPERNATUR VERO ODIT PERFERENDIS SINT MODI. ASPERIORES A LABORIOSAM QUIS DIGNISSIMOS QUAM. EOS QUIDEM RECUSANDAE DOLOR IN IPSUM MOLESTIAE. ARCHITECTO VOLUPTATES VOLUPTATE VITAE VERITATIS. RECUSANDAE SINT CONSEQUATUR LABORUM OMNIS EVENIET ALIAS. DOLORES QUAERAT QUIA AUT DOLORE MINUS. MAGNAM EARUM PERSPICIATIS VERITATIS QUIA. ANIMI QUIA ACCUSAMUS ID. DUCIMUS EOS DOLOR OMNIS REM. VELIT PLACEAT EXCEPTURI HARUM. DOLORIBUS QUO REPREHENDERIT SUNT. NULLA IUSTO EST SINT MAIORES ACCUSAMUS CORRUPTI VOLUPTAS QUAERAT."
    }

    override func setUp() {
        super.setUp()
    }

    func testEncode() {
        let word = Constants.testUniqueWord
        let uniqueId = word.calculateUniqueIdentifier()

        XCTAssertEqual(uniqueId, Constants.testUniqueId)
    }

    func testDecode() {
        let id = Constants.testUniqueId
        let word = String.from(calculatedUniqueIdentifier: id)

        XCTAssertEqual(word, Constants.testUniqueWord)
    }

    func testEncodeBiggerString() {
        let uniqueId = Constants.testBiggerString.calculateUniqueIdentifier()
        guard let uniqueId = uniqueId else {
            XCTFail("Unique id was null")
            return
        }
        let bigString = String.from(calculatedUniqueIdentifier: uniqueId)
        XCTAssertEqual(Constants.testBiggerString, bigString)
    }
}
