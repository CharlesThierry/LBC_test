//
//  ClassifiedDescription.swift
//  Test LBC
//
//  Created by Charles Thierry on 28/02/2021.
//

import Foundation

class ClassifiedDescription {
    var title: String
    var description: String
    var price: Float
    var creationDate: Date
    var siret: String!
    var urgent: Bool

    var categoryName: String

    var coverPicturePath: String
    var additionalPicturesPath = [String]()

    init(entry: Entry) {
        title = entry.title!
        description = entry.longDesc!
        price = entry.price
        creationDate = entry.creationDate!
        siret = entry.siret
        urgent = entry.urgent

        categoryName = (entry.oneCategory?.title)!

        coverPicturePath = "placeholder"
    }
}
