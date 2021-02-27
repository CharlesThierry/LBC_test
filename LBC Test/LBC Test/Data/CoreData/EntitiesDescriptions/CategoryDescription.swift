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
    init(id: Int,
         name: String)
    {
        self.id = id
        self.name = name
    }

    required init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: JSONCategory.self)
        self.id = try c.decodeIfPresent(Int.self, forKey: .id)
        self.name = try c.decodeIfPresent(String.self, forKey: .name)
    }
}
