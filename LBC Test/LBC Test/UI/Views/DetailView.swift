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

    var scrollView: UIScrollView = {
        let scrollview = UIScrollView(frame: .zero)
        scrollview.contentInsetAdjustmentBehavior = .always
        return scrollview
    }()

    var imageView: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "placeholder"))
        image.contentMode = .scaleAspectFit
        image.clipsToBounds = true
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    var titleLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    var descriptionLabel: UILabel = {
        var label = UILabel()
        label.numberOfLines = 0
        return label
    }()

    var priceLabel: UILabel = {
        var label = UILabel()
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
        var label = UILabel()
        return label
    }()

    var siretLabel: UILabel = {
        var label = UILabel()
        return label
    }()

    var dateLabel: UILabel = {
        var label = UILabel()
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
        scrollView.setBasicConstraints(top: safeAreaLayoutGuide.topAnchor, bottom: safeAreaLayoutGuide.bottomAnchor, left: safeAreaLayoutGuide.leadingAnchor, right: safeAreaLayoutGuide.trailingAnchor)
        scrollView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(imageView)
        scrollView.addSubview(urgentLabel)

        imageView.setBasicConstraints(top: scrollView.topAnchor, bottom: nil, left: scrollView.leadingAnchor, right: nil, width: safeAreaLayoutGuide.widthAnchor, height: heightAnchor, heightMultiplier: 0.7)

        let underview = UIView()
        underview.translatesAutoresizingMaskIntoConstraints = false
        underview.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        scrollView.addSubview(underview)
        underview.setBasicConstraints(top: imageView.bottomAnchor,
                                      bottom: scrollView.bottomAnchor,
                                      left: scrollView.leadingAnchor,
                                      right: nil,
                                      width: scrollView.widthAnchor)

        underview.addSubview(titleLabel)
        underview.addSubview(descriptionLabel)
        underview.addSubview(dateLabel)
        underview.addSubview(priceLabel)
        underview.addSubview(siretLabel)
        urgentLabel.setBasicConstraints(top: nil, bottom: imageView.bottomAnchor, left: nil, right: imageView.trailingAnchor)
        titleLabel.setBasicConstraints(top: imageView.bottomAnchor, bottom: nil, left: underview.leadingAnchor, right: underview.trailingAnchor)
        descriptionLabel.setBasicConstraints(top: titleLabel.bottomAnchor, bottom: nil, left: underview.leadingAnchor, right: underview.trailingAnchor)
        dateLabel.setBasicConstraints(top: descriptionLabel.bottomAnchor, bottom: nil, left: underview.leadingAnchor, right: underview.trailingAnchor)
        priceLabel.setBasicConstraints(top: dateLabel.bottomAnchor, bottom: nil, left: underview.leadingAnchor, right: underview.trailingAnchor)
        siretLabel.setBasicConstraints(top: priceLabel.bottomAnchor, bottom: underview.bottomAnchor, left: underview.leadingAnchor, right: underview.trailingAnchor)

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
