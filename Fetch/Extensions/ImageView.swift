//
//  ImageView.swift
//  Fetch
//
//  Created by Shane Brelesky on 7/31/24.
//

import Foundation
import UIKit

extension UIImageView {
    
    func setImage(from url: URL) throws {
        let cacheKey = url.absoluteString

        if let cachedImage = ImageCache.shared.image(forKey: cacheKey) {
            self.image = cachedImage
            return
        }

        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                if let image = UIImage(data: data) {
                    ImageCache.shared.setImage(image, forKey: cacheKey)
                                        
                    DispatchQueue.main.async {
                        self.image = image
                    }
                }
            } catch {
                throw error
            }
        }
    }
}
