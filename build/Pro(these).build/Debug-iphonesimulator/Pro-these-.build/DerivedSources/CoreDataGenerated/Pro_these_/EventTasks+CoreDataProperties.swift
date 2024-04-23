//
//  EventTasks+CoreDataProperties.swift
//  
//
//  Created by Frederik Kohler on 26.10.23.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension EventTasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventTasks> {
        return NSFetchRequest<EventTasks>(entityName: "EventTasks")
    }

    @NSManaged public var date: Date?
    @NSManaged public var id: UUID?
    @NSManaged public var isDone: Bool
    @NSManaged public var text: String?
    @NSManaged public var events: NSSet?

}

// MARK: Generated accessors for events
extension EventTasks {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: Event)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: Event)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}

extension EventTasks : Identifiable {

}
