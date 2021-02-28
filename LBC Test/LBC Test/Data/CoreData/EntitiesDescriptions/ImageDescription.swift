//
//  ImagesDescription.swift
//  Test LBC
//
//  Created by Charles Thierry on 26/02/2021.
//

import Foundation

protocol ImageProtocol {
    var title: ImagesTitle? { get }
    var url: String? { get }
}

class ImageDescription: ImageProtocol {
    internal var title: ImagesTitle?
    internal var url: String?

    init(title: ImagesTitle?,
         url: String?)
    {
        guard let optURL = url else {
            fatalError("URL is empty")
        }
        self.title = title
        self.url = optURL
    }
}
