//
//  Model.swift
//  Test LBC
//
//  Created by Charles Thierry on 27/02/2021.
//

import CoreData
import Foundation

let category = "https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json"
let listing = "https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json"

// Model handles the data fetching and retains the
class Model: NSObject {
    let dataManager = DataManager()

    weak var primary: FetchResultUpdates? { didSet {
        primary?.results = FetchResults(dataManager)
    }}

    func start(_ vc: FetchResultUpdates) {
        primary = vc
        initModelData {}
    }

    func initModelData(completion: @escaping () -> Void) {
        guard let _ = primary else {
            // without a primary set, the data will be desync'd. e.g. setting the primary afterward
            // will lead to it receiving 'delete' FetchAction when there is actually 0 item displayed
            fatalError("A primary receiver must be set to sync")
        }
        DispatchQueue.global(qos: .background).async {
            self.dataManager.purge()
            self.fillCategoryData(completion)
        }
    }

    func fillCategoryData(_ completion: @escaping () -> Void) {
        let c = URL(string: category)
        guard let categoryURL = c else {
            fatalError("Model Categorystring not a URL")
        }
        httpFetch(url: categoryURL) { fetchResult in
            switch fetchResult {
            case let .failure(error):
                // TODO: handle error / warn user
                completion()
                return
            case let .success(data):
                let generateResult = generateItemsDescriptions(data: data, type: [CategoryDescription].self)
                switch generateResult {
                case let .failure(error):
                    print("Can't generate descriptions \(error)")
                case let .success(catArray):
                    self.dataManager.addCategories(catArray)
                    self.fillEntryData(completion)
                }
            }
        }
    }

    func fillEntryData(_ completion: @escaping () -> Void) {
        let c = URL(string: listing)
        guard let entryURL = c else {
            fatalError("Model Categorystring not a URL")
        }
        httpFetch(url: entryURL) { fetchResult in
            switch fetchResult {
            case let .failure(error):
                print("Can't fetch category information \(error)")
            // TODO: handle error / warn user
            case let .success(data):
                let generateResult = generateItemsDescriptions(data: data, type: [EntryDescription].self)
                switch generateResult {
                case let .failure(error):
                    print("Can't generate descriptions \(error)")
                case let .success(catArray):
                    self.dataManager.addEntries(catArray)
                }
            }
            completion()
        }
    }
}
