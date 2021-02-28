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
    func beginUpdate()
    func endUpdate()
    func change(change: FetchChange, wasAt: IndexPath?, nowAt: IndexPath?)
}

enum FetchChange {
    case delete
    case insert
    case move
}

class FetchResults: NSObject, NSFetchedResultsControllerDelegate {
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
        delegate?.beginUpdate()
    }

    func controllerDidChangeContent(_: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.endUpdate()
    }

    func controller(_: NSFetchedResultsController<NSFetchRequestResult>, didChange _: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            delegate?.change(change: .insert, wasAt: indexPath, nowAt: newIndexPath)
        case .delete:
            delegate?.change(change: .delete, wasAt: indexPath, nowAt: newIndexPath)
        case .move:
            delegate?.change(change: .move, wasAt: indexPath, nowAt: newIndexPath)
        case .update:
            print("Not supported")
        @unknown default:
            print("Not supported")
        }
    }
}
