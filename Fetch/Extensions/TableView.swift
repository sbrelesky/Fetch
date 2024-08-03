//
//  TableView.swift
//  Fetch
//
//  Created by Shane Brelesky on 8/1/24.
//

import Foundation
import UIKit

extension UITableView {
    
    func showLoadingIndicator() {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.startAnimating()
        backgroundView = spinner
    }
    
    func removeLoadingIndicator() {
        self.backgroundView = nil
    }
}
