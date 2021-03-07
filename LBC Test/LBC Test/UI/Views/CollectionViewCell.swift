//
//  CollectionViewCell.swift
//  Test LBC
//
//  Created by Charles Thierry on 28/02/2021.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    private let inset = UIEdgeInsets(top: 2.0, left: 4.0, bottom: -2.0, right: -4.0)

    internal var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    internal var priceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    internal var urgentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 10)
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        label.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1).withAlphaComponent(0.9)
        label.text = "label_urgent".localized()
        return label
    }()

    internal var categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.7)
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        label.clipsToBounds = true
        return label
    }()

    internal var imageView: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 5.0
        image.translatesAutoresizingMaskIntoConstraints = false
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()

    internal var underview: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5.0
        view.layer.borderWidth = 1.0
        view.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).withAlphaComponent(0.3).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view.clipsToBounds = true
        return view
    }()

    internal var upperview: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5.0
        view.layer.borderWidth = 1.0
        view.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).withAlphaComponent(0.3).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    func setClassified(ad: ClassifiedDescription) {
        titleLabel.text = ad.title
        priceLabel.text = ad.price
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
        // setup the top subview with the image, category and urgent label
        addSubview(upperview)
        upperview.setBasicConstraints(top: topAnchor, bottom: nil, left: leadingAnchor, right: trailingAnchor)

        upperview.addSubview(imageView)
        upperview.addSubview(categoryLabel)
        upperview.addSubview(urgentLabel)

        imageView.setBasicConstraints(top: upperview.topAnchor, bottom: upperview.bottomAnchor, left: upperview.leadingAnchor, right: upperview.trailingAnchor)

        categoryLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        categoryLabel.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
        categoryLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true

        urgentLabel.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
        urgentLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor).isActive = true
        urgentLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor).isActive = true

        // setup the bottom subview with the price and title label
        addSubview(underview)
        underview.setBasicConstraints(top: upperview.bottomAnchor, bottom: bottomAnchor,
                                      left: leadingAnchor, right: trailingAnchor, insets: UIEdgeInsets(top: 5.0, left: 0.0, bottom: 0.0, right: 0.0))
        underview.heightAnchor.constraint(equalToConstant: 54).isActive = true

        underview.addSubview(titleLabel)
        underview.addSubview(priceLabel)

        titleLabel.setBasicConstraints(top: underview.topAnchor, bottom: nil, left: underview.leadingAnchor, right: underview.trailingAnchor, insets: inset)
        priceLabel.setBasicConstraints(top: titleLabel.bottomAnchor, bottom: underview.bottomAnchor, left: underview.leadingAnchor, right: underview.trailingAnchor, insets: inset)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("Not implemented")
    }
}
