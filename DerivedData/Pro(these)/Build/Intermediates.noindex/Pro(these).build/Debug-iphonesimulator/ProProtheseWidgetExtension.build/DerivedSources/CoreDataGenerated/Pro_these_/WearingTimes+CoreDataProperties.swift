//
//  WearingTimes+CoreDataProperties.swift
//  
//
//  Created by Frederik Kohler on 29.08.23.
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
    @NSManaged public var timestamp: Date?

}

extension WearingTimes : Identifiable {

}
