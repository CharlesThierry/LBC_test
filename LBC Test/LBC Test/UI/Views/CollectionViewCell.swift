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

    var urgentLabel: UILabel {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 8)
        label.textColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        label.backgroundColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1).withAlphaComponent(0.7)
        label.text = "URGENT"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

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
        backgroundColor = .white
        setupUI()
    }

    func setClassified(ad: ClassifiedDescription) {
        titleLabel.text = ad.title
        priceLabel.text = "\(ad.price)"
        dateLabel.text = ad.creationDate
        urgentLabel.isHidden = !ad.urgent
        imageView.image = #imageLiteral(resourceName: "placeholder")
    }

    func setupUI() {
        addSubview(imageView)
        let underview = UIView()
        underview.translatesAutoresizingMaskIntoConstraints = false
        addSubview(underview)
        underview.addSubview(titleLabel)
        underview.addSubview(priceLabel)
        underview.addSubview(urgentLabel)
        underview.addSubview(dateLabel)
        
        
        NSLayoutConstraint.activate(
            [imageView.topAnchor.constraint(equalTo: topAnchor),
             imageView.leftAnchor.constraint(equalTo: leftAnchor),
             imageView.rightAnchor.constraint(equalTo: rightAnchor),

             imageView.bottomAnchor.constraint(equalTo: underview.topAnchor),
             underview.leftAnchor.constraint(equalTo: leftAnchor),
             underview.rightAnchor.constraint(equalTo: rightAnchor),
             underview.bottomAnchor.constraint(equalTo: bottomAnchor),
             underview.heightAnchor.constraint(equalToConstant: 50),
             
             titleLabel.topAnchor.constraint(equalTo: underview.topAnchor),
             titleLabel.leftAnchor.constraint(equalTo: underview.leftAnchor),
             titleLabel.rightAnchor.constraint(equalTo: underview.rightAnchor),

             titleLabel.bottomAnchor.constraint(equalTo: priceLabel.topAnchor),
             priceLabel.leftAnchor.constraint(equalTo: underview.leftAnchor),
             priceLabel.rightAnchor.constraint(equalTo: underview.rightAnchor),

             priceLabel.bottomAnchor.constraint(equalTo: dateLabel.topAnchor),
             dateLabel.leftAnchor.constraint(equalTo: underview.leftAnchor),
             dateLabel.rightAnchor.constraint(equalTo: underview.rightAnchor),
             dateLabel.bottomAnchor.constraint(equalTo: underview.bottomAnchor)])
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("Not implemented")
    }
}
