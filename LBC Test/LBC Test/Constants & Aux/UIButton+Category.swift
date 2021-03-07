//
//  File.swift
//  Test LBC
//
//  Created by Charles Thierry on 03/03/2021.
//

import UIKit

extension UIButton: CategoryDelegate {
    func change(_ newCount: Int) {
        isEnabled = newCount > 0
    }
}
