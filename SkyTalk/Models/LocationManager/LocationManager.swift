//
//  LocationManager.swift
//  SkyTalk
//
//  Created by Youssef Eldeeb on 05/10/2022.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate{
    
    static let shared = LocationManager()
    
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D?
    
    private override init() {
        super.init()
        self.requestLocationAccess()
    }
    
    func requestLocationAccess(){
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.requestWhenInUseAuthorization()
        }else{
            print("We have already location manager")
        }
    }
    
    func startUpdatingLocation(){
        locationManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation(){
        if locationManager != nil{
            locationManager?.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last?.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("falid to get Lcoation \n ", error.localizedDescription)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .notDetermined{
            self.locationManager?.requestWhenInUseAuthorization()
        }
    }
    
}
