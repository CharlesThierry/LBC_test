//
//  File.swift
//  Test LBC
//
//  Created by Charles Thierry on 03/03/2021.
//

import UIKit

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

/*
 This protocol allows the picker to inform the mainVC of which category was selected
 */
protocol SelectedRow: AnyObject {
    func selected(_: Int?)
}

extension MainViewController: SelectedRow {
    @objc
    func changeCategory() {
        let picker = CategoryPickerViewController(nibName: nil, bundle: nil)
        picker.results = results
        picker.selectedDelegate = self
        showDetailViewController(picker, sender: nil)
    }

    func selected(_ selected: Int?) {
        var categoryID: Int?
        if selected != nil {
            categoryID = results?.category(at: selected!)?.id
        }
        results?.setCategoryFilter(categoryID: categoryID)
        dismiss(animated: true, completion: nil)
        collectionView.reloadData()
    }
}
