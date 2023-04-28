//
//  LocationManager.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 26.04.23.
//  https://www.kodeco.com/34269507-background-modes-tutorial-getting-started


import CoreLocation
import CoreLocationUI
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus
    
    @Published var location:CLLocationCoordinate2D? = nil
    
    @Published var locationRegion:MKCoordinateRegion? = nil 
    
    @Published var coordsArray: [CLLocationCoordinate2D] = []

    
    private let locationManager: CLLocationManager
    
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        locationManager.requestAlwaysAuthorization()
 
        
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        locationManager.requestAlwaysAuthorization()
        locationManager.allowsBackgroundLocationUpdates = true
        }
    
    func registerBackgroundTask() {
      backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
        print("iOS has signaled time has expired")
        self?.endBackgroundTaskIfActive()
      }
    }
    
    func endBackgroundTaskIfActive() {
      let isBackgroundTaskActive = backgroundTask != .invalid
      if isBackgroundTaskActive {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = .invalid
      }
    }
    
    func requestPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func locationsManager(_ manager: CLLocationManager) -> CLLocationCoordinate2D {
            let latitude = manager.location!.coordinate.latitude
            let longitude = manager.location!.coordinate.longitude
            
            locationRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:  latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        print(manager.location!.coordinate)
            coordsArray.append(manager.location!.coordinate)
            return manager.location!.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last {
             print("New location is \(location)")
         }
        
            location = locations.first?.coordinate
            locationRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:  (locations.first?.coordinate.latitude)!, longitude: (locations.first?.coordinate.longitude)!), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            coordsArray.append(location!)
    }
    
    func exportCoordinate() -> CLLocationCoordinate2D {
        return location!
    }
}
