//
//  CategoryDescription.swift
//  Test LBC
//
//  Created by Charles Thierry on 26/02/2021.
//

import Foundation

protocol CategoryProtocol {
    var id: Int64 { get }
    var name: String { get }

}

class CategoryDescription: CategoryProtocol {
    internal var id: Int64
    internal var name: String
    init(id: Int64,
         name: String) {
        self.id = id
        self.name = name
    }
}
