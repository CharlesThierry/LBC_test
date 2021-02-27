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

class TestClassified: ClassifiedProtocol {
    var id: Int?
    var title: String?
    var description: String?
    var price: Float?
    var urgent: Bool?
    var creationDate: Date?
    var categoryID: Int?
    var siret: String?

    var images: [ClassifiedImagesTitle: URL]?

    init() {
        let tID = Int.random(in: 0 ..< 20000)
        let tTitle = "\(tID)."
        id = tID
        title = tTitle
        description = "Description \(tID)"
        price = Float.random(in: 0 ... 2000)
        urgent = Bool.random()
        siret = Bool.random() ? "" : "siret of \(tID)."
        creationDate = getRandomDate()
        images = [.small: URL(string: "https://example.com/imagesSmall-\(tID).jpg")!,
                  .thumb: URL(string: "https://example.com/imagesThumb-\(tID).jpg")!]
        categoryID = Int.random(in: 0 ..< maxCategoryID)
    }

    init(id: Int, category: Int) {
        self.id = id
        title = "Title \(id)."
        categoryID = category
        description = "Description \(id)"
        price = Float.random(in: 0 ... 2000)
        urgent = Bool.random()
        siret = Bool.random() ? "" : "siret of \(id)."
        creationDate = getRandomDate()
        images = [.small: URL(string: "https://example.com/imagesSmall-\(id).jpg")!,
                  .thumb: URL(string: "https://example.com/imagesThumb-\(id).jpg")!]
    }
}

class TestCategory: CategoryProtocol {
    var id: Int?
    var name: String?

    init(id: Int) {
        self.id = id
        name = "Category \(id)"
    }
}
