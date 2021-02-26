//
//  LBC_TestTests.swift
//  LBC TestTests
//
//  Created by Charles Thierry on 25/02/2021.
//

import XCTest
@testable import Test_LBC

class CoreDataTests: XCTestCase {

    var manager: DataManager?
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        manager = DataManager()
        manager?.purge()
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPopulateCategories() {
        let categories = (0 ..< maxCategoryID).indices.map { id in TestCategory(id: Int64(id)) }
        manager?.addCategories(categories)
        let categoryCount = manager?.count(entity: CoreDataEntityNames.Category)
        XCTAssert(categoryCount == maxCategoryID, "\(categoryCount ?? -1) != \(maxCategoryID)")
    }
    
    func testAddARandomClassified() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let categories = (0 ..< maxCategoryID).indices.map { id in TestCategory(id: Int64(id)) }
        manager?.addCategories(categories)
        manager?.addClassified(TestRandomClassified())
        let classifiedCount = manager?.count()
        XCTAssert(classifiedCount == 1, "\(classifiedCount ?? -1) != 1 classified.")
    }

    func testAddStaticClassified () {
        
    }

}
