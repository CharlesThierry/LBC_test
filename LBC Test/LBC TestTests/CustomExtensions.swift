//
//  File.swift
//  Test LBC
//
//  Created by Charles Thierry on 02/03/2021.
//

@testable import Test_LBC
import XCTest

class CustomExtensionsTest: XCTestCase {
    func testNumberFNoDecimals() {
        let amount = NSNumber(floatLiteral: 125.00)
        let convertedOpt = NumberFormatter.priceFormatter.string(from: amount)
        guard let converted = convertedOpt else {
            XCTFail()
            return
        }
        XCTAssert(converted == "125 €")
    }

    func testNumberFTwoDecimals() {
        let amount = NSNumber(floatLiteral: 125.34)
        let convertedOpt = NumberFormatter.priceFormatter.string(from: amount)
        guard let converted = convertedOpt else {
            XCTFail()
            return
        }
        XCTAssert(converted == "125,34 €")
    }

    func testDateFBase() {
        let expectedString = "1970-01-01T00:00:00+0000"
        let dateOpt = DateFormatter.custom.date(from: expectedString)
        guard let date = dateOpt else {
            XCTFail()
            return
        }
        XCTAssert(date == Date(timeIntervalSince1970:0))
    }
    func testDateFRandom() {
        let expectedString = "1982-10-01T17:09:25+0000"
        var dateCompo = DateComponents()
        dateCompo.year = 1982
        dateCompo.month = 10
        dateCompo.day = 01
        dateCompo.timeZone = TimeZone(secondsFromGMT: 0)
        dateCompo.hour = 17
        dateCompo.minute = 09
        dateCompo.second = 25
        let calendar = Calendar(identifier: .gregorian)
        guard let expectedDate = calendar.date(from: dateCompo) else {
            XCTFail()
            return
        }
        let dateOpt = DateFormatter.custom.date(from: expectedString)
        guard let date = dateOpt else {
            XCTFail()
            return
        }
        XCTAssert(date == expectedDate)
    }
    
    func testDateFRelativeFar() {
        let expectedString = "01/01/1970 01:00"
        let date = Date(timeIntervalSince1970: TimeInterval())
        let string = DateFormatter.relative.string(from: date)
        XCTAssert(string == expectedString)
    }
    func testDateFRelativeClose() {
        let date = Date.init(timeIntervalSinceNow: -60*60*24)
        let string = DateFormatter.relative.string(from: date)
        XCTAssert(string.hasPrefix("hier"))
    }
}
