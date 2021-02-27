//
//  Constants.swift
//  LBC Test
//
//  Created by Charles Thierry on 25/02/2021.
//

import Foundation

class CoreDataConstant {
    static let dbName = "LBC"
    static let modelName = "LBC"
    static let cacheName = "fetchedCache"
}

enum JSONCategory: String, CodingKey {
    case id
    case name
}

enum JSONClassified: String, CodingKey {
    case id
    case category_id
    case title
    case description
    case price
    case images_url
    case creation_date
    case is_urgent
    case siret
}

enum CoreDataEntityNames: String {
    case Category
    case Classified
    case Images
}

enum CoreDataCategory: String {
    case id
    case title
}

enum ClassifiedImagesTitle: String, Codable {
    case small
    case thumb
}

enum CoreDataClassified: String {
    case creationDate
    case urgent
}
