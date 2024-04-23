//
//  ContactPerson+CoreDataProperties.swift
//  
//
//  Created by Frederik Kohler on 29.08.23.
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

}

extension ContactPerson : Identifiable {

}
