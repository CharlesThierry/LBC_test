//
//  ImagesDescription.swift
//  Test LBC
//
//  Created by Charles Thierry on 26/02/2021.
//

import Foundation

protocol ImagesProtocol {
    var title: ClassifiedImagesTitle { get }
    var url: URL { get }
}

class ImagesDescription: ImagesProtocol {
    internal var title: ClassifiedImagesTitle
    internal var url: URL

    init(title: ClassifiedImagesTitle,
         url: URL)
    {
        self.title = title
        self.url = url
    }
}
