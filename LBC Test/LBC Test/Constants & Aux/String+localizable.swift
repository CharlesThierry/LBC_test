//
//  String+localizable.swift
//  Test LBC
//
//  Created by Charles Thierry on 07/03/2021.
//

import Foundation

extension String {
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
