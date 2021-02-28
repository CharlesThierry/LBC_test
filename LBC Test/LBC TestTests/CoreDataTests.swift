//
//  LBC_TestTests.swift
//  LBC TestTests
//
//  Created by Charles Thierry on 25/02/2021.
//

@testable import Test_LBC
import XCTest

class CoreDataTests: XCTestCase {
    var manager: DataManager?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        manager = DataManager()
        manager?.purge()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        manager?.purge()
    }

    func testPopulateCategories() {
        let categories = (0 ..< maxCategoryID).indices.map { id in TestCategory(id: Int(id)) }
        manager?.addCategories(categories)
        let categoryCount = manager?.count(entity: CoreDataEntityNames.Category)
        XCTAssert(categoryCount == maxCategoryID, "\(categoryCount ?? -1) != \(maxCategoryID)")
    }

    func testAddARandomClassified() throws {
        let categories = (0 ..< maxCategoryID).indices.map { id in TestCategory(id: Int(id)) }
        manager?.addCategories(categories)
        manager?.addEntries([TestEntry()])
        let entryCount = manager?.count()
        XCTAssert(entryCount == 1, "\(entryCount ?? -1) != 1 classified.")
    }

    func testAddTwice() {
        let category = TestCategory(id: 2)
        manager?.addCategories([category])
        let entry1 = TestEntry(id: 1, category: 2)
        manager?.addEntries([entry1])
        let entryCount = manager?.count()
        XCTAssert(entryCount == 1, "\(entryCount ?? -1) != 1 classified.")
        let entry2 = TestEntry(id: 1, category: 2)
        manager?.addEntries([entry2])
        XCTAssert(entryCount == 1, "\(entryCount ?? -1) != 1 classified.")
    }
}
