//
//  LocationConfirmViewController.swift
//  OneTheMap
//
//  Created by Lixiang Zhang on 1/24/21.
//

import UIKit
import MapKit

class LocationConfirmViewController: UIViewController {
    
    var pin: Pin!
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        dropPinOnMap()
        centerMapOnLocation(coordinate: pin.coordinate)
    }
    
    @IBAction func confirm(_ sender: Any) {
        NetworkClient.postLocation(firstName: pin.user.firstName, lastName: pin.user.lastName, mapString: pin.address, mediaURL: pin.mediaURL, latitude: pin.coordinate.latitude, longitude: pin.coordinate.longitude) { (success, error) in
            if success {
                self.navigationController?.dismiss(animated: true)
            }
        }
    }
    
    private func dropPinOnMap() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = pin.coordinate
        annotation.title = pin.address
        mapView.addAnnotation(annotation)
    }
    
    private func centerMapOnLocation(coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        DispatchQueue.main.async {
            self.mapView.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            self.mapView.addAnnotation(annotation)
        }
    }
}

extension LocationConfirmViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if let annotationView = annotationView {
            annotationView.annotation = annotation
        } else {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView?.canShowCallout = true
            annotationView?.pinTintColor = .green
        }
        
        return annotationView
    }
}
