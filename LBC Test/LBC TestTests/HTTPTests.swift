//
//  HTTPTests.swift
//  Test LBC
//
//  Created by Charles Thierry on 26/02/2021.
//

@testable import Test_LBC
import XCTest

class HTTPTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // Test commented since it depends on am actual network source
//    func testDownloadFile() {
//        guard let categoryURL = URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json") else {
//            XCTFail("Can't build Category URL")
//            return
//        }
//
//        let expCategory = XCTestExpectation(description: "Waiting to download the file")
//        fetchJson(url: categoryURL) { result in
//            switch result {
//            case .failure(let error):
//                XCTFail("Couldn't download the file \(error)")
//            case .success(let data):
//                XCTAssertTrue(data.count > 0, "Data dowloaded")
//            }
//            expCategory.fulfill()
//        }
//        wait(for: [expCategory], timeout: 10.0)
//    }

    func testJSONConversion() {
        let string = "[{\"id\": 1461267313,\"category_id\":4,\"title\":\"Title\",\"description\": \"Description\",\"price\":140.0,\"images_url\":{\"small\":\"https://example.com/small.jpg\",\"thumb\":\"https://example.com/small.jpg\"},\"creation_date\":\"2019-11-05T15:56:59+0000\",\"is_urgent\":true,\"siret\":\"123 123 123\"}]"
        let data = Data(string.utf8)
        // TODO: Add URL tests
        let description = generateItemsDescriptions(data: data, type: [EntryDescription].self)
        switch description {
        case let .failure(error):
            XCTFail("Couldn't convert the json data \(error)")
            return
        case let .success(description):
            XCTAssert(description[0].categoryID == 4, "Fail categoryID")
            XCTAssert(description[0].id == 1_461_267_313, "Fail id")
            XCTAssert(description[0].title == "Title", "Fail title")
            XCTAssert(description[0].description == "Description", "Fail description")
            XCTAssert(description[0].price == 140.0, "Fail price")
            XCTAssert(description[0].urgent == true, "Fail urgent")
            XCTAssert(description[0].siret == "123 123 123", "Fail siret")

            let dateStr = "2019-11-05T15:56:59+0000"
            let formatter = DateFormatter.custom
            let date = formatter.date(from: dateStr)
            XCTAssert(description[0].creationDate == date, "Fail date")

            let wrongDateStr = "2019-11-05T15:56:59+0100"
            let wrongDate = formatter.date(from: wrongDateStr)
            XCTAssert(description[0].creationDate != wrongDate, "Fail date 2")
        }
    }
}
