//
//  File.swift
//  Test LBC
//
//  Created by Charles Thierry on 26/02/2021.
//

import Foundation
// the Category JSON is available at https://raw.githubusercontent.com/leboncoin/paperclip/master/categories.json
// the Classified ads JSON is available at https://raw.githubusercontent.com/leboncoin/paperclip/master/listing.json
enum FetchingError: Error {
    case downloadError
    case dataConversionError
    case noDataError
    case connectionError
    case httpError
}

// TODO: Use generics to fetch the Classified description
func fetchJson(url: URL, completion: @escaping (Result<[CategoryDescription], FetchingError>) -> Void) {
    let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
    var request = URLRequest(url: url)

    request.httpMethod = "GET"
    let task = session.dataTask(with: request) { (data, response, error) in
        if let _ = error {
            print("Couldn't download the file at \(url)")
            completion(Result.failure(.downloadError))
            return
        }
        guard let r = response as? HTTPURLResponse else {
            completion(Result.failure(.connectionError))
            return
        }
        guard r.statusCode == 200 else {
            completion(Result.failure(.httpError))
            return
        }
        guard let data = data else {
            completion(Result.failure(.noDataError))
            return
        }
        
        do {
            let decoder = JSONDecoder()
            let array = try decoder.decode([CategoryDescription].self, from: data)
            completion(Result.success(array))
        } catch {
            print("Invalid JSON file fetched at \(url)")
            completion(Result.failure(.dataConversionError))
        }
    }
    task.resume()
}

func generateItemsDescriptions () {
    
}


func populateItemsDescriptions () {
    
}
