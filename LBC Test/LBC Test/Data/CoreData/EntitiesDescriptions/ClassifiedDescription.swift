//
//  Classified+CoreDataClass.swift
//  Test LBC
//
//  Created by Charles Thierry on 26/02/2021.
//
//

import CoreData
import Foundation

// FIXME: The protocols used to define the Descriptions are only used for testing. Should prob fix that
protocol ClassifiedProtocol {
    var id: Int? { get }
    var title: String? { get }
    var description: String? { get }
    var price: Float? { get }
    var urgent: Bool? { get }
    var siret: String? { get }
    var creationDate: Date? { get }

    var categoryID: Int? { get }
    var images: [ClassifiedImagesTitle: URL]? { get }
}

class ClassifiedDescription: ClassifiedProtocol, Decodable {
    var id: Int?
    var title: String?
    var description: String?
    var price: Float?
    var urgent: Bool?
    var creationDate: Date?
    var categoryID: Int?
    var siret: String?

    internal var images: [ClassifiedImagesTitle: URL]?

    required init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: JSONClassified.self)
        self.id = try c.decodeIfPresent(Int.self, forKey: .id)
        self.title = try c.decodeIfPresent(String.self, forKey: .title)
        self.description = try c.decodeIfPresent(String.self, forKey: .description)
        self.price = try c.decodeIfPresent(Float.self, forKey: .price)
        self.urgent = try c.decodeIfPresent(Bool.self, forKey: .is_urgent)
        self.siret = try c.decodeIfPresent(String.self, forKey: .siret)
        self.categoryID = try c.decodeIfPresent(Int.self, forKey: .category_id)
        // TODO: Date stays at nil, check why the JSONDecoder fails
        self.creationDate = try c.decodeIfPresent(Date.self, forKey: .creation_date)

        let imagesUrl = try c.decodeIfPresent([String: String].self, forKey: .images_url)
        guard let urls = imagesUrl else { return }
        var imagesSet = [ImagesDescription]()
        for (k, v) in urls {
            let imageDescription = ImagesDescription(title: ClassifiedImagesTitle(rawValue: k), url: URL(string: v))
            imagesSet.append(imageDescription)
        }
    }

    init(id: Int,
         title: String,
         desc: String,
         price: Float,
         urgent: Bool,
         siret: String?,
         creationDate: Date,
         images: [ClassifiedImagesTitle: URL],
         categoryID: Int)
    {
        self.id = id
        self.title = title
        self.description = desc
        self.price = price
        self.urgent = urgent
        self.siret = siret
        self.creationDate = creationDate

        self.images = images
        self.categoryID = categoryID
    }
}
