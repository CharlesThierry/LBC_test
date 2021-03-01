//
//  UIView+Magic.swift
//  Test LBC
//
//  Created by Charles Thierry on 01/03/2021.
//

import UIKit

extension UIImageView {
    func setMagicImage(image: UIImage?) {
        self.image = image
        if let image = image {
            constraints.forEach { constraint in
                if constraint.isActive,
                   let first = constraint.firstItem,
                   self == first as! NSObject,
                   let second = constraint.secondItem,
                   self == second as! NSObject
                {
                    constraint.isActive = false
                }
            }
            self.widthAnchor.constraint(equalTo: self.heightAnchor, multiplier: image.size.width / image.size.height).isActive = true
        }
    }
}
