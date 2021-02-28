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
    case .delete : return .delete
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

    private var fetchResultController: NSFetchedResultsController<Entry>

    var numberOfObjects: Int {
        guard let sectionInfo = fetchResultController.sections?[0] else {
            return 0
        }
        return sectionInfo.numberOfObjects
    }

    init(_ c: NSFetchedResultsController<Entry>) {
        fetchResultController = c
        super.init()
        fetchResultController.delegate = self
    }

    func object(at index: IndexPath) -> ClassifiedDescription? {
        let entry = fetchResultController.object(at: index)
        let classified = ClassifiedDescription(entry: entry)
        return classified
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
        print("changes!")
        var operation: FetchChange = .update
        guard let operations = changeOperations else { fatalError("Illegal change operation") }
        
        switch type {
        case .insert:
            operation = .insert
        case .delete:
            print("Old \(indexPath) New \(newIndexPath)")
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
