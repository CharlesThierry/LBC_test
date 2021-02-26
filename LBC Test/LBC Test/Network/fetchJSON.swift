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
            return
        }
        if r.statusCode == 200 {
            if let data = data {
                var array: [[String: Any]] = [[:]]
                do {
                    array = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [[String: Any]]
                } catch {
                    print("Invalid JSON file fetched at \(url)")
                    completion(Result.failure(.dataConversionError))
                }
                completion(Result.success(array))
            } //TODO: Return Error for no data
        } //TODO: Return Error for non 200 http return code
    }
    task.resume()
}

