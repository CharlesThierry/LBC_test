//
//  DataManager+tests.swift
//  Test LBC
//
//  Created by Charles Thierry on 27/02/2021.
//

@testable import Test_LBC

import CoreData
import Foundation

extension DataManager {
    func count(entity: CoreDataEntityNames) -> Int {
        let countRequest = NSFetchRequest<NSFetchRequestResult>()
        countRequest.entity = NSEntityDescription.entity(forEntityName: entity.rawValue, in: container.viewContext)
        countRequest.includesSubentities = false
        var count = 0
        do {
            count = try container.viewContext.count(for: countRequest)
        } catch {
            fatalError("CoreData Context Count error \(error)")
        }
        return count
    }

    func count() -> Int {
        count(entity: CoreDataEntityNames.Entry)
    }
}
