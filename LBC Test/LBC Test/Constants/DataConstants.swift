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

enum CoreDataClassified: String {
    case id
}

enum CoreDataImages: String {
    case title
    case url
}

enum ClassifiedImagesTitle: String {
    case small
    case thumb
}
