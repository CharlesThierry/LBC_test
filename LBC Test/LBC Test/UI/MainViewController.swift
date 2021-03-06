//
//  CollectionViewController.swift
//  Test LBC
//
//  Created by Charles Thierry on 28/02/2021.
//

import UIKit

private let reuseIdentifier = "Cell"

class MainViewController: UICollectionViewController, ClassifiedViewDelegate {
    internal let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)
    internal let categoryButton: UIBarButtonItem = {
        let bbI = UIBarButtonItem(title: "Categories", style: .plain, target: nil, action: nil)
        bbI.isEnabled = false
        return bbI
    }()

    internal var itemsPerRow: CGFloat {
        return UIScreen.main.bounds.width > UIScreen.main.bounds.height ? 4.0 : 3.0
    }

    internal var results: FetchResults? { didSet {
        results?.classifiedDelegate = self
        results?.categoryDelegate = categoryButton
    }}

    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = #colorLiteral(red: 0.9653822122, green: 0.9653822122, blue: 0.9653822122, alpha: 1)
        // add a navigation bar to the controller to show a filter button
        super.viewDidLoad()
        collectionView?.contentInsetAdjustmentBehavior = .always
        categoryButton.target = self
        categoryButton.action = #selector(changeCategory)
        refreshCategoryButton()
        navigationItem.setRightBarButton(categoryButton, animated: false)
    }

    func refreshCategoryButton() {
        guard let res = results else {
            categoryButton.isEnabled = false
            return
        }
        categoryButton.isEnabled = res.numberOfCategories > 0
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in _: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        guard let res = results else { return 0 }
        return res.numberOfObjects
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        guard let classified = results?.entry(at: indexPath) else {
            fatalError("Can't fetch info for \(indexPath)")
        }
        cell.setClassified(ad: classified)

        return cell
    }

    func change(changes: [FetchChange: [(IndexPath?, IndexPath?)]]) {
        refreshCategoryButton()
        collectionView.performBatchUpdates {
            let insertsOp = changes[.insert]
            if insertsOp != nil {
                let inserts = insertsOp?.map { _, index in index! }
                collectionView.insertItems(at: inserts!)
            }

            let deletesOp = changes[.delete]
            if deletesOp != nil {
                let deletes = deletesOp?.map { index, _ in index! }
                collectionView.deleteItems(at: deletes!)
            }

            let movesOp = changes[.move]
            if movesOp != nil {
                for c in movesOp! {
                    collectionView.moveItem(at: c.0!, to: c.1!)
                }
            }
        }
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAd = results?.entry(at: indexPath)
        guard let ad = selectedAd else {
            fatalError("Selected Ad not found")
        }
        let detail = DetailViewController(ad: ad)
        showDetailViewController(detail, sender: self)
    }
}
