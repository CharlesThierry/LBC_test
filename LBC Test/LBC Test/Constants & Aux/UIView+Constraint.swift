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
    func setBasicConstraints(top: NSLayoutYAxisAnchor?, bottom: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, right: NSLayoutXAxisAnchor?,
                             width: NSLayoutDimension? = nil, widthMultiplier: CGFloat? = 1.0,
                             height: NSLayoutDimension? = nil, heightMultiplier: CGFloat? = 1,
                             insets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0))
    {
        translatesAutoresizingMaskIntoConstraints = false

        if let top = top {
            topAnchor.constraint(equalTo: top, constant: insets.top).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: insets.bottom).isActive = true
        }
        if let left = left {
            leadingAnchor.constraint(equalTo: left, constant: insets.left).isActive = true
        }
        if let right = right {
            trailingAnchor.constraint(equalTo: right, constant: insets.right).isActive = true
        }
        if let width = width,
           let multiplier = widthMultiplier
        {
            widthAnchor.constraint(equalTo: width, multiplier: multiplier).isActive = true
        }
        if let height = height,
           let multiplier = heightMultiplier
        {
            heightAnchor.constraint(equalTo: height, multiplier: multiplier).isActive = true
        }
    }
}
