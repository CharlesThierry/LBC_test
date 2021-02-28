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

/*
 The MainViewController is tasked with displaying the list of Classified ads. As such,
 it is provided with a FetchedResultsController to be notified of changes in the coreData
 store. This fetchedResultController is init'd by the Model and retained by the MainCVC
 */
protocol PrimaryCVController: AnyObject, NSFetchedResultsControllerDelegate {
    var resultController: NSFetchedResultsController<Classified>! { get set }
}

/*
 The DetailCVC shows all content available for the selected Classified ad.
 */
protocol SecondaryCVController: AnyObject {
    // add information
    func showClassifiedInformation(desc: ClassifiedDescription)
}

// Model handles information distribution to both the main view and the detail view
class Model: NSObject {
    let dataManager = DataManager()

    weak var primaryC: PrimaryCVController!
    weak var secondaryC: SecondaryCVController!

    init(primary: PrimaryCVController, secondary: SecondaryCVController) {
        primaryC = primary
        primaryC.resultController = dataManager.fetchController
        primaryC.resultController.delegate = primaryC
        secondaryC = secondary
    }

    func initModelData(completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .background).async {
            self.fillCategoryData(completion)
        }
    }

    func fillCategoryData(_ completion: @escaping () -> Void) {
        let c = URL(string: category)
        guard let categoryURL = c else {
            fatalError("Model Categorystring not a URL")
        }
        fetchJson(url: categoryURL) { fetchResult in
            switch fetchResult {
            case let .failure(error):
                print("Can't fetch category information \(error)")
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
                    self.fillClassifiedData(completion)
                }
            }
        }
    }

    func fillClassifiedData(_ completion: @escaping () -> Void) {
        let c = URL(string: listing)
        guard let classifiedURL = c else {
            fatalError("Model Categorystring not a URL")
        }
        fetchJson(url: classifiedURL) { fetchResult in
            switch fetchResult {
            case let .failure(error):
                print("Can't fetch category information \(error)")
            // TODO: handle error / warn user
            case let .success(data):
                let generateResult = generateItemsDescriptions(data: data, type: [ClassifiedDescription].self)
                switch generateResult {
                case let .failure(error):
                    print("Can't generate descriptions \(error)")
                case let .success(catArray):
                    self.dataManager.addClassifieds(catArray)
                }
            }
            completion()
        }
    }
}
