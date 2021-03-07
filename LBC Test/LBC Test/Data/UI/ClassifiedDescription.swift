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
    var price: String
    var creationDate: String
    var siret: String!
    var urgent: Bool

    var categoryName: String

    var coverPicturePath: String?
    var additionalPicturesPath = [String]()

    init(entry: Entry, formatter: DateFormatter, priceFormatter: NumberFormatter) {
        title = entry.title!
        description = entry.longDesc!
        price = priceFormatter.string(from: NSNumber(value: entry.price))!

        creationDate = formatter.string(from: entry.creationDate!)

        siret = entry.siret
        urgent = entry.urgent

        categoryName = (entry.oneCategory?.name)!
        let images = entry.manyImages as! Set<Image>
        let image = images.first(where: { image -> Bool in image.title == ImagesTitle.small.rawValue })
        coverPicturePath = image?.url
    }
}
