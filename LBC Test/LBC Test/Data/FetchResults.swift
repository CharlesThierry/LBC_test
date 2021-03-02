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
protocol FetchResultUpdates: AnyObject {
    var results: FetchResults? { get set }
    func change(changes: [FetchChange: [(IndexPath?, IndexPath?)]])
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

class FetchResults: NSObject, NSFetchedResultsControllerDelegate {
    var changeOperations: [FetchChange: [(IndexPath?, IndexPath?)]]?

    weak var delegate: FetchResultUpdates?

    // the formatter are init'd and retained here to avoid creating one per ClassifiedDescription
    let dateFormatter = DateFormatter.relative
    let priceFormatter = NumberFormatter.priceFormatter

    private var fetchEntryController: FetchController<Entry>
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
    
    func category(at index: IndexPath) -> CategoryDescription? {
        guard let entry = fetchCategoryController.object(at: index) else {
            fatalError("No entry for indexPath \(index)")
        }
        let category = CategoryDescription(category:entry)
        return category

    }
    
    
    
    init(_ data: DataManager) {
        dataManager = data

        fetchCategoryController = FetchController<Category>(data)
        fetchEntryController = FetchController<Entry>(data)
        super.init()
        fetchEntryController.delegate = self
        
    }


    func controllerWillChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {
        changeOperations = [FetchChange: [(IndexPath?, IndexPath?)]]()
    }

    func controllerDidChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {
        // push update to the collection view

        delegate?.change(changes: changeOperations!)
        changeOperations = nil
    }

    func controller(_: NSFetchedResultsController<NSFetchRequestResult>, didChange _: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
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
