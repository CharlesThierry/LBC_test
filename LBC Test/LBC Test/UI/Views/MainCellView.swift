//
//  CellViews.swift
//  Test LBC
//
//  Created by Charles Thierry on 27/02/2021.
//

import UIKit

let ClassifiedReuseIdentifier = "classifiedReuseIdentifier"

class MainCellView: UITableViewCell {
    override var reuseIdentifier: String? { return ClassifiedReuseIdentifier }

    var titleLabel: UILabel
    var categoryLabel: UILabel
    var priceLabel: UILabel
    var picture: UIImage
    var isUrgentView: UIView

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("ViewCell should not be called")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
