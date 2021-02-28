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

    var ad: ClassifiedDescription? { didSet {
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        titleLabel.text = formatter1.string(from: ad!.creationDate)

        if !ad!.urgent { isUrgentView.backgroundColor = UIColor.green }
        else { isUrgentView.backgroundColor = UIColor.red }

    }}

    var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        label.numberOfLines = 0
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
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
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
        setupUIConstraints()
    }

    func setupUIConstraints() {
        NSLayoutConstraint.activate([
            isUrgentView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor),
            isUrgentView.leftAnchor.constraint(greaterThanOrEqualTo: contentView.leftAnchor),
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor),
            titleLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            titleLabel.leftAnchor.constraint(greaterThanOrEqualTo: contentView.leftAnchor),
            titleLabel.rightAnchor.constraint(lessThanOrEqualTo: contentView.rightAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
