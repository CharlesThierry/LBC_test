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

    init(_ dM: DataManager, entityName: CoreDataEntityNames, sort: (_: NSFetchRequest<Results>) -> ()) {
        dataManager = dM
        request = NSFetchRequest<Results>(entityName: entityName.rawValue)
        sort(request)
        fetch = NSFetchedResultsController<Results>(fetchRequest: request, managedObjectContext:
            dM.container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
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

    func setupRequest(_ request: NSFetchRequest<Results>, _ dM: DataManager) {
        fatalError("Should not be called")
    }
}

extension FetchController where Results: Category {
    convenience init(_ dM: DataManager) {
        self.init(dM, entityName: CoreDataEntityNames.Category) { request in
            let sortName = NSSortDescriptor(key: CoreDataCategory.title.rawValue, ascending: false)
            request.sortDescriptors = [sortName]
        }
        do {
            try fetch.performFetch()
        } catch {
            print("Error on Category fetch \(error) ")
        }
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

    func setupRequest(_ request: NSFetchRequest<Results>, _ dM: DataManager) {}

    func changeCategory(categoryID cID: Int?) {
        var categoryPredicate: NSPredicate?
        if cID != nil {
            categoryPredicate = NSPredicate(format: "oneCategory.id == \(cID!)")
        }
        request.predicate = categoryPredicate
    }
}
