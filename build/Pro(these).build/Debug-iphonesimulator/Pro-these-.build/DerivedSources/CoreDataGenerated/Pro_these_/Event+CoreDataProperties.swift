//
//  Event+CoreDataProperties.swift
//  
//
//  Created by Frederik Kohler on 26.10.23.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var endDate: Date?
    @NSManaged public var eventID: String?
    @NSManaged public var icon: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var titel: String?
    @NSManaged public var contact: Contact?
    @NSManaged public var contactPerson: ContactPerson?
    @NSManaged public var tasks: NSSet?

}

// MARK: Generated accessors for tasks
extension Event {

    @objc(addTasksObject:)
    @NSManaged public func addToTasks(_ value: EventTasks)

    @objc(removeTasksObject:)
    @NSManaged public func removeFromTasks(_ value: EventTasks)

    @objc(addTasks:)
    @NSManaged public func addToTasks(_ values: NSSet)

    @objc(removeTasks:)
    @NSManaged public func removeFromTasks(_ values: NSSet)

}

extension Event : Identifiable {

}
