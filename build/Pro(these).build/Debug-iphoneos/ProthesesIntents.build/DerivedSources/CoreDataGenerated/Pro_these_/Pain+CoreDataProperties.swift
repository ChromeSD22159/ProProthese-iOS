//
//  Pain+CoreDataProperties.swift
//  
//
//  Created by Frederik Kohler on 25.10.23.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension Pain {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pain> {
        return NSFetchRequest<Pain>(entityName: "Pain")
    }

    @NSManaged public var condition: String?
    @NSManaged public var conditionIcon: String?
    @NSManaged public var date: Date?
    @NSManaged public var painIndex: Int16
    @NSManaged public var pressureMb: Double
    @NSManaged public var stepCount: Double
    @NSManaged public var tempC: Double
    @NSManaged public var tempF: Double
    @NSManaged public var wearingAllProtheses: Int16
    @NSManaged public var painDrugs: PainDrug?
    @NSManaged public var painReasons: PainReason?
    @NSManaged public var prothese: Prothese?

}

extension Pain : Identifiable {

}
