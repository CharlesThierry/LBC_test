//
//  FetchController.swift
//  Test LBC
//
//  Created by Charles Thierry on 02/03/2021.
//

import CoreData

class FetchController<Results> where Results: NSManagedObject {
    var fetch: NSFetchedResultsController<Results>
    internal weak var dataManager: DataManager?
    internal var request: NSFetchRequest<Results>

    weak var delegate: NSFetchedResultsControllerDelegate? { didSet {
        fetch.delegate = delegate
    }}

    init(_ dM: DataManager, entityName: CoreDataEntityNames, sort: (_: NSFetchRequest<Results>) -> Void) {
        dataManager = dM
        request = NSFetchRequest<Results>(entityName: entityName.rawValue)
        sort(request)
        fetch = NSFetchedResultsController<Results>(fetchRequest: request, managedObjectContext:
            dM.container.viewContext, sectionNameKeyPath: nil, cacheName:nil)
    }

    func object(at: IndexPath) -> Results? {
        return fetch.object(at: at)
    }

    func numberOfObjects() -> Int {
        guard let fetched = fetch.fetchedObjects else {
            return 0
        }
        return fetched.count
    }

    func setupRequest(_: NSFetchRequest<Results>, _: DataManager) {
        fatalError("Should not be called")
    }
}

extension FetchController where Results: Category {
    convenience init(_ dM: DataManager) {
        self.init(dM, entityName: CoreDataEntityNames.Category) { request in
            let sortID = NSSortDescriptor(key: CoreDataCategory.id.rawValue, ascending: false)
            request.sortDescriptors = [sortID]
        }
        do {
            try fetch.performFetch()
        } catch {
            print("Error on Category fetch \(error) ")
        }
    }
    func object(at: IndexPath) -> Results? {
        try? fetch.performFetch()
        return fetch.object(at: at)
    }
}

extension FetchController where Results: Entry {
    convenience init(_ dM: DataManager) {
        self.init(dM, entityName: CoreDataEntityNames.Entry) { request in
            let sortUrgent = NSSortDescriptor(key: CoreDataEntry.urgent.rawValue, ascending: false)
            let sortDate = NSSortDescriptor(key: CoreDataEntry.creationDate.rawValue, ascending: false)
            request.sortDescriptors = [sortUrgent, sortDate]
            request.fetchBatchSize = fetchBatchSize
        }
        do {
            try fetch.performFetch()
        } catch {
            print("Error on Entry fetch \(error) ")
        }
    }
    func changeCategory(categoryID cID: Int?) {
        var categoryPredicate: NSPredicate?
        if cID != nil {
            categoryPredicate = NSPredicate(format: "oneCategory.id == \(cID!)")
        }
        fetch.fetchRequest.predicate = categoryPredicate
        do {
            try fetch.performFetch()
        } catch {
            print("Error on Entry fetch \(error) ")
        }

    }
}
