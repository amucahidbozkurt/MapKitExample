//
//  MainVC.swift
//  MapKitExample
//
//  Created by Ahmet Mucahid Bozkurt on 4.05.2022.
//

import UIKit
import MapKit
import CoreLocation

class MainVC: UIViewController {

    @IBOutlet private weak var mapView: MKMapView!
    private var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

}

extension MainVC: MKMapViewDelegate {
    
}

extension MainVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2D.init(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion.init(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
    }
}

