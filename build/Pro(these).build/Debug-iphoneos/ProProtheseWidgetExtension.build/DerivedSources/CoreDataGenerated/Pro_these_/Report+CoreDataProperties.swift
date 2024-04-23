//
//  Report+CoreDataProperties.swift
//  
//
//  Created by Frederik Kohler on 25.10.23.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Report {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Report> {
        return NSFetchRequest<Report>(entityName: "Report")
    }

    @NSManaged public var created: Date?
    @NSManaged public var endOfWeek: Date?
    @NSManaged public var startOfWeek: Date?

}

extension Report : Identifiable {

}
