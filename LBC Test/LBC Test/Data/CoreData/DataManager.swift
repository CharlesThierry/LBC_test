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
    lazy var container: NSPersistentContainer = {
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

    lazy var context: NSManagedObjectContext = {
        // this context is background, will be used for all insertion/deletion
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = container.viewContext
        return context
    }()

    init() {
        storeSetup()
        setupFetchController()
    }

    func storeSetup() {
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
            purgeInternal(entityName: CoreDataEntityNames.Classified)
            purgeInternal(entityName: CoreDataEntityNames.Images)
        }
        save()
    }

    // MARK: Save the context

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

    /*
     This method is used to check the uniqueness of categories and classified based on their 'id'.
     In an ideal world, it could be handled by adding constraints to the model, but in this case
     it would mean making the relations between the classified and the category optional, which I
     choose not to do to keep a relation between the objects.
     */
    func checkIfEntryExists(id: Int, name: CoreDataEntityNames) -> Bool {
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
                category.title = c.name
            }
        }
        save()
    }

    func addClassifieds(_ cArray: [ClassifiedProtocol]) {
        for c in cArray {
            addClassified(c)
        }
    }

    internal func addClassified(_ c: ClassifiedProtocol) {
        context.performAndWait {
            guard let id = c.id else { fatalError("CoreData Can't add a classified w/o an ID") }
            let isNew = checkIfEntryExists(id: id, name: CoreDataEntityNames.Classified)
            if !isNew {
                return
            }

            let classifiedED = NSEntityDescription.entity(forEntityName: CoreDataEntityNames.Classified.rawValue, in: context)
            let classified = Classified(entity: classifiedED!, insertInto: context)

            classified.id = Int64(id)
            classified.longDesc = c.description
            classified.title = c.title
            classified.price = c.price ?? -1
            classified.siret = c.siret
            classified.urgent = c.urgent ?? false
            classified.creationDate = c.creationDate

            // Fetch the category to link to this classified
            let fetch = NSFetchRequest<Category>(entityName: CoreDataEntityNames.Category.rawValue)
            fetch.predicate = NSPredicate(format: "\(CoreDataCategory.id) == \(c.categoryID ?? -1)")

            let category = try? context.fetch(fetch)
            classified.oneCategory = category?.first

            // TODO: can there be multiple images with the same URLs?
            for description in c.images! {
                let imageED = NSEntityDescription.entity(forEntityName: CoreDataEntityNames.Images.rawValue, in: context)
                let images = Images(entity: imageED!, insertInto: context)
                images.title = description.title?.rawValue
                images.url = description.url
                images.oneClassified = classified
            }
        }
        save()
    }

    // MARK: Using fetchResultsController to update the collectionview

    var fetchController: NSFetchedResultsController<Classified>?

    func setupFetchController() {
        let request = NSFetchRequest<Classified>(entityName: CoreDataEntityNames.Classified.rawValue)
        let sortUrgent = NSSortDescriptor(key: CoreDataClassified.urgent.rawValue, ascending: false)
        let sortDate = NSSortDescriptor(key: CoreDataClassified.creationDate.rawValue, ascending: false)
        request.sortDescriptors = [sortUrgent, sortDate]
        request.fetchBatchSize = fetchBatchSize

        fetchController = NSFetchedResultsController<Classified>(fetchRequest: request, managedObjectContext:
            container.viewContext, sectionNameKeyPath: nil, cacheName: CoreDataConstant.cacheName)
        try? fetchController?.performFetch()
    }
}
