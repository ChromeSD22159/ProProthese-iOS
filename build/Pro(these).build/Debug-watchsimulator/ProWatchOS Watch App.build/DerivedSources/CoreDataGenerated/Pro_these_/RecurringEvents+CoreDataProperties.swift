//
//  RecurringEvents+CoreDataProperties.swift
//  
//
//  Created by Frederik Kohler on 26.10.23.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension RecurringEvents {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RecurringEvents> {
        return NSFetchRequest<RecurringEvents>(entityName: "RecurringEvents")
    }

    @NSManaged public var date: Date?
    @NSManaged public var identifier: String?
    @NSManaged public var name: String?
    @NSManaged public var rhymus: Double
    @NSManaged public var contact: Contact?

}

extension RecurringEvents : Identifiable {

}
