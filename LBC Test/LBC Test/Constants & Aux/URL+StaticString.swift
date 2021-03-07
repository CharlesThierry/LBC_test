//
//  URL+StaticString.swift
//  Test LBC
//
//  Created by Charles Thierry on 07/03/2021.
//

import Foundation

extension URL {
    init?(staticString: StaticString) {
        self.init(string: "\(staticString)")
    }
}
