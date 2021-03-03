//
//  FetchResultsDelegate.swift
//  Test LBC
//
//  Created by Charles Thierry on 28/02/2021.
//

import CoreData
import Foundation

/*
 This protocol & class basically reimplements the NSFetchedResultsController to allow
 for the UI update without it knowing about the CoreData stuff
 */
protocol ClassifiedViewDelegate: AnyObject {
    var results: FetchResults? { get set }
    func change(changes: [FetchChange: [(IndexPath?, IndexPath?)]])
}

protocol CategoryDelegate: AnyObject {
    func change(_ newCount: Int)
}

enum FetchChange {
    case delete
    case insert
    case move
    case update
}

func change(f: NSFetchedResultsChangeType) -> FetchChange {
    switch f {
    case .delete: return .delete
    case .insert: return .insert
    case .move: return .move
    case .update: return .update
    @unknown default:
        fatalError("Non supported")
    }
}

/*
 This class keeps the FetchController and provides the data from the data core to the element that
 needs it: the mainViewController via the ClassifiedViewDelegate
 */
class FetchResults: NSObject, NSFetchedResultsControllerDelegate {
    internal var changeOperations: [FetchChange: [(IndexPath?, IndexPath?)]]?

    weak var classifiedDelegate: ClassifiedViewDelegate?
    weak var categoryDelegate: CategoryDelegate?

    // the formatter are init'd and retained here to avoid creating one per ClassifiedDescription
    internal let dateFormatter = DateFormatter.relative
    internal let priceFormatter = NumberFormatter.priceFormatter

    internal var fetchEntryController: FetchController<Entry>
    internal var fetchCategoryController: FetchController<Category>
    internal var dataManager: DataManager?

    // Entry actions
    var numberOfObjects: Int {
        return fetchEntryController.numberOfObjects()
    }

    func entry(at index: IndexPath) -> ClassifiedDescription? {
        guard let entry = fetchEntryController.object(at: index) else {
            fatalError("No entry for indexPath \(index)")
        }
        let classified = ClassifiedDescription(entry: entry, formatter: dateFormatter, priceFormatter: priceFormatter)
        return classified
    }

    func setCategory(categoryID: Int) {
        fetchEntryController.changeCategory(categoryID: categoryID)
    }

    // Category action
    var numberOfCategories: Int {
        return fetchCategoryController.numberOfObjects()
    }

    func category(at index: Int) -> CategoryDescription? {
        guard let entry = fetchCategoryController.object(at: IndexPath(row: index, section: 0)) else {
            fatalError("No entry for indexPath \(index)")
        }
        let category = CategoryDescription(category: entry)
        return category
    }

    func setCategoryFilter(categoryID cID: Int?) {
        fetchEntryController.changeCategory(categoryID: cID)
    }

    init(_ data: DataManager) {
        dataManager = data

        fetchCategoryController = FetchController<Category>(data)
        fetchEntryController = FetchController<Entry>(data)
        super.init()
        fetchEntryController.delegate = self
        fetchCategoryController.delegate = self
    }

    func controllerWillChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {
        changeOperations = [FetchChange: [(IndexPath?, IndexPath?)]]()
    }

    func controllerDidChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {
        // push update to the collection view

        classifiedDelegate?.change(changes: changeOperations!)
        changeOperations = nil
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange _: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if controller == fetchCategoryController.fetch {
            guard let delegate = categoryDelegate else {
                return
            }
            delegate.change(fetchCategoryController.numberOfObjects())
        } else {
            var operation: FetchChange = .update
            guard let operations = changeOperations else { fatalError("Illegal change operation") }

            switch type {
            case .insert:
                operation = .insert
            case .delete:
                operation = .delete
            case .move:
                operation = .move
            case .update:
                operation = .update
            @unknown default:
                print("Not supported")
            }

            var changeSet = operations[operation]
            if changeSet == nil {
                changeSet = [(IndexPath, IndexPath)]()
            }
            changeSet?.append((indexPath, newIndexPath))

            changeOperations![operation] = changeSet
        }
    }
}
