//
//  CategoryDescription.swift
//  Test LBC
//
//  Created by Charles Thierry on 26/02/2021.
//

import Foundation

protocol CategoryProtocol {
    var id: Int? { get }
    var name: String? { get }
}

class CategoryDescription: CategoryProtocol, Decodable {
    internal var id: Int?
    internal var name: String?

    init(category: Category) {
        id = Int(category.id)
        name = category.name
    }

    required init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: JSONCategory.self)
        id = try c.decodeIfPresent(Int.self, forKey: .id)
        name = try c.decodeIfPresent(String.self, forKey: .name)
    }
}
