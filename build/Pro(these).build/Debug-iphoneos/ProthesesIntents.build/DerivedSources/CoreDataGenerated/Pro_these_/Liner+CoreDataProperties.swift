//
//  Liner+CoreDataProperties.swift
//  
//
//  Created by Frederik Kohler on 25.10.23.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Liner {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Liner> {
        return NSFetchRequest<Liner>(entityName: "Liner")
    }

    @NSManaged public var brand: String?
    @NSManaged public var date: Date?
    @NSManaged public var interval: Int16
    @NSManaged public var linerID: String?
    @NSManaged public var model: String?
    @NSManaged public var name: String?
    @NSManaged public var prothese: NSSet?

}

// MARK: Generated accessors for prothese
extension Liner {

    @objc(addProtheseObject:)
    @NSManaged public func addToProthese(_ value: Prothese)

    @objc(removeProtheseObject:)
    @NSManaged public func removeFromProthese(_ value: Prothese)

    @objc(addProthese:)
    @NSManaged public func addToProthese(_ values: NSSet)

    @objc(removeProthese:)
    @NSManaged public func removeFromProthese(_ values: NSSet)

}

extension Liner : Identifiable {

}
