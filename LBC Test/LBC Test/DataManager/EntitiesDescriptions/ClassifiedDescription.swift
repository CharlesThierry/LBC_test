//
//  Classified+CoreDataClass.swift
//  Test LBC
//
//  Created by Charles Thierry on 26/02/2021.
//
//

import Foundation
import CoreData

protocol ClassifiedProtocol {
    var id: Int64 { get }
    var title: String { get }
    var description: String { get }
    var price: Float { get }
    var urgent: Bool { get }
    var siret: String? { get }
    var creationDate: Date { get }
    
    var categoryID: Int { get }
    var images: [ClassifiedImagesTitle: URL] { get }
}

class ClassifiedDescription: ClassifiedProtocol {
    internal var id: Int64
    internal var title: String
    internal var description: String
    internal var price: Float
    internal var urgent: Bool
    internal var siret: String?
    internal var creationDate: Date
    internal var categoryID: Int
    internal var images: [ClassifiedImagesTitle : URL]

    init (id: Int64,
          title: String,
          desc: String,
          price: Float,
          urgent: Bool,
          siret: String?,
          creationDate: Date,
          images: [ClassifiedImagesTitle: URL],
          categoryID: Int) {
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
