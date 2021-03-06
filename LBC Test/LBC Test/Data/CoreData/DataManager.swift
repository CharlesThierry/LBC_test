//
//  CoreDataManager.swift
//  LBC Test
//
//  Created by Charles Thierry on 25/02/2021.
//

import CoreData
import Foundation

let fetchBatchSize = 20

/*
 Basic CoreData implementation to store the information fetched from the JSON URLs in a database.
 3 types of entities are created (Category, Classified and Images) as described in the model.
 */
class DataManager {
    internal lazy var container: NSPersistentContainer = {
        // setting up the container with the most basic undo&merge options
        let container = NSPersistentContainer(name: CoreDataConstant.modelName)
        container.loadPersistentStores(completionHandler: { _, error in
            guard let error = error as NSError? else { return }
            fatalError("COreData Container load error: \(error), \(error.userInfo)")
        })
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    internal lazy var context: NSManagedObjectContext = {
        // this context is background, will be used for all insertion/deletion
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = container.viewContext
        return context
    }()

    init() {
        storeSetup()
//        setupFetchController()
    }

    internal func storeSetup() {
        // setting up the store description to quickload the store
        let description = NSPersistentStoreDescription()
        description.type = NSSQLiteStoreType
        description.url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first?.appendingPathComponent(CoreDataConstant.dbName)
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            guard let error = error as NSError? else { return }
            fatalError("CoreData Store load error \(error), \(error.userInfo)")
        }
    }

    // MARK: Purge will remove all data from the store

    internal func purgeInternal(entityName: CoreDataEntityNames) {
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

    func purge() {
        context.performAndWait {
            // TODO: Could probably be done by changing the deletion rule of the model & only deleting categories
            purgeInternal(entityName: CoreDataEntityNames.Category)
            purgeInternal(entityName: CoreDataEntityNames.Entry)
            purgeInternal(entityName: CoreDataEntityNames.Image)
        }
        save()
    }

    // MARK: Save the context

    internal func save() {
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

    /*
     This method is used to check the uniqueness of categories and classified based on their 'id'.
     In an ideal world, it could be handled by adding constraints to the model, but in this case
     it would mean making the relations between the classified and the category optional, which I
     choose not to do to keep a relation between the objects.
     */
    internal func checkIfEntryExists(id: Int, name: CoreDataEntityNames) -> Bool {
        let fetch = NSFetchRequest<NSFetchRequestResult>()
        fetch.entity = NSEntityDescription.entity(forEntityName: name.rawValue, in: container.viewContext)
        fetch.includesSubentities = false
        fetch.predicate = NSPredicate(format: "id == \(id)")
        var count = 0
        do {
            try count = container.viewContext.count(for: fetch)
        } catch {
            fatalError("CoreData Category add check fail \(error)")
        }
        return count == 0 // there is already a category with that ID.
    }

    // MARK: Insert Data

    func addCategories(_ cArray: [CategoryProtocol]) {
        context.performAndWait {
            for c in cArray {
                guard let id = c.id else { fatalError("CoreData Can't add a Category w/o id") }
                let isNew = checkIfEntryExists(id: id, name: CoreDataEntityNames.Category)
                if !isNew {
                    continue
                }
                // TODO: Check if the name shouldn't be overriden ?
                let entity = NSEntityDescription.entity(forEntityName: CoreDataEntityNames.Category.rawValue, in: context)
                let category = Category(entity: entity!, insertInto: context)
                category.id = Int64(id)
                category.name = c.name
            }
        }
        save()
    }

    func addEntries(_ cArray: [EntryProtocol]) {
        var count = 0
        for c in cArray {
            context.performAndWait {
                addEntry(c)
            }
            count += 1
            if count == fetchBatchSize {
                save()
                count = 0
            }
        }
        if count != 0 {
            save()
        }
    }

    internal func addEntry(_ c: EntryProtocol) {
        guard let id = c.id else { fatalError("CoreData Can't add a classified w/o an ID") }
        let isNew = checkIfEntryExists(id: id, name: CoreDataEntityNames.Entry)
        if !isNew {
            return
        }

        let entryEntity = NSEntityDescription.entity(forEntityName: CoreDataEntityNames.Entry.rawValue, in: context)
        let entry = Entry(entity: entryEntity!, insertInto: context)

        entry.id = Int64(id)
        entry.longDesc = c.description
        entry.title = c.title
        entry.price = c.price ?? -1
        entry.siret = c.siret
        entry.urgent = c.urgent ?? false
        entry.creationDate = c.creationDate

        // Fetch the category to link to this classified
        let fetch = NSFetchRequest<Category>(entityName: CoreDataEntityNames.Category.rawValue)
        fetch.predicate = NSPredicate(format: "\(CoreDataCategory.id) == \(c.categoryID ?? -1)")

        let category = try? context.fetch(fetch)
        entry.oneCategory = category?.first

        for description in c.images! {
            let imageED = NSEntityDescription.entity(forEntityName: CoreDataEntityNames.Image.rawValue, in: context)
            let images = Image(entity: imageED!, insertInto: context)
            images.title = description.title?.rawValue
            images.url = description.url
            images.oneClassified = entry
        }
    }
}
