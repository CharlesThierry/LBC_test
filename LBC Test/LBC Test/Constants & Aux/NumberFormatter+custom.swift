//
//  NumberFormatter+custom.swift
//  Test LBC
//
//  Created by Charles Thierry on 01/03/2021.
//

import Foundation
extension NumberFormatter {
    static let priceFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "fr_FR")
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        formatter.alwaysShowsDecimalSeparator = false
        return formatter
    }()
}
