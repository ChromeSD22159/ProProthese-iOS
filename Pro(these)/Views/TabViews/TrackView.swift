//
//  TrackView.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 01.05.23.
//

import SwiftUI
import Charts
import MapKit
import CoreData

struct TrackView: View {
    @StateObject var lvm = LVM()
    @State var isTrackSheet = false
    @State var selectedTrackLocations: [CLLocationCoordinate2D] = []
    
    @State var regio = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:  47.62356637298501, longitude: 8.220596441079877), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
   
    @FetchRequest(
        sortDescriptors: [
            SortDescriptor(\.id)
        ],
        predicate: NSPredicate(format: "trackID == %@", "7195ID"))
    var locations: FetchedResults<Locations>

    
    var body: some View {
        
        VStack{
            
            MapViewer(region: regio, lineCoordinates: selectedTrackLocations, showCurrentLocation: false)
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            
            List {
            
                ForEach(locations, id: \.id) { track in
                    HStack {
                        Text("\(track.latitude)")
                            .font(.caption2)
                        
                        Spacer()
                        
                        Image(systemName: "mappin.and.ellipse")
                            .font(.caption2)
                            .foregroundColor(.white)
                        
                    }
                    .onTapGesture {
                        //self.selectedTrackLocations = lvm.GroupedCoordinatesArray[index]
                    }
                    .listRowBackground(Color.white.opacity(0.05))
                }
                .onDelete(perform: lvm.deleteItems)
    
            }
            .background{
                AppConfig().backgroundGradient
            }
            .ignoresSafeArea()
            .scrollContentBackground(.hidden)
            .foregroundColor(.white)
        }
        .onAppear{
            lvm.fetchLocationData()
            DispatchQueue.main.asyncAfter(deadline: .now() , execute: {
                locations.forEach{ l in
                    selectedTrackLocations.append(CLLocationCoordinate2D(latitude: l.latitude, longitude: l.longitude))
                   
                }
            })
        }
/*
 .sheet(item: $selectedTrackLocations) { locations in
     ShowTrack(locations: locations)
         .frame(maxWidth: .infinity, maxHeight: 500)
         .presentationDetents([.large])
         .presentationDragIndicator(.visible)
 }
 */
       
    }
    @ViewBuilder
    func ShowTrack(locations: [Locations]) -> some View {
        Chart(){
            ForEach(locations, id: \.id) { l in
                LineMark(
                    x: .value("Shape Type", l.latitude),
                    y: .value("Total Count", l.longitude),
                    series: .value("pm25", "A")
                )
                .foregroundStyle(.red)
                LineMark(
                    x: .value("Shape Type", l.timestamp!),
                    y: .value("Total Count", l.speed),
                    series: .value("pm25", "B")
                )
                .foregroundStyle(.blue)
            }
        }
    }
    
}

struct TrackView_Previews: PreviewProvider {
    static var previews: some View {
        TrackView()
    }
}



