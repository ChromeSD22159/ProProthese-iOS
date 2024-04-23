//
//  UrlExtension.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 13.07.23.
//

import SwiftUI

extension URL {

    var isDeeplink: Bool {
        return scheme == "ProProthese" // match ProProthese://timer
    }
    
    var tabIdentifier: Tab? {
        guard isDeeplink else {
            return .home
        }
        
        switch host {
            case "showFeeling" : return .feeling
            case "addFeeling" : return .feeling
            case "addPain": return .pain
            case "stopWatchToggle": return .stopWatch
            case "statisticSteps": return .home
            case "statisticWorkout": return .home
            
            case "event" : return .event
            case "healthCenter" : return .home
            case "feeling" : return .home

            default: return nil
        }
    }
    
    var tabAction: String? {
        return host
    }
    
    /// Returns a URL for the given app group and database pointing to the sqlite database.
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
    
}
