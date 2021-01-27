//
//  ViewController+Extension.swift
//  OneTheMap
//
//  Created by Lixiang Zhang on 1/24/21.
//

import Foundation
import UIKit

extension UIViewController {
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
}
