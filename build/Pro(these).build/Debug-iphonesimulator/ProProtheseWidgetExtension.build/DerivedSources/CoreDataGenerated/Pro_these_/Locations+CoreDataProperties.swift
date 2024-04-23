//
//  Locations+CoreDataProperties.swift
//  
//
//  Created by Frederik Kohler on 26.10.23.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Locations {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Locations> {
        return NSFetchRequest<Locations>(entityName: "Locations")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var speed: Double
    @NSManaged public var timestamp: Date?
    @NSManaged public var trackID: String?

}

extension Locations : Identifiable {

}
