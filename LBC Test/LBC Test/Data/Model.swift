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

class Model: NSObject, NSFetchedResultsControllerDelegate {
    let dataManager = DataManager()

    func initModelData(completion: @escaping () -> ()) {
        DispatchQueue.global(qos: .background).async {
            self.fillCategoryData(completion)
        }
    }

    func fillCategoryData(_ completion: @escaping () -> ()) {
        let c = URL(string: category)
        guard let categoryURL = c else {
            fatalError("Model Categorystring not a URL")
        }
        fetchJson(url: categoryURL) { fetchResult in
            switch fetchResult {
            case .failure(let error):
                print("Can't fetch category information \(error)")
                // TODO: handle error / warn user
                completion()
                return
            case .success(let data):
                let generateResult = generateItemsDescriptions(data: data, type: [CategoryDescription].self)
                switch generateResult {
                case .failure(let error):
                    print("Can't generate descriptions \(error)")
                case .success(let catArray):
                    self.dataManager.addCategories(catArray)
                    self.fillClassifiedData(completion)
                }
            }
        }
    }

    func fillClassifiedData(_ completion: @escaping () -> ()) {
        let c = URL(string: listing)
        guard let classifiedURL = c else {
            fatalError("Model Categorystring not a URL")
        }
        fetchJson(url: classifiedURL) { fetchResult in
            switch fetchResult {
            case .failure(let error):
                print("Can't fetch category information \(error)")
                // TODO: handle error / warn user
            case .success(let data):
                let generateResult = generateItemsDescriptions(data: data, type: [ClassifiedDescription].self)
                switch generateResult {
                case .failure(let error):
                    print("Can't generate descriptions \(error)")
                case .success(let catArray):
                    self.dataManager.addClassifieds(catArray)
                }
            }
            try? self.dataManager.fetchController?.performFetch()
            completion()
        }
    }
}
