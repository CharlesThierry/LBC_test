//
//  UIView+.swift
//  Test LBC
//
//  Created by Charles Thierry on 01/03/2021.
//

import UIKit

extension UIView {
    func setBasicConstraints(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, left:NSLayoutXAxisAnchor?, right: NSLayoutXAxisAnchor?, height: NSLayoutDimension? = nil, multiplier: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top {
            topAnchor.constraint(equalTo: top).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right).isActive = true
        }
        if let height = height,
           let multiplier = multiplier {
            heightAnchor.constraint(equalTo: height, multiplier: multiplier).isActive = true
        }
    }
}
