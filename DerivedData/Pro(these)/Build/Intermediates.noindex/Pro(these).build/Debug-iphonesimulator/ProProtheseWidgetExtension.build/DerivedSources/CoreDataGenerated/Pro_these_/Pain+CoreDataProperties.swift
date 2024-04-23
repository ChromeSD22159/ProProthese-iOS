//
//  Pain+CoreDataProperties.swift
//  
//
//  Created by Frederik Kohler on 29.08.23.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Pain {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pain> {
        return NSFetchRequest<Pain>(entityName: "Pain")
    }

    @NSManaged public var date: Date?
    @NSManaged public var painIndex: Int16
    @NSManaged public var painDrugs: PainDrug?
    @NSManaged public var painReasons: PainReason?
    @NSManaged public var prothese: Prothese?

}

extension Pain : Identifiable {

}
