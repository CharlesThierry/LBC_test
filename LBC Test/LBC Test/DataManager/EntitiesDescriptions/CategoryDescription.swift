//
//  CategoryDescription.swift
//  Test LBC
//
//  Created by Charles Thierry on 26/02/2021.
//

import Foundation

protocol CategoryProtocol {
    var id: Int64? { get }
    var name: String? { get }

}

class CategoryDescription: CategoryProtocol, Decodable {
    var id: Int64?
    var name: String?
    init(id: Int64,
        name: String) {
        self.id = id
        self.name = name
    }
    required init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: JSONCategory.self)
        self.id = try c.decodeIfPresent(Int64.self, forKey: .id)
        self.name = try c.decodeIfPresent(String.self, forKey: .name)
    }

}
