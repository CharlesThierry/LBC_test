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
 Protocol implemented by the main view controller displaying the list of classified ads
 to allow for a refresh button
 */
protocol ModelDelegate: AnyObject {
    var model: RefreshModel? { get set }
    func modelStatusUpdate(_: Bool)
}

/*
 To avoid exposing the whole Model object to the MainViewController
 */
protocol RefreshModel: AnyObject {
    func refreshModel()
}

// Model handles the data fetching and retains the datamanager
class Model: NSObject, RefreshModel {
    let dataManager = DataManager()
    weak var delegate: ModelDelegate?

    private var _isRefreshing: Bool = false { didSet {
        if delegate != nil { delegate?.modelStatusUpdate(_isRefreshing) }
    }}
    var isRefreshing: Bool { return _isRefreshing }

    weak var primary: ClassifiedViewDelegate? { didSet {
        primary?.results = FetchResults(dataManager)
    }}

    func start(_ vc: ClassifiedViewDelegate & ModelDelegate) {
        primary = vc
        delegate = vc
        vc.model = self
        initModelData()
    }

    func refreshModel() {
        if isRefreshing {
            return
        }
        self.fillCategoryData(
            {
                self._isRefreshing = false
            }
        )
    }

    func initModelData() {
        guard let _ = primary else {
            // without a primary set, the data will be desync'd. e.g. setting the primary afterward
            // will lead to it receiving 'delete' FetchAction when there is actually 0 item displayed
            fatalError("A primary receiver must be set to sync")
        }
        DispatchQueue.global(qos: .background).async {
            /*
             This function is used to purge the database on start.
             Usefull to get the loading animations all the time
             */
            // self.dataManager.purge()
            self.refreshModel()
        }
    }

    func fillCategoryData(_ completion: @escaping () -> Void) {
        _isRefreshing = true
        let c = URL(string: category)
        guard let categoryURL = c else {
            fatalError("Model Categorystring not a URL")
        }
        httpFetch(url: categoryURL) { fetchResult in
            switch fetchResult {
            case .failure:
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
