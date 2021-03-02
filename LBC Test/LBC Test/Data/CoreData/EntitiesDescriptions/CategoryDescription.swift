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
    var id: Int?
    var name: String?
    init(category: Category)
    {
        self.id = Int(category.id)
        self.name = category.title
    }

    required init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: JSONCategory.self)
        id = try c.decodeIfPresent(Int.self, forKey: .id)
        name = try c.decodeIfPresent(String.self, forKey: .name)
    }
}
