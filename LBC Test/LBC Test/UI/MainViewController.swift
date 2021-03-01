//
//  CollectionViewController.swift
//  Test LBC
//
//  Created by Charles Thierry on 28/02/2021.
//

import UIKit

private let reuseIdentifier = "Cell"

class MainViewController: UICollectionViewController, PrimaryCVController {
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
        super.viewDidLoad()
    }

    /*
     // MARK: - Navigation

     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         // Get the new view controller using [segue destinationViewController].
         // Pass the selected object to the new view controller.
     }
     */

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
        guard let classified = results?.object(at: indexPath) else {
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

    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
         return true
     }
     */

    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
         return true
     }
     */

    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
         return false
     }

     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
         return false
     }

     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {

     }
     */
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout,
                        sizeForItemAt _: IndexPath) -> CGSize
    {
        let paddingSpace = sectionInsets.left * itemsPerRow
        let availableWidth = view.bounds.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        let screenRatio = view.bounds.height / view.bounds.width
        return CGSize(width: widthPerItem, height: widthPerItem * screenRatio)
    }

    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout,
                        insetForSectionAt _: Int) -> UIEdgeInsets
    {
        return sectionInsets
    }
}
