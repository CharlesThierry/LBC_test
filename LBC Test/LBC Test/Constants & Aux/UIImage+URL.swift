//
//  UIImage+URL.swift
//  Test LBC
//
//  Created by Charles Thierry on 07/03/2021.
//

import UIKit

extension UIImageView {
    func setURLImage(str: String) {
        let url = URL(string: str)
        if url == nil { return }

        httpFetch(url: url!) { fetchResult in
            switch fetchResult {
            case let .failure(error):
                print("Could not fetch the related image \(error)")
            case let .success(data):
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }
    }
}
