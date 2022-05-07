//
//  MainVC.swift
//  MapKitExample
//
//  Created by Ahmet Mucahid Bozkurt on 4.05.2022.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MainVC: UIViewController {

    @IBOutlet private weak var txtViewLocationName: UITextField!
    @IBOutlet private weak var txtViewComment: UITextField!
    @IBOutlet private weak var mapView: MKMapView!
    private var locationManager = CLLocationManager()
    
    var selectedLatitude = Double()
    var selectedLongitude = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        // TODO: Get location when user tapped 3 seconds on map.
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(getTappedLocation(gestureRecognizer:)))
        gestureRecognizer.minimumPressDuration = 2
        mapView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func getTappedLocation(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            // TODO: Firstly, get point of touched. Later convert coordinate from mapView to point.
            let touchedPoint = gestureRecognizer.location(in: mapView)
            let touchedCoordinates = mapView.convert(touchedPoint, toCoordinateFrom: mapView)
            
            selectedLatitude = touchedCoordinates.latitude
            selectedLongitude = touchedCoordinates.longitude
            
            // TODO: Add pin on map.
            let annotation = MKPointAnnotation()
            annotation.coordinate = touchedCoordinates
            annotation.title = txtViewLocationName.text
            annotation.subtitle = txtViewComment.text
            mapView.addAnnotation(annotation)
            
        }
    }
    
    @IBAction func btnSaveClicked(_ sender: UIButton) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newLocation = NSEntityDescription.insertNewObject(forEntityName: "Locations", into: context)
        newLocation.setValue(UUID(), forKey: "id")
        newLocation.setValue(txtViewLocationName.text, forKey: "name")
        newLocation.setValue(txtViewComment.text, forKey: "comment")
        newLocation.setValue(selectedLatitude, forKey: "latitude")
        newLocation.setValue(selectedLongitude, forKey: "longitude")
        
        do {
            try context.save()
            print("Saved location.")
        } catch {
            print(error)
        }
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

