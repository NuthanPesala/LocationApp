//
//  ViewController.swift
//  SearchLocation
//
//  Created by Nuthan Raju Pesala on 06/05/21.
//

import UIKit
import FloatingPanel
import MapKit
import CoreLocation

class ViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var panel = FloatingPanelController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Uber"
        let searchVC = SearchViewController()
        searchVC.delegate = self
        panel.set(contentViewController: searchVC)
        panel.addPanel(toParent: self)
    }
}

extension ViewController: searchViewControllerDelegate  {
    
    func sendingCoordinates(coordinates: CLLocationCoordinate2D) {
        panel.move(to: .tip, animated: true)
        let center = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.7, longitudeDelta: 0.7)
        let region = MKCoordinateRegion(center: center, span: span)
        self.mapView.setRegion(region, animated: true)
        
        let pin = MKPointAnnotation()
        pin.coordinate = coordinates
        self.mapView.addAnnotation(pin)
    }
}
