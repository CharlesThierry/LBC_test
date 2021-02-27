//
//  ImagesDescription.swift
//  Test LBC
//
//  Created by Charles Thierry on 26/02/2021.
//

import Foundation

protocol ImagesProtocol {
    var title: ClassifiedImagesTitle? { get }
    var url: String? { get }
}

class ImagesDescription: ImagesProtocol {
    internal var title: ClassifiedImagesTitle?
    internal var url: String?

    init(title: ClassifiedImagesTitle?,
         url: String?)
    {
        guard let optURL = url else {
            fatalError("URL is empty")
        }
        self.title = title
        self.url = optURL
    }
}
