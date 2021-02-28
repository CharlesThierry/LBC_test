//
//  CollectionViewController.swift
//  Test LBC
//
//  Created by Charles Thierry on 28/02/2021.
//

import UIKit

private let reuseIdentifier = "Cell"

class MainViewController: UICollectionViewController, PrimaryCVController {
    weak var model: Model!

    var results: FetchResults? { didSet {
        results?.delegate = self
    }}

    init(collectionViewLayout layout: UICollectionViewLayout, model: Model) {
        super.init(collectionViewLayout: layout)
        model.initModelData {}
        model.primary = self
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
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

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let res = results else { return 0 }
        return res.numberOfObjects
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cell.backgroundColor = .red
        // Configure the cell

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
