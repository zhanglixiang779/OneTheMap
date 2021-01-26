//
//  LocationPostingViewController.swift
//  OneTheMap
//
//  Created by Lixiang Zhang on 1/24/21.
//

import UIKit
import MapKit

class LocationPostingViewController: UIViewController {

    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var mediaURL: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func cancelTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func findLocation(_ sender: Any) {
        
        guard let location = location.text, !location.isEmpty else {
            showAlert(title: "Failed", message: "Please enter a valid location")
            return
        }
        
        guard let url = mediaURL.text, !url.isEmpty else {
            showAlert(title: "Failed", message: "Please enter a media url")
            return
        }
        
        NetworkClient.getUserInfo(completion: handleUserInfo(user:error:))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let pin = sender as? Pin, let destination = segue.destination as? LocationConfirmViewController {
            destination.pin = pin
        }
    }
    
    private func handleUserInfo(user: User?, error: Error?) {
        guard let user = user else {
            showAlert(title: "Failed!", message: error?.localizedDescription ?? "")
            return
        }
        
        getCoordinate(addressString: location.text!) { (coordinate, error) in
            guard error == nil else {
                self.showAlert(title: "Failed", message: "Please provide a valid address")
                return
            }
            
            NetworkClient.postLocation(firstName: user.firstName, lastName: user.lastName, mapString: self.location.text!, mediaURL: self.mediaURL.text!, latitude: coordinate.latitude, longitude: coordinate.longitude) { (success, error) in
                let pin = Pin(coordinate: coordinate, address: self.location.text!)
                if success {
                    self.performSegue(withIdentifier: "toLocationConfirmPage", sender: pin)
                }
            }
        }
    }
}

extension LocationPostingViewController {
    
    // MARK: Getting a coordinate from an address string
    
    func getCoordinate(addressString : String, completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                        
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
                
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
}
