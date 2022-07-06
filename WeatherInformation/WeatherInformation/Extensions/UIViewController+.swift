//
//  UIViewController+.swift
//  WeatherInformation
//
//  Created by Eunsoo KIM on 2022/07/06.
//

import UIKit

extension UIViewController {
    func presentNetworkError(with error: NetworkManagerError?) {
        var errorMessage = ""
        guard let _error = error else {
            return
        }
        switch _error {
            case .networkError:
                errorMessage = "network Error!"
            case .responseError:
                errorMessage = "response Error!"
            case .dataError:
                errorMessage = "wrong data Error!"
            case .parseError:
                errorMessage = "parasing data Error"
        }
        let alert = UIAlertController(title: "warning", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true)
    }
}
