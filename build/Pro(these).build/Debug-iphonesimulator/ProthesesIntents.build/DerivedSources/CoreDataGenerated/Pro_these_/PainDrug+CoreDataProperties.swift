//
//  PainDrug+CoreDataProperties.swift
//  
//
//  Created by Frederik Kohler on 26.10.23.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension PainDrug {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PainDrug> {
        return NSFetchRequest<PainDrug>(entityName: "PainDrug")
    }

    @NSManaged public var date: Date?
    @NSManaged public var name: String?
    @NSManaged public var pain: NSSet?

}

// MARK: Generated accessors for pain
extension PainDrug {

    @objc(addPainObject:)
    @NSManaged public func addToPain(_ value: Pain)

    @objc(removePainObject:)
    @NSManaged public func removeFromPain(_ value: Pain)

    @objc(addPain:)
    @NSManaged public func addToPain(_ values: NSSet)

    @objc(removePain:)
    @NSManaged public func removeFromPain(_ values: NSSet)

}

extension PainDrug : Identifiable {

}
