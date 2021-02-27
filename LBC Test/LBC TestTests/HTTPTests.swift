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

}
