//
//  Classified+CoreDataClass.swift
//  Test LBC
//
//  Created by Charles Thierry on 26/02/2021.
//
//

import CoreData
import Foundation

protocol EntryProtocol {
    var id: Int? { get }
    var title: String? { get }
    var description: String? { get }
    var price: Float? { get }
    var urgent: Bool? { get }
    var siret: String? { get }
    var creationDate: Date? { get }

    var categoryID: Int? { get }
    var images: [ImageDescription]? { get }
}

class EntryDescription: EntryProtocol, Decodable {
    internal var id: Int?
    internal var title: String?
    internal var description: String?
    internal var price: Float?
    internal var urgent: Bool?
    internal var creationDate: Date?
    internal var categoryID: Int?
    internal var siret: String?

    internal var images: [ImageDescription]?

    required init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: JSONClassified.self)
        id = try c.decodeIfPresent(Int.self, forKey: .id)
        title = try c.decodeIfPresent(String.self, forKey: .title)
        description = try c.decodeIfPresent(String.self, forKey: .description)
        price = try c.decodeIfPresent(Float.self, forKey: .price)
        urgent = try c.decodeIfPresent(Bool.self, forKey: .is_urgent)
        siret = try c.decodeIfPresent(String.self, forKey: .siret)
        categoryID = try c.decodeIfPresent(Int.self, forKey: .category_id)
        creationDate = try c.decodeIfPresent(Date.self, forKey: .creation_date)

        let imagesUrl = try c.decodeIfPresent([String: String].self, forKey: .images_url)
        guard let urls = imagesUrl else { return }
        var imagesSet = [ImageDescription]()
        for (k, v) in urls {
            let imageDescription = ImageDescription(title: ImagesTitle(rawValue: k), url: v)
            imagesSet.append(imageDescription)
        }
        images = imagesSet
    }

    init(id: Int,
         title: String,
         desc: String,
         price: Float,
         urgent: Bool,
         siret: String?,
         creationDate: Date,
         images: [ImageDescription],
         categoryID: Int)
    {
        self.id = id
        self.title = title
        description = desc
        self.price = price
        self.urgent = urgent
        self.siret = siret
        self.creationDate = creationDate

        self.images = images
        self.categoryID = categoryID
    }
}
