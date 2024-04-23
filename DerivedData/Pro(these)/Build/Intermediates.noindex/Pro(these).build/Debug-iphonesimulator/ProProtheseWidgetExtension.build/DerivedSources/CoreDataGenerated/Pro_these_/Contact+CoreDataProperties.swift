//
//  Contact+CoreDataProperties.swift
//  
//
//  Created by Frederik Kohler on 29.08.23.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Contact {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Contact> {
        return NSFetchRequest<Contact>(entityName: "Contact")
    }

    @NSManaged public var icon: String?
    @NSManaged public var mail: String?
    @NSManaged public var name: String?
    @NSManaged public var phone: String?
    @NSManaged public var titel: String?
    @NSManaged public var contactPersons: NSSet?
    @NSManaged public var events: NSSet?
    @NSManaged public var recurringEvents: NSSet?

}

// MARK: Generated accessors for contactPersons
extension Contact {

    @objc(addContactPersonsObject:)
    @NSManaged public func addToContactPersons(_ value: ContactPerson)

    @objc(removeContactPersonsObject:)
    @NSManaged public func removeFromContactPersons(_ value: ContactPerson)

    @objc(addContactPersons:)
    @NSManaged public func addToContactPersons(_ values: NSSet)

    @objc(removeContactPersons:)
    @NSManaged public func removeFromContactPersons(_ values: NSSet)

}

// MARK: Generated accessors for events
extension Contact {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: Event)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: Event)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}

// MARK: Generated accessors for recurringEvents
extension Contact {

    @objc(addRecurringEventsObject:)
    @NSManaged public func addToRecurringEvents(_ value: RecurringEvents)

    @objc(removeRecurringEventsObject:)
    @NSManaged public func removeFromRecurringEvents(_ value: RecurringEvents)

    @objc(addRecurringEvents:)
    @NSManaged public func addToRecurringEvents(_ values: NSSet)

    @objc(removeRecurringEvents:)
    @NSManaged public func removeFromRecurringEvents(_ values: NSSet)

}

extension Contact : Identifiable {

}
