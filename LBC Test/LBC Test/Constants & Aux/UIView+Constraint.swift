//
//  UIView+.swift
//  Test LBC
//
//  Created by Charles Thierry on 01/03/2021.
//

import UIKit

extension UIView {
    /*
     Set the parameterized anchor equal to the related parameter.
     If multiplier is present, it will be used for width and height
     */
    func setBasicConstraints(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, right: NSLayoutXAxisAnchor?, width: NSLayoutDimension? = nil, height: NSLayoutDimension? = nil, multiplier: CGFloat? = 1) {
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
        if let width = width,
           let multiplier = multiplier
        {
            widthAnchor.constraint(equalTo: width, multiplier: multiplier).isActive = true
        }
        if let height = height,
           let multiplier = multiplier
        {
            heightAnchor.constraint(equalTo: height, multiplier: multiplier).isActive = true
        }
    }
}
