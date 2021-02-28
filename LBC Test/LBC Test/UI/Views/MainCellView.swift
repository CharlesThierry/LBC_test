//
//  CellViews.swift
//  Test LBC
//
//  Created by Charles Thierry on 27/02/2021.
//

import UIKit

let ClassifiedReuseIdentifier = "classifiedReuseIdentifier"

class MainCellView: UITableViewCell {
    static var reuseIdentifier: String? { ClassifiedReuseIdentifier }

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
    required init?(coder _: NSCoder) {
        fatalError("ViewCell should not be called")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titleLabel)
        contentView.addSubview(categoryLabel)
        contentView.addSubview(priceLabel)
        contentView.addSubview(picture)
        contentView.addSubview(isUrgentView)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
