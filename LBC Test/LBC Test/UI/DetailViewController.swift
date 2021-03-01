//
//  DetailViewController.swift
//  Test LBC
//
//  Created by Charles Thierry on 28/02/2021.
//

import UIKit

class DetailViewController: UIViewController {
    var ad: ClassifiedDescription

    var scrollView = UIScrollView()

    var imageView: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "placeholder"))
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
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
        var label = UILabel()
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

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    init(ad: ClassifiedDescription) {
        self.ad = ad
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = UIView()
        view.addSubview(scrollView)
        scrollView.setBasicConstraints(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leadingAnchor, right: view.trailingAnchor)
        scrollView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        scrollView.translatesAutoresizingMaskIntoConstraints = false

        let underview = UIView()
        underview.translatesAutoresizingMaskIntoConstraints = false
        underview.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        scrollView.addSubview(underview)
        underview.setBasicConstraints(top: scrollView.topAnchor,
                                      bottom: scrollView.bottomAnchor,
                                      left: scrollView.leadingAnchor,
                                      right: nil,
                                      width: scrollView.widthAnchor)

        underview.addSubview(imageView)

        underview.addSubview(titleLabel)
        underview.addSubview(descriptionLabel)
        underview.addSubview(dateLabel)
        //        underview.addSubview(urgentLabel)
        //        underview.addSubview(priceLabel)
        //        underview.addSubview(siretLabel)

        imageView.setBasicConstraints(top: underview.topAnchor, bottom: nil, left: underview.leadingAnchor, right: underview.trailingAnchor)
        titleLabel.setBasicConstraints(top: imageView.bottomAnchor, bottom: nil, left: underview.leadingAnchor, right: underview.trailingAnchor)
        descriptionLabel.setBasicConstraints(top: titleLabel.bottomAnchor, bottom: nil, left: underview.leadingAnchor, right: underview.trailingAnchor)
        dateLabel.setBasicConstraints(top: descriptionLabel.bottomAnchor, bottom: underview.bottomAnchor, left: underview.leadingAnchor, right: underview.trailingAnchor)
        setupUI()
    }

    func setupUI() {
        titleLabel.text = ad.title
        descriptionLabel.text = ad.description
        priceLabel.text = ad.price
        dateLabel.text = ad.creationDate
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
                    self.imageView.setMagicImage(image: image)
                }
            }
        }
    }
}
