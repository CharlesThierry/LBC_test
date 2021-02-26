//
//  TestClassified.swift
//  Test LBC
//
//  Created by Charles Thierry on 26/02/2021.
//

import Foundation
let maxCategoryID = 20

func getRandomDate() -> Date {
    let day = -Int.random(in: 0 ... 30) - 1
    let hour = arc4random_uniform(23)
    let minute = arc4random_uniform(59)
    
    let today = Date(timeIntervalSinceNow: 0)
    
    let gregorian = Calendar(identifier: .gregorian)
    var offsetComponents = DateComponents()
    offsetComponents.day = -1 * Int(day - 1)
    offsetComponents.hour = -1 * Int(hour)
    offsetComponents.minute = -1 * Int(minute)
    let randomDate = gregorian.date(byAdding: offsetComponents, to: today) ?? today
    return randomDate
}

class TestRandomClassified: ClassifiedProtocol {
    var id: Int64
    
    var title: String
    
    var description: String
    
    var price: Float
    
    var urgent: Bool
    
    var siret: String?
    
    var creationDate: Date
    
    var categoryID: Int
    
    var images: [ClassifiedImagesTitle : URL]
    
    init () {
        self.id = Int64.random(in: 0 ..< INT64_MAX)
        title = "\(id)."
        description = "\(title) ## \(title)"
        price = Float.random(in: 0 ... 2000)
        urgent = Bool.random()
        siret = Bool.random() ? "" : "siret of \(id)."
        creationDate = getRandomDate()
        images = [ClassifiedImagesTitle: URL]()
        categoryID = Int.random(in: 0 ..< maxCategoryID)
    }
    
    init (_ id: Int64)  {
        self.id = id
        title = "\(id)."
        description = "\(title) ## \(title)"
        price = Float.random(in: 0 ... 2000)
        urgent = Bool.random()
        siret = Bool.random() ? "" : "siret of \(id)."
        creationDate = getRandomDate()
        images = [ClassifiedImagesTitle: URL]()
        categoryID = Int.random(in: 0 ..< maxCategoryID)
    }
}

class TestCategory: CategoryProtocol {
    var id: Int64
    
    var name: String
    
    init(id: Int64) {
        self.id = id
        name = "Category \(id)"
    }
}
