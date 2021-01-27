//
//  LocationMapViewController.swift
//  OneTheMap
//
//  Created by Lixiang Zhang on 1/24/21.
//

import UIKit
import MapKit

class LocationMapViewController: BaseLocationUIViewController {
    
    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        indicator.startAnimating()
        fetchLocations {
            self.constructAnnotationViews()
            self.indicator.stopAnimating()
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        indicator.startAnimating()
        fetchLocations {
            self.constructAnnotationViews()
            self.indicator.stopAnimating()
        }
    }
    
    private func constructAnnotationViews() {
        var annotations: [MKAnnotation] = []
        locations.forEach { location in
            let lat = CLLocationDegrees(location.latitude)
            let long = CLLocationDegrees(location.longitude)
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            let firstName = location.firstName
            let lastName = location.lastName
            let mediaURL = location.mediaURL
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(firstName) \(lastName)"
            annotation.subtitle = mediaURL
            annotations.append(annotation)
        }
        
        mapView.addAnnotations(annotations)
    }
}

extension LocationMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if let annotationView = annotationView {
            annotationView.annotation = annotation
        } else {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            annotationView?.canShowCallout = true
            annotationView?.pinTintColor = .green
            annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            guard let subtitle = view.annotation?.subtitle else {
                return
            }

            guard let mediaURL = URL(string: subtitle!) else {
                return
            }

            UIApplication.shared.open(mediaURL, options: [:], completionHandler: nil)
        }
    }
}
