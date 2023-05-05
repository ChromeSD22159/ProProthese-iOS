//
//  LocationManager.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 26.04.23.
//  https://www.kodeco.com/34269507-background-modes-tutorial-getting-started


import CoreLocation
import CoreLocationUI
import MapKit
import BackgroundTasks

class LocationManager : NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var authorizationStatus: CLAuthorizationStatus
    @Published var timerRecord = false
    @Published var location:CLLocationCoordinate2D? = nil
    
    @Published var locationRegion:MKCoordinateRegion? = nil 
    
    @Published var coordsArray: [CLLocationCoordinate2D] = []
    
    @Published var TrackingID: String?
    @Published var isRunning = false
    @Published var startTime:Date?
    
    private let locationManager: CLLocationManager
    
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    
    override init() {
        locationManager = CLLocationManager()
        authorizationStatus = locationManager.authorizationStatus
        locationManager.requestAlwaysAuthorization()
        
        
        
        super.init()
        fetchStartTime()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
    
    func fetchStartTime(){
        let savedGpsTrackingTime = UserDefaults.standard.object(forKey: "StartGpsTracking") as? Date
        let savedGpsTrackingID = UserDefaults.standard.object(forKey: "TrackingID") as? String
        if savedGpsTrackingTime != nil {
            isRunning = true
            startTime = savedGpsTrackingTime
            TrackingID = savedGpsTrackingID
        }
    }
    
    func startRecording(){
        print("Start Rec")
        //locationManager.distanceFilter = 1
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.startMonitoringSignificantLocationChanges()
        locationManager.pausesLocationUpdatesAutomatically = true

        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.startUpdatingLocation()
        
        TrackingID = String("\(Int.random(in: 1111..<9999))ID")
        startTime = Date.now
        isRunning = true
        UserDefaults.standard.set(startTime, forKey: "StartGpsTracking")
        UserDefaults.standard.set(TrackingID, forKey: "TrackingID")
    }
    
    func stopRecording(){
        print("Stop Rec")
        locationManager.allowsBackgroundLocationUpdates = false
        locationManager.pausesLocationUpdatesAutomatically = true

        locationManager.stopUpdatingLocation()
        locationManager.showsBackgroundLocationIndicator = false
        locationManager.stopMonitoringSignificantLocationChanges()
        isRunning = false
        startTime = nil
        TrackingID = nil
        UserDefaults.standard.set(nil, forKey: "StartGpsTracking")
        UserDefaults.standard.set(nil, forKey: "TrackingID")
    }
    
    func locationsManager(_ manager: CLLocationManager) -> CLLocationCoordinate2D {
            let latitude = manager.location!.coordinate.latitude
            let longitude = manager.location!.coordinate.longitude
            
            locationRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:  latitude, longitude: longitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            
            location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            //print(manager.location!.coordinate)
            coordsArray.append(manager.location!.coordinate)
            //print(coordsArray.count)
            return manager.location!.coordinate
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        let latitude = manager.location!.coordinate.latitude
        let longitude = manager.location!.coordinate.longitude
        
        
            location = locations.first?.coordinate
            locationRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:  (locations.first?.coordinate.latitude)!, longitude: (locations.first?.coordinate.longitude)!), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            coordsArray.append(manager.location!.coordinate)
        print(manager)
        
        if (startTime != nil) {
            addCood(latitude: latitude, longitude: longitude, time: manager.location!.timestamp, speed: (manager.location!.speed) )
        } else {
        }
    }
    
    func exportCoordinate() -> CLLocationCoordinate2D {
        return location!
    }
    
    func addCood(latitude: Double, longitude: Double, time: Date, speed: Double){
        let newLocations = Locations(context: PersistenceController.shared.container.viewContext)
        newLocations.trackID = TrackingID
        newLocations.timestamp = time
        newLocations.longitude = latitude
        newLocations.latitude = longitude
        newLocations.speed = speed
        do {
            try PersistenceController.shared.container.viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}


