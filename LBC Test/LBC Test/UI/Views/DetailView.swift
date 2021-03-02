//
//  DetailView.swift
//  Test LBC
//
//  Created by Charles Thierry on 02/03/2021.
//

import UIKit

class DetailView: UIView {
    var ad: ClassifiedDescription
    var controller: DetailViewController?

    private let inset = UIEdgeInsets(top: 5.0, left: 5.0, bottom: -5.0, right: -5.0)

    var scrollView: UIScrollView = {
        let scrollview = UIScrollView(frame: .zero)
        scrollview.contentInsetAdjustmentBehavior = .always
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        return scrollview
    }()

    var imageView: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "placeholder"))
        image.accessibilityIdentifier = "DetailImageV"
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    var titleLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.accessibilityIdentifier = "DetailTitleL"
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var descriptionLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.accessibilityIdentifier = "DetailDescriptionL"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var priceLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.accessibilityIdentifier = "DetailPriceL"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var urgentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.accessibilityIdentifier = "DetailUrgentL"
        label.textAlignment = .center
        label.textColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
        label.backgroundColor = #colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1).withAlphaComponent(0.9)
        label.layer.cornerRadius = 5.0
        label.text = "URGENT"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var categoryLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).withAlphaComponent(0.7)
        label.accessibilityIdentifier = "DetailCategoryL"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var siretLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.accessibilityIdentifier = "DetailSiretL"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var dateLabel: UILabel = {
        var label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.accessibilityIdentifier = "DetailDateL"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var closeButton: UIButton = {
        var btn: UIButton
        if #available(iOS 13.0, *) {
            btn = UIButton(type: .close)
        } else {
            btn = UIButton(frame: .zero)
            btn.setImage(UIImage(named: "Close Button"), for: .normal)
            btn.tintColor = #colorLiteral(red: 0.6840892674, green: 0.6840892674, blue: 0.6840892674, alpha: 1)
            btn.widthAnchor.constraint(equalTo: btn.heightAnchor).isActive = true
            btn.widthAnchor.constraint(equalToConstant: 44).isActive = true
        }
        return btn
    }()

    init(_ detail: ClassifiedDescription) {
        ad = detail
        super.init(frame: .zero)

        addSubview(scrollView)
        scrollView.setBasicConstraints(top: safeAreaLayoutGuide.topAnchor, bottom: bottomAnchor, left: safeAreaLayoutGuide.leadingAnchor, right: safeAreaLayoutGuide.trailingAnchor)
        scrollView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)
        scrollView.addSubview(urgentLabel)
        scrollView.addSubview(categoryLabel)
        imageView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        imageView.widthAnchor.constraint(equalTo: safeAreaLayoutGuide.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.7).isActive = true

        categoryLabel.setBasicConstraints(top: imageView.topAnchor, bottom: nil, left: imageView.leadingAnchor, right: imageView.trailingAnchor)
        urgentLabel.setBasicConstraints(top: nil, bottom: imageView.bottomAnchor, left: imageView.leadingAnchor, right: imageView.trailingAnchor)
        
        
        let underview = UIView()
        underview.accessibilityIdentifier = "DetailUnderview"
        underview.translatesAutoresizingMaskIntoConstraints = false
        underview.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        scrollView.addSubview(underview)

        underview.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: inset.top).isActive = true
        underview.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: inset.left).isActive = true
        underview.widthAnchor.constraint(equalTo: scrollView.widthAnchor, constant: -2 * inset.left).isActive = true
        underview.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: inset.bottom).isActive = true

        underview.addSubview(titleLabel)
        underview.addSubview(descriptionLabel)
        underview.addSubview(dateLabel)
        underview.addSubview(priceLabel)
        underview.addSubview(siretLabel)

        titleLabel.setBasicConstraints(top: underview.topAnchor, bottom: nil,
                                       left: underview.leadingAnchor, right: underview.trailingAnchor,
                                       insets: inset)
        descriptionLabel.setBasicConstraints(top: titleLabel.bottomAnchor, bottom: nil,
                                             left: underview.leadingAnchor, right: underview.trailingAnchor,
                                             insets: inset)
        dateLabel.setBasicConstraints(top: descriptionLabel.bottomAnchor, bottom: nil,
                                      left: underview.leadingAnchor, right: underview.trailingAnchor,
                                      insets: inset)
        priceLabel.setBasicConstraints(top: dateLabel.bottomAnchor, bottom: nil,
                                       left: underview.leadingAnchor, right: underview.trailingAnchor,
                                       insets: inset)
        siretLabel.setBasicConstraints(top: priceLabel.bottomAnchor, bottom: underview.safeAreaLayoutGuide.bottomAnchor,
                                       left: underview.leadingAnchor, right: underview.trailingAnchor,
                                       insets: inset)

        addSubview(closeButton)
        closeButton.setBasicConstraints(top: safeAreaLayoutGuide.topAnchor, bottom: nil, left: safeAreaLayoutGuide.leadingAnchor, right: nil)

        setupUI()
    }

    func setupUI() {
        titleLabel.text = ad.title
        descriptionLabel.text = ad.description
        priceLabel.text = ad.price
        dateLabel.text = ad.creationDate
        imageView.image = #imageLiteral(resourceName: "placeholder")
        siretLabel.text = ad.siret
        urgentLabel.isHidden = !ad.urgent
        categoryLabel.text = ad.categoryName

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

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
