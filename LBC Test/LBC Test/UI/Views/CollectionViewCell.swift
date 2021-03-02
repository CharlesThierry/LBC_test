//
//  CollectionViewCell.swift
//  Test LBC
//
//  Created by Charles Thierry on 28/02/2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var urgentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        label.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1).withAlphaComponent(0.9)
        label.layer.cornerRadius = 5.0
        label.text = "URGENT"
        return label
    }()

    var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.7)
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        setupUI()
    }

    func setClassified(ad: ClassifiedDescription) {
        titleLabel.text = ad.title
        priceLabel.text = ad.price
        dateLabel.text = ad.creationDate
        urgentLabel.isHidden = !ad.urgent
        categoryLabel.text = ad.categoryName

        imageView.image = #imageLiteral(resourceName: "placeholder")
        if ad.coverPicturePath == "placeholder" { return }
        let url = URL(string: ad.coverPicturePath)
        if url == nil { return }

        httpFetch(url: url!) { fetchResult in
            switch fetchResult {
            case let .failure(error):
                print("Could not fetch the related image \(error)")
            case let .success(data):
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.imageView.image = image
                }
            }
        }
    }

    func setupUI() {
        addSubview(imageView)
        addSubview(categoryLabel)
        addSubview(urgentLabel)

        let underview = UIView()
        underview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(underview)

        underview.addSubview(titleLabel)
        underview.addSubview(priceLabel)
        underview.addSubview(dateLabel)

        categoryLabel.setBasicConstraints(top: imageView.topAnchor, bottom: nil, left: imageView.leadingAnchor, right: nil)

        urgentLabel.setBasicConstraints(top: nil, bottom: imageView.bottomAnchor, left: nil, right: imageView.trailingAnchor)

        imageView.setBasicConstraints(top: topAnchor, bottom: underview.topAnchor, left: leadingAnchor, right: trailingAnchor)

        underview.setBasicConstraints(top: nil, bottom: bottomAnchor, left: leadingAnchor, right: trailingAnchor, height: heightAnchor, heightMultiplier: 0.3)

        titleLabel.setBasicConstraints(top: underview.topAnchor, bottom: nil, left: underview.leadingAnchor, right: underview.trailingAnchor)

        priceLabel.setBasicConstraints(top: titleLabel.bottomAnchor, bottom: nil, left: underview.leadingAnchor, right: underview.trailingAnchor)

        dateLabel.setBasicConstraints(top: priceLabel.bottomAnchor, bottom: underview.bottomAnchor, left: underview.leadingAnchor, right: underview.trailingAnchor)

        // category goes bottomright picture
        NSLayoutConstraint.activate([
            urgentLabel.topAnchor.constraint(greaterThanOrEqualTo: imageView.topAnchor),
            urgentLabel.leadingAnchor.constraint(greaterThanOrEqualTo: imageView.leadingAnchor),
        ])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("Not implemented")
    }
}
