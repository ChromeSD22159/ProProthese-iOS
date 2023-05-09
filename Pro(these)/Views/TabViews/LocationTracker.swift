//
//  LocationTracker.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 26.04.23.
//

import Foundation
import SwiftUI
import MapKit
import Charts

struct LocationTracker: View {
    @EnvironmentObject var tabManager: TabManager
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject var lvm = LVM()
    
    @StateObject var localManager = LocationManager()

    @State private var coords: [CLLocationCoordinate2D] = []
    
    @State var sheet:Bool = false
    @State var presentationDetent: PresentationDetent = .medium
    
    @AppStorage("username") var username: String = "Anonymous"
    
    @AppStorage("locationLatitude") var locationLatitude: Double = 47.62356637298501
    @AppStorage("locationLongitude") var locationLongitude: Double = 8.220596441079877
    
    @State var selectedDetent: PresentationDetent = .large
    @State var isTracksSheet = false
    

    
    var favCoordinatesArray: [CLLocationCoordinate2D]  = [
//        CLLocationCoordinate2D(latitude:47.62356637298501, longitude: 8.220596441079877),
//        CLLocationCoordinate2D(latitude:47.62364184109103, longitude: 8.220103769607382),
//        CLLocationCoordinate2D(latitude:47.62451726315878, longitude: 8.219737998362653)
    ]
    
    var body: some View {
        ZStack() {

            Karte(region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:  locationLatitude, longitude: locationLongitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), lineCoordinates: favCoordinatesArray, showCurrentLocation: true)
            

            HStack(){
                Spacer()
                
                VStack{
                    Button(action: {
                        isTracksSheet.toggle()
                    }, label: {
                        ZStack {
                            Circle()
                                .fill(AppConfig().background.opacity(0.8))
                                .frame(width: 60)
                                .shadow(color: .white.opacity(0.5), radius: 40, x: 0, y: 0)
                                .shadow(color: .white.opacity(0.2), radius: 20, x: 0, y: 0)
                                .shadow(color: .white.opacity(0.1), radius: 10, x: 0, y: 0)
                            
                            Image(systemName: "list.star")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                            
                        }
                    })
                    .padding([.bottom, .trailing], 20)
                    
                    Button(action: {
                        withAnimation(.easeInOut) {
                            localManager.timerRecord.toggle()
                        }
                        
                        localManager.requestPermission()
                        
                        if localManager.startTime == nil {
                            localManager.registerBackgroundTask()
                            localManager.startRecording()
                        } else {
                            localManager.endBackgroundTaskIfActive()
                            localManager.stopRecording()
                        }
                    }, label: {
                        ZStack {
                            Circle()
                                .fill(AppConfig().background.opacity(0.8))
                                .frame(width: 60)
                                .shadow(color: .white.opacity(0.5), radius: 40, x: 0, y: 0)
                                .shadow(color: .white.opacity(0.2), radius: 20, x: 0, y: 0)
                                .shadow(color: .white.opacity(0.1), radius: 10, x: 0, y: 0)
                                
                            if localManager.startTime == nil {
                                Image(systemName: "record.circle")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                            } else {
                                Image(systemName: "stop")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                            }
                                
                        }
                    })
                    .padding([.bottom, .trailing], 20)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
 
            }
        .sheet(isPresented: $isTracksSheet) {
            ListTracks()
                .presentationDetents([.large], selection: $selectedDetent)
                .presentationDragIndicator(.visible)
        }

        .fullSizeTop()
        .onChange(of: scenePhase, perform: { scenePhase in
            switch scenePhase {
                case .background:
                let isTimerRunning = localManager.timerRecord != false
                  let isTaskUnregistered = localManager.backgroundTask == .invalid

                  if isTimerRunning && isTaskUnregistered {
                      localManager.registerBackgroundTask()
                  }
                case .active:
                localManager.endBackgroundTaskIfActive()
            case .inactive: print("")
            @unknown default:
                print("")
            }
        })
        .onAppear{
            lvm.fetchLocationData()
        }
    }
        
    
    @ViewBuilder
    func ListTracks() -> some View {
        List {
        
            ForEach(lvm.LocationArray, id: \.self) { track in
                HStack {
                    Text(track.trackID!)
                        .font(.caption2)
                    
                    Text("\(track.latitude)")
                        .font(.caption2)
                    
                    Text("\(track.longitude)")
                        .font(.caption2)
                    
                    Text("\(lvm.speed(track.speed, to: .kmh), specifier: "%.2f")")
                        .font(.caption2)
                    Text(track.timestamp!, style: .date)
                        .font(.caption2)
                         
                    Text(track.timestamp!, style: .time)
                        .font(.caption2)
                    
                    Spacer()
                    
                    Image(systemName: "trash")
                        .font(.caption2)
                        .foregroundColor(.white)
                        .onTapGesture {
                            lvm.deleteByID(track.trackID!)
                        }
                    
                }
                .onTapGesture {
                    isTracksSheet = true
                }
                .listRowBackground(Color.white.opacity(0.05))
            }
            .onDelete(perform: lvm.deleteItems)
            
        }
        .refreshable {
            do {
                lvm.refetchLocationData()
            }
        }
        .background{
            AppConfig().backgroundGradient
        }
        .ignoresSafeArea()
        .scrollContentBackground(.hidden)
        .foregroundColor(.white)
    }

    @ViewBuilder
    func Karte(region: MKCoordinateRegion, lineCoordinates: [CLLocationCoordinate2D], showCurrentLocation:Bool) -> some View {
        MapViewer(region: region, lineCoordinates: lineCoordinates, showCurrentLocation: showCurrentLocation)
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct MapViewer: UIViewRepresentable {
    
    let region: MKCoordinateRegion
    let lineCoordinates: [CLLocationCoordinate2D]
    let showCurrentLocation: Bool
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.region = region
        mapView.showsUserLocation = showCurrentLocation
        
        let polyline = MKPolyline(coordinates: lineCoordinates, count: lineCoordinates.count)
        mapView.addOverlay(polyline)
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
}

class Coordinator: NSObject, MKMapViewDelegate {
    var parent: MapViewer
    
    init(_ parent: MapViewer) {
        self.parent = parent
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let routePolyline = overlay as? MKPolyline {
            let renderer = MKPolylineRenderer(polyline: routePolyline)
            renderer.strokeColor = UIColor.white
            renderer.lineWidth = 10
            return renderer
        }
        return MKOverlayRenderer()
    }

}

