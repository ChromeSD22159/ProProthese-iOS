//
//  Feeling+CoreDataProperties.swift
//  
//
//  Created by Frederik Kohler on 29.08.23.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Feeling {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Feeling> {
        return NSFetchRequest<Feeling>(entityName: "Feeling")
    }

    @NSManaged public var date: Date?
    @NSManaged public var name: String?
    @NSManaged public var prothese: Prothese?

}

extension Feeling : Identifiable {

}
