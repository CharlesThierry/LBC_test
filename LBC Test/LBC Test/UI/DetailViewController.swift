//
//  DetailViewController.swift
//  Test LBC
//
//  Created by Charles Thierry on 28/02/2021.
//

import UIKit

class DetailViewController: UIViewController {
    var entry: EntryDescription

    var scrollView = UIScrollView()

    var imageView: UIImageView = {
        let image = UIImageView(image: #imageLiteral(resourceName: "placeholder"))
        return image
    }()

    var titleLabel: UILabel = {
        var label = UILabel()
        return label
    }()

    var descriptionLabel: UILabel = {
        var label = UILabel()
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

    init(entry: EntryDescription) {
        self.entry = entry
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = UIView()
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(urgentLabel)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(descriptionLabel)
        scrollView.addSubview(priceLabel)
        scrollView.addSubview(dateLabel)
        scrollView.addSubview(siretLabel)
        scrollView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        scrollView.setBasicConstraints(top: view.topAnchor, bottom: view.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor)
        imageView.setBasicConstraints(top: scrollView.topAnchor, bottom: nil, left: scrollView.leftAnchor, right: nil, width: view.widthAnchor, multiplier: 0.9)
        titleLabel.setBasicConstraints(top: imageView.bottomAnchor, bottom: nil, left: scrollView.leftAnchor, right: scrollView.rightAnchor)
        descriptionLabel.setBasicConstraints(top: titleLabel.bottomAnchor, bottom: nil, left: scrollView.leftAnchor, right: scrollView.rightAnchor)
        dateLabel.setBasicConstraints(top: descriptionLabel.bottomAnchor, bottom: nil, left: scrollView.leftAnchor, right: scrollView.rightAnchor)
    }
}
