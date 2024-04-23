//
//  Prothese+CoreDataProperties.swift
//  
//
//  Created by Frederik Kohler on 29.08.23.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Prothese {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Prothese> {
        return NSFetchRequest<Prothese>(entityName: "Prothese")
    }

    @NSManaged public var kind: String?
    @NSManaged public var maintage: Date?
    @NSManaged public var maintageInterval: Int16
    @NSManaged public var name: String?
    @NSManaged public var protheseID: String?
    @NSManaged public var type: String?
    @NSManaged public var feelings: NSSet?
    @NSManaged public var liner: Liner?
    @NSManaged public var pains: NSSet?

}

// MARK: Generated accessors for feelings
extension Prothese {

    @objc(addFeelingsObject:)
    @NSManaged public func addToFeelings(_ value: Feeling)

    @objc(removeFeelingsObject:)
    @NSManaged public func removeFromFeelings(_ value: Feeling)

    @objc(addFeelings:)
    @NSManaged public func addToFeelings(_ values: NSSet)

    @objc(removeFeelings:)
    @NSManaged public func removeFromFeelings(_ values: NSSet)

}

// MARK: Generated accessors for pains
extension Prothese {

    @objc(addPainsObject:)
    @NSManaged public func addToPains(_ value: Pain)

    @objc(removePainsObject:)
    @NSManaged public func removeFromPains(_ value: Pain)

    @objc(addPains:)
    @NSManaged public func addToPains(_ values: NSSet)

    @objc(removePains:)
    @NSManaged public func removeFromPains(_ values: NSSet)

}

extension Prothese : Identifiable {

}
