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

    func testDownloadFile() {
        guard let categoryURL = URL(string: "https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json") else {
            XCTFail("Can't build Category URL")
            return
        }

        let expCategory = XCTestExpectation(description: "Waiting to download the file")
        fetchJson(url: categoryURL) { result in
            switch result {
            case .failure(let error):
                XCTFail("Couldn't download the file \(error)")
            case .success(let data):
                XCTAssertTrue(data.count > 0, "Data dowloaded")
            }
            expCategory.fulfill()
        }
        wait(for: [expCategory], timeout: 10.0)
    }

    func testJSONConversion() {
        let string = "[{\"id\": 1461267313,\"category_id\":4,\"title\":\"Title\",\"description\": \"Description\",\"price\":140.0,\"images_url\":{\"small\":\"https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-small/2c9563bbe85f12a5dcaeb2c40989182463270404.jpg\",\"thumb\":\"https://raw.githubusercontent.com/leboncoin/paperclip/master/ad-thumb/2c9563bbe85f12a5dcaeb2c40989182463270404.jpg\"},\"creation_date\":\"2019-11-05T15:56:59+0000\",\"is_urgent\":false,\"siret\":\"123 123 123\"}]"
        let data = Data(string.utf8)

        let description = generateItemsDescriptions(data: data, type: [ClassifiedDescription].self)
        switch description {
        case .failure(let error):
            XCTFail("Couldn't convert the json data \(error)")
            return
        case .success(let description):
            XCTAssert(description[0].categoryID == 4, "Fail categoryID")
            XCTAssert(description[0].id == 1461267313, "Fail id")
            XCTAssert(description[0].title == "Title", "Fail title")
            XCTAssert(description[0].description == "Description", "Fail description")
            XCTAssert(description[0].price == 140.0, "Fail price")
            XCTAssert(description[0].urgent == false, "Fail urgent")
            XCTAssert(description[0].siret == "123 123 123", "Fail siret")
        }
    }
}
