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
    case noDataError
    case connectionError
    case httpError
}

enum ConversionError: Error {
    case dataConversionError
}

func fetchJson(url: URL, completion: @escaping (Result<Data, FetchingError>) -> Void) {
    let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
    var request = URLRequest(url: url)

    request.httpMethod = "GET"
    let task = session.dataTask(with: request) { data, response, error in
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
        completion(Result.success(data))
    }
    task.resume()
}

func generateItemsDescriptions<DescriptionArray>(data: Data, type: DescriptionArray.Type) -> Result<DescriptionArray, ConversionError> where DescriptionArray: Decodable {
    do {
        let decoder = JSONDecoder()
        // date format needs a custom formatter to be decoded
        decoder.dateDecodingStrategy = .formatted(DateFormatter.custom)
        let array = try decoder.decode(type, from: data)
        return Result.success(array)
    } catch {
        print("JSON Conversion failed \(error)")
        return Result.failure(.dataConversionError)
    }
}
