//
//  ImageCache.swift
//  Fetch
//
//  Created by Shane Brelesky on 8/2/24.
//

import Foundation
import UIKit

class ImageCache {
    
    static let shared = ImageCache()
    private init() {}

    private let cache = NSCache<NSString, UIImage>()

    func image(forKey key: String) -> UIImage? {
        return cache.object(forKey: NSString(string: key))
    }

    func setImage(_ image: UIImage, forKey key: String) {
        cache.setObject(image, forKey: NSString(string: key))
    }
}
