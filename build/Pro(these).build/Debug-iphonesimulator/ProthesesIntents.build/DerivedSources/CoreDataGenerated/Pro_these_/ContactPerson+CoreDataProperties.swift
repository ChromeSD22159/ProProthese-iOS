//
//  ContactPerson+CoreDataProperties.swift
//  
//
//  Created by Frederik Kohler on 26.10.23.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension ContactPerson {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ContactPerson> {
        return NSFetchRequest<ContactPerson>(entityName: "ContactPerson")
    }

    @NSManaged public var firstname: String?
    @NSManaged public var lastname: String?
    @NSManaged public var mail: String?
    @NSManaged public var mobil: String?
    @NSManaged public var phone: String?
    @NSManaged public var title: String?
    @NSManaged public var contact: Contact?
    @NSManaged public var event: NSSet?

}

// MARK: Generated accessors for event
extension ContactPerson {

    @objc(addEventObject:)
    @NSManaged public func addToEvent(_ value: Event)

    @objc(removeEventObject:)
    @NSManaged public func removeFromEvent(_ value: Event)

    @objc(addEvent:)
    @NSManaged public func addToEvent(_ values: NSSet)

    @objc(removeEvent:)
    @NSManaged public func removeFromEvent(_ values: NSSet)

}

extension ContactPerson : Identifiable {

}
