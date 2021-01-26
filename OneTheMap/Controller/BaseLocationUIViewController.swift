//
//  ViewController+Extension.swift
//  OneTheMap
//
//  Created by Lixiang Zhang on 1/23/21.
//

import Foundation
import UIKit

class BaseLocationUIViewController: UIViewController {
    
    var locations: [Location] = []
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func post(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addLocation", sender: nil)
    }
    
    func fetchLocations(completion: @escaping () -> Void) {
        NetworkClient.getLocations(number: 100) { (locations, error) in
            self.locations = locations
            completion()
        }
    }
}
