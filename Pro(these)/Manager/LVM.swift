//
//  LVM.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 01.05.23.
//

import SwiftUI

import SwiftUI
import CoreData
import MapKit

class LVM : ObservableObject {

    @Published var LocationArray: [Locations] = []
    @Published var GroupedCoordinatesArray: [[CLLocationCoordinate2D]] = []
    @Published var GroupedLocationArray: [[Locations]] = []
    
    func speed(_ speed: Double, to: convertSpeed) -> Double {
        switch to {
            case .kmh : return Double(speed*3.704)
            case .mps : return speed * 0.06
        }
    }
    
    func fetchLocationData() {
        let requesttimestamps = NSFetchRequest<Locations>(entityName: "Locations")
        let sort = NSSortDescriptor(key: "timestamp", ascending: false)
        requesttimestamps.sortDescriptors = [sort]
        do {
            LocationArray = try PersistenceController.shared.container.viewContext.fetch(requesttimestamps)
            GroupedCoordinatesArray = groupCoordinates(LocationArray)
            GroupedLocationArray = groupLocations(LocationArray)
        }catch {
          print("DEBUG: Some error occured while fetching Times")
        }
    }
    
    func groupCoordinates(_ result : [Locations])-> [[CLLocationCoordinate2D]] {
        let dictionary = Dictionary(grouping: result, by: { $0.trackID })
        return dictionary.map { $0.value.map{ CLLocationCoordinate2D(latitude: $0.latitude , longitude: $0.longitude  ) }  }
    }
    
    func groupLocations(_ result : [Locations])-> [[Locations]] {
        return Dictionary(grouping: result) { $0.trackID!.sorted() }.sorted {$0.key.first! < $1.key.first!}.map {  $0.value }
    }
    
    func refetchLocationData() {
        let requesttimestamps = NSFetchRequest<Locations>(entityName: "Locations")
        let sort = NSSortDescriptor(key: "timestamp", ascending: false)
        requesttimestamps.sortDescriptors = [sort]
        LocationArray.removeAll(keepingCapacity: true)
        do {
            LocationArray = try PersistenceController.shared.container.viewContext.fetch(requesttimestamps)
            GroupedCoordinatesArray = groupCoordinates(LocationArray)
            GroupedLocationArray = groupLocations(LocationArray)
        }catch {
          print("DEBUG: Some error occured while fetching Times")
        }
    }

    func delete(offsets: Int) {
       withAnimation {
           LocationArray.map { _ in self.LocationArray[offsets] }.forEach(PersistenceController.shared.container.viewContext.delete)
           self.LocationArray.removeAll(keepingCapacity: true)
           do {
               try PersistenceController.shared.container.viewContext.save()
               refetchLocationData()
           } catch {
               // Replace this implementation with code to handle the error appropriately.
               // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
               let nsError = error as NSError
               fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
           }
       }
    }

    func deleteByID(_ trackID: String) {
        withAnimation {
            print(trackID)
            withAnimation {
                LocationArray.filter { $0.trackID == trackID }.forEach(PersistenceController.shared.container.viewContext.delete)
                self.LocationArray.removeAll(keepingCapacity: true)
                do {
                    try PersistenceController.shared.container.viewContext.save()
                    refetchLocationData()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
    }
    
    func deleteItems(offsets: IndexSet) {
       withAnimation {
           offsets.map { self.LocationArray[$0] }.forEach(PersistenceController.shared.container.viewContext.delete)
           self.LocationArray.removeAll(keepingCapacity: true)
           do {
               try PersistenceController.shared.container.viewContext.save()
               refetchLocationData()
           } catch {
               // Replace this implementation with code to handle the error appropriately.
               // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
               let nsError = error as NSError
               fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
           }
       }
    }

    func addTime(time: Date, duration: Int32) {
        let newTime = WearingTimes(context: PersistenceController.shared.container.viewContext)
        newTime.timestamp = time
        newTime.duration = duration
        do {
            try PersistenceController.shared.container.viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    func convertLocation(_ coords: [Locations]) -> [CLLocationCoordinate2D] {
        var convertedCoods: [CLLocationCoordinate2D] = []
        
        coords.forEach{ c in
            convertedCoods.append( CLLocationCoordinate2D(latitude: c.latitude, longitude: c.longitude) )
        }
        //print(coords)
        return convertedCoods
    }
}

enum convertSpeed {
    case kmh
    case mps
}

struct TrackData: Identifiable {
    var id: String
    var coods:[Locations]
}
