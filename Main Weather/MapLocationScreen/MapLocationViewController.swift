//
//  MapLocationViewController.swift
//  Main Weather
//
//  Created by Shemets on 31.05.22.
//

import UIKit
import MapKit
import CoreLocation

class MapLocationViewController: UIViewController {

    private var mapView = MKMapView()
    private var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        view.backgroundColor = .white
        setupMapView()
        setupLocationManager()
        
    }

    override func viewWillLayoutSubviews() {
        let mapViewWidth: CGFloat = view.bounds.width
        let mapViewheight: CGFloat = view.bounds.height
        mapView.frame = CGRect(x: view.bounds.midX - mapViewWidth / 2,
                               y: view.bounds.midY - mapViewheight / 2,
                               width: mapViewWidth,
                               height: mapViewheight)
    }
    
    private func setupMapView() {
        mapView.mapType = .hybrid
        view.addSubview(mapView)
    }
    
    private func setupLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.startUpdatingLocation()
            locationManager.requestLocation()
        }
    }
}
extension MapLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first!
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 4000, longitudinalMeters: 4000)
        mapView.setRegion(region, animated: true)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

}

