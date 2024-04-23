//
//  WearingTimes+CoreDataProperties.swift
//  
//
//  Created by Frederik Kohler on 26.10.23.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension WearingTimes {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WearingTimes> {
        return NSFetchRequest<WearingTimes>(entityName: "WearingTimes")
    }

    @NSManaged public var duration: Int32
    @NSManaged public var end: Date?
    @NSManaged public var start: Date?
    @NSManaged public var prothese: Prothese?

}

extension WearingTimes : Identifiable {

}
