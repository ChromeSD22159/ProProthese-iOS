//
//  LocationTracker.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 26.04.23.
//

import Foundation
import SwiftUI
import MapKit

struct LocationTracker: View {
    @EnvironmentObject var tabManager: TabManager
    
    @StateObject var localManager = LocationManager()

    @State private var coords: [CLLocationCoordinate2D] = []
    
    @State var sheet:Bool = false
    @State var presentationDetent: PresentationDetent = .medium
    
    @State var timerRecord = false
    @AppStorage("username") var username: String = "Anonymous"
    
    @AppStorage("locationLatitude") var locationLatitude: Double = 47.62356637298501
    @AppStorage("locationLongitude") var locationLongitude: Double = 8.220596441079877
    
    var favCoordinatesArray: [CLLocationCoordinate2D]  = [
        CLLocationCoordinate2D(latitude:47.62356637298501, longitude: 8.220596441079877),
        CLLocationCoordinate2D(latitude:47.62364184109103, longitude: 8.220103769607382),
        CLLocationCoordinate2D(latitude:47.62451726315878, longitude: 8.219737998362653)
    ]
    // https://www.andyibanez.com/posts/using-corelocation-with-swiftui/
    var body: some View {
        ZStack() {
            
            if timerRecord {
                Karte(region: localManager.locationRegion!, lineCoordinates: localManager.coordsArray)
                
            } else {
                Karte(region: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:  locationLatitude, longitude: locationLongitude), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)), lineCoordinates: favCoordinatesArray)
            }
            
            

            HStack(){
                Spacer()
                
                VStack{
                    Button(action: {
                        sheet.toggle()
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
                        print(timerRecord)
                        withAnimation(.easeInOut) {
                            timerRecord.toggle()
                        }
                        print(timerRecord)
                        tabManager.currentTab = .map
                        localManager.requestPermission()
                        localManager.authorizationStatus
                        if timerRecord == true {
                            localManager.coordsArray.removeAll(keepingCapacity: true)
                        }
                    }, label: {
                        ZStack {
                            Circle()
                                .fill(AppConfig().background.opacity(0.8))
                                .frame(width: 60)
                                .shadow(color: .white.opacity(0.5), radius: 40, x: 0, y: 0)
                                .shadow(color: .white.opacity(0.2), radius: 20, x: 0, y: 0)
                                .shadow(color: .white.opacity(0.1), radius: 10, x: 0, y: 0)
                            
                            Image(systemName: "record.circle")
                                .font(.largeTitle)
                                .foregroundColor(.white)
                                
                        }
                    })
                    .padding([.bottom, .trailing], 20)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
 
            }
            .fullSizeTop()
        }
        
    @ViewBuilder
    func Karte(region: MKCoordinateRegion, lineCoordinates: [CLLocationCoordinate2D]) -> some View {
        MapViewer(region: region, lineCoordinates: lineCoordinates)
            .ignoresSafeArea()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .sheet(isPresented: $sheet, content: {
                List {
                    ScrollView {
                        ForEach(lineCoordinates, id: \.latitude) { coords in
                            HStack {
                                Text("LanG: \(coords.latitude)")
                                Spacer()
                                Text("LanG: \(coords.longitude)")
                            }
                        }
                    }
                }
                .presentationDetents([.medium], selection: $presentationDetent)
                .presentationDragIndicator(.visible)
            })
    }
}

struct MapViewer: UIViewRepresentable {
    
    let region: MKCoordinateRegion
    let lineCoordinates: [CLLocationCoordinate2D]
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.region = region
        mapView.showsUserLocation = true
        
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
