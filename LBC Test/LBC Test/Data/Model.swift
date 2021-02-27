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

class Model {
    weak var viewController: ViewController!

    let dataManager = DataManager()

    func initModelData() {}

    func fillCategoryData() {
        let c = URL(string: category)
        guard let categoryURL = c else {
            fatalError("Model Categorystring not a URL")
        }
        fetchJson(url: categoryURL) { fetchResult in
            switch fetchResult {
            case .failure(let error):
                print("Can't fetch category information \(error)")
                // TODO: handle error / warn user
                return
            case .success(let data):
                // TODO: load category in memory
                let generateResult = generateItemsDescriptions(data: data, type: [CategoryDescription].self)
                switch generateResult {
                case .failure(let error):
                    print("Can't generate descriptions \(error)")
                    return
                case .success(let catArray):
                    self.dataManager.addCategories(catArray)
                    return
                }
            }
        }
    }

    func fillClassifiedData() {
        let c = URL(string: listing)
        guard let classifiedURL = c else {
            fatalError("Model Categorystring not a URL")
        }
        fetchJson(url: classifiedURL) { fetchResult in
            switch fetchResult {
            case .failure(let error):
                print("Can't fetch category information \(error)")
                // TODO: handle error / warn user
                return
            case .success(let data):
                // TODO: load category in memory
                let generateResult = generateItemsDescriptions(data: data, type: [ClassifiedDescription].self)
                switch generateResult {
                case .failure(let error):
                    print("Can't generate descriptions \(error)")
                    return
                case .success(let catArray):
                    self.dataManager.addClassifieds(catArray)
                    return
                }
            }
        }
    }

    func start() {}
}
