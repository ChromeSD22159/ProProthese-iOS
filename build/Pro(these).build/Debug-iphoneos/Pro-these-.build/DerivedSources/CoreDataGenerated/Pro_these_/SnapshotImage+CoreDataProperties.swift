//
//  SnapshotImage+CoreDataProperties.swift
//  
//
//  Created by Frederik Kohler on 25.10.23.
//
//  This file was automatically generated and should not be edited.
//

import Foundation
import CoreData


extension SnapshotImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SnapshotImage> {
        return NSFetchRequest<SnapshotImage>(entityName: "SnapshotImage")
    }

    @NSManaged public var createdDate: Date?
    @NSManaged public var fileName: String?

}

extension SnapshotImage : Identifiable {

}
