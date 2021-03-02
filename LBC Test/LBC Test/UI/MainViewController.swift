//
//  CollectionViewController.swift
//  Test LBC
//
//  Created by Charles Thierry on 28/02/2021.
//

import UIKit

private let reuseIdentifier = "Cell"

class MainViewController: UICollectionViewController, FetchResultUpdates {
    private let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

    var itemsPerRow: CGFloat {
        return UIScreen.main.bounds.width > UIScreen.main.bounds.height ? 4.0 : 3.0
    }

    var results: FetchResults? { didSet {
        results?.delegate = self
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
        let categorySelector = UIBarButtonItem(barButtonSystemItem: .action,
                                               target: self,
                                               action: #selector(self.changeCategory))
        self.navigationItem.setRightBarButton(categorySelector, animated: false)
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAd = results?.entry(at: indexPath)
        guard let ad = selectedAd else {
            fatalError("Selected Ad not found")
        }
        let detail = DetailViewController(ad: ad)
        showDetailViewController(detail, sender: self)
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout,
                        sizeForItemAt _: IndexPath) -> CGSize
    {
        let paddingSpace = sectionInsets.left * itemsPerRow
        let availableWidth = view.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        let heightPerItem = widthPerItem * 1.6
        return CGSize(width: widthPerItem, height: heightPerItem)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout,
                        insetForSectionAt _: Int) -> UIEdgeInsets
    {
        return sectionInsets
    }
}

extension MainViewController {
    @objc
    func changeCategory () {
        let categorySelector = UIPickerView()
        categorySelector.dataSource = results
    }
}
