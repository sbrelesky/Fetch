//
//  UIViewController.swift
//  Fetch
//
//  Created by Shane Brelesky on 8/2/24.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showErrorAlert(_ error: Error? = nil, retryAction: (() -> Void)? = nil, cancelAction: (() -> Void)? = nil) {
       
        var errorMessage: String
        if let networkError = error as? NetworkError {
            errorMessage = networkError.description
        } else {
            errorMessage = error?.localizedDescription ?? NetworkError.generic.description
        }
        
        let alertController = UIAlertController(
            title: "Network Error",
            message: errorMessage,
            preferredStyle: .alert
        )
        
        let retryAction = UIAlertAction(title: "Retry", style: .default) { _ in
            retryAction?()
        }
        alertController.addAction(retryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            cancelAction?()
        }
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
}
