//
//  Theme.swift
//  Fetch
//
//  Created by Shane Brelesky on 8/1/24.
//

import UIKit

struct Theme {

    struct Colors {
        static let purple = UIColor(named: "fetchPurple")
        static let orange = UIColor(named: "fetchOrange")
        static let text =  UIColor(red: 41.0 / 255.0, green: 41.0 / 255.0, blue: 41.0 / 255.0, alpha: 1.0)
    }
    
    struct Fonts {
        static func main(size: CGFloat, weight: Weight) -> UIFont {
            return UIFont(name: "Avenir-\(weight.rawValue)", size: size) ?? .systemFont(ofSize: size)
        }
    }
    
    enum Weight: String {
        case book = "Book"
        case medium = "Medium"
        case heavy = "Heavy"
        case black = "Black"
    }
}
