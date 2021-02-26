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

func fetchJson (url: URL, completion: @escaping (Result<[[String: Any]], FetchingError>) -> Void) {
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
        var array: [[String: Any]] = [[:]]
        do {
            array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String: Any]]
        } catch {
            print("Invalid JSON file fetched at \(url)")
            completion(Result.failure(.dataConversionError))
        }
        completion(Result.success(array))
    }
    task.resume()
}

