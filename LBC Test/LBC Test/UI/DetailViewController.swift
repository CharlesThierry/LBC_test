//
//  DetailViewController.swift
//  Test LBC
//
//  Created by Charles Thierry on 28/02/2021.
//

import UIKit

class DetailViewController: UIViewController {
    var ad: ClassifiedDescription

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
        let detail = DetailView(ad)
        detail.closeButton.addTarget(self, action: #selector(dismissController), for: .touchUpInside)
        view = detail
    }

    @objc
    func dismissController() {
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
