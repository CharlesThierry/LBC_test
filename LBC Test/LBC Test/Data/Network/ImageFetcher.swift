//
//  ImageFetcher.swift
//  Test LBC
//
//  Created by Charles Thierry on 01/03/2021.
//

import UIKit

class ImageFetcher {
    var session : URLSession = {
        // The default iOS sessionConfiguration comes with the cache policy .useProtocolCachePolicy
        // so cache configuration respects the server configuration
        let session = URLSession(configuration: URLSessionConfiguration.default)
        return session
    }()
    
    func fetchImageAt(_ url: String, completion: @escaping () -> (UIImage)) {
        
    }
}
