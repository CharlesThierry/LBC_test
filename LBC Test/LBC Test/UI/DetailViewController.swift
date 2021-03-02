//
//  DetailViewController.swift
//  Test LBC
//
//  Created by Charles Thierry on 28/02/2021.
//

import UIKit
// TODO: Add a close button or use overshoot dragdown movement to close
class DetailViewController: UIViewController {
    var ad: ClassifiedDescription

    var scrollView = UIScrollView()

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
        scrollView.addSubview(imageView)
        scrollView.addSubview(urgentLabel)
        
        imageView.setBasicConstraints(top: scrollView.topAnchor, bottom: nil, left: scrollView.leadingAnchor, right: nil, width: view.widthAnchor, height: view.heightAnchor, heightMultiplier: 0.8)

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
}
