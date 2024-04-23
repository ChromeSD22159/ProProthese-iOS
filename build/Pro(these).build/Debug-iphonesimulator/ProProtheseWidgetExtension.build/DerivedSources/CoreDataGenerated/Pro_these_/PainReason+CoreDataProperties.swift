//
//  PainReason+CoreDataProperties.swift
//  
//
//  Created by Frederik Kohler on 26.10.23.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension PainReason {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PainReason> {
        return NSFetchRequest<PainReason>(entityName: "PainReason")
    }

    @NSManaged public var date: Date?
    @NSManaged public var name: String?
    @NSManaged public var pains: NSSet?

}

// MARK: Generated accessors for pains
extension PainReason {

    @objc(addPainsObject:)
    @NSManaged public func addToPains(_ value: Pain)

    @objc(removePainsObject:)
    @NSManaged public func removeFromPains(_ value: Pain)

    @objc(addPains:)
    @NSManaged public func addToPains(_ values: NSSet)

    @objc(removePains:)
    @NSManaged public func removeFromPains(_ values: NSSet)

}

extension PainReason : Identifiable {

}
