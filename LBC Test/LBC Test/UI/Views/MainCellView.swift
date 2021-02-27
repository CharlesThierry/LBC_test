//
//  CellViews.swift
//  Test LBC
//
//  Created by Charles Thierry on 27/02/2021.
//

import UIKit

let ClassifiedReuseIdentifier = "classifiedReuseIdentifier"

class MainCellView: UITableViewCell {
    static var reuseIdentifier: String? { return ClassifiedReuseIdentifier }

    var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    var categoryLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    var priceLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    var picture: UIImageView = {
        let image = UIImageView(frame: .zero)
        return image
    }()

    var isUrgentView: UIView = {
        let view = UIView()
        return view
    }()

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("ViewCell should not be called")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(titleLabel)
        addSubview(categoryLabel)
        addSubview(priceLabel)
        addSubview(picture)
        addSubview(isUrgentView)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
