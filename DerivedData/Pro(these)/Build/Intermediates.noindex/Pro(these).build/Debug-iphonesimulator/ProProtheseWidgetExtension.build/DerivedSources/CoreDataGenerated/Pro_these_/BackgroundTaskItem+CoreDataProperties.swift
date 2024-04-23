//
//  BackgroundTaskItem+CoreDataProperties.swift
//  
//
//  Created by Frederik Kohler on 29.08.23.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension BackgroundTaskItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BackgroundTaskItem> {
        return NSFetchRequest<BackgroundTaskItem>(entityName: "BackgroundTaskItem")
    }

    @NSManaged public var action: String?
    @NSManaged public var data: String?
    @NSManaged public var date: Date?
    @NSManaged public var task: String?

}

extension BackgroundTaskItem : Identifiable {

}
