//
//  ViewController.swift
//  TaskCashRich
//
//  Created by xtensibleimac on 05/09/20.
//  Copyright © 2020 Shraddha. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblLatitude: UILabel!
    @IBOutlet weak var lblLongitude: UILabel!
    @IBOutlet weak var lblWeather: UILabel!
    
    private let locationManager = CLLocationManager()
    private var currentCoordinate: CLLocationCoordinate2D?
    var weatherManager = WeatherManager()
    var latestWeather = String()
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureLocationServices()
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.allowsBackgroundLocationUpdates = true
        weatherManager.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGesture.numberOfTapsRequired = 1
        mapView.addGestureRecognizer(tapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @objc func handleTap(gestureReconizer: UITapGestureRecognizer) {
        
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        let lat = coordinate.longitude
        let long = coordinate.latitude
        weatherManager.fetchWeather(latitude: lat, longitude: long)
        self.lblLongitude.text = "Longitude : \(coordinate.longitude)"
        self.lblLatitude.text = "Latitude : \(coordinate.latitude)"
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        if mapView.annotations.count == 1 {
            mapView.removeAnnotation(mapView.annotations.last!)
        }
        mapView.addAnnotation(annotation)
    }
    
    private func configureLocationServices() {
        locationManager.delegate = self
        let status = CLLocationManager.authorizationStatus()
        if status == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: locationManager)
        }
    }
    
    private func beginLocationUpdates(locationManager: CLLocationManager) {
        mapView.showsUserLocation = true
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }

}

extension ViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.async {
            self.lblWeather.text =  "Weather : \(weather.temperatureString)°C"
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.first else { return }
        if currentCoordinate == nil {
            let lat = latestLocation.coordinate.latitude
            let long = latestLocation.coordinate.longitude
            self.lblLatitude.text = "Latitude : \(lat)"
            self.lblLongitude.text = "Longitude : \(long)"
            weatherManager.fetchWeather(latitude: lat, longitude: long)
        }
        currentCoordinate = latestLocation.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            beginLocationUpdates(locationManager: manager)
        }
    }
}
