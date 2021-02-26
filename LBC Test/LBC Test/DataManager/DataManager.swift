//
//  CoreDataManager.swift
//  LBC Test
//
//  Created by Charles Thierry on 25/02/2021.
//

import Foundation
import CoreData

class DataManager {
    lazy var container: NSPersistentContainer = {
        // setting up the container with the most basic undo&merge options
        let container = NSPersistentContainer(name: CoreDataConstant.modelName)
        container.loadPersistentStores(completionHandler: { (_, error) in
            guard let error = error as NSError? else { return }
            fatalError("COreData Container load error: \(error), \(error.userInfo)")
        })
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    lazy var context: NSManagedObjectContext = {
        // this context is background, will be used for all insertion/deletion
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = container.viewContext
        return context
    }()

    init () {
        storeSetup()
    }

    func storeSetup() {
        // setting up the store description to quickload the store
        let description = NSPersistentStoreDescription()
        description.type = NSSQLiteStoreType
        description.url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first?.appendingPathComponent(CoreDataConstant.dbName)
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { (_, error) in
            guard let error = error as NSError? else { return }
            fatalError("CoreData Store load error \(error), \(error.userInfo)")
        }
    }
    
    internal func purgeInternal(entityName: CoreDataEntityNames)  {
        let request = NSFetchRequest<NSManagedObject>()
        request.entity = NSEntityDescription.entity(forEntityName: entityName.rawValue, in: context)
        request.includesSubentities = false
        var classified = [NSManagedObject]()
        do {
            try classified = context.fetch(request)
        } catch {
            print("CoreData no Classified to fetch")
        }
        classified.forEach { c in
            context.delete(c)
        }

    }
    func purge () {
        context.performAndWait {
            //TODO: Could be done by changing the deletion rule of the model & only deleting categories
            purgeInternal(entityName: CoreDataEntityNames.Category)
            purgeInternal(entityName: CoreDataEntityNames.Classified)
            purgeInternal(entityName: CoreDataEntityNames.Images)
        }
        save()
    }
    
// Store and context update
    func save() {
        context.performAndWait {
            if context.hasChanges {
                // Only time container.viewContext is supposed to have changes is when
                // self.context saved changes. Save the former after the later
                do {
                    try context.save()
                    try container.viewContext.save()
                } catch {
                    let e = error as NSError
                    fatalError("CoreData Context Save error \(e), \(e.userInfo)")
                }
            }
        }
    }

    func addCategories(_ cArray: [CategoryProtocol]) {
        //TODO: check if the id doesn't already exist ?
        context.performAndWait {
            for c in cArray {
                let entity = NSEntityDescription.entity(forEntityName: CoreDataEntityNames.Category.rawValue, in: context)
                let category = Category(entity: entity!, insertInto: context)
                category.id = c.id
                category.title = c.name
            }
        }
        save()

    }

    func addClassified(_ c: ClassifiedProtocol) {
        context.performAndWait {
            //TODO: check if the id doesn't already exist ?
            let entity = NSEntityDescription.entity(forEntityName: CoreDataEntityNames.Classified.rawValue, in: context)
            let classified = Classified(entity: entity!, insertInto: context)
            classified.creationDate = c.creationDate
            classified.id = c.id
            classified.longDesc = c.description
            classified.title = c.title
            classified.price = c.price
            classified.siret = c.siret
            classified.urgent = c.urgent
            //TODO: missing a few entries - the link to category and images mainly
            let fetch = NSFetchRequest<Category>(entityName: CoreDataEntityNames.Category.rawValue)
            fetch.predicate = NSPredicate(format: "\(CoreDataClassified.id) == \(c.categoryID)")

            let category = try? context.fetch(fetch)
            classified.oneCategory = category?.first

        }
        save()
    }
    
    func count(entity: CoreDataEntityNames) -> Int {
        let countRequest = NSFetchRequest<NSFetchRequestResult>()
        countRequest.entity = NSEntityDescription.entity(forEntityName: entity.rawValue, in: container.viewContext)
        countRequest.includesSubentities = false
        var count = 0
        do {
            count = try self.container.viewContext.count(for: countRequest)
        } catch {
            fatalError("CoreData Context Count error \(error)")
        }
        return count
    }
    
    func count() -> Int {
        return count(entity: CoreDataEntityNames.Classified)
    }
    
}