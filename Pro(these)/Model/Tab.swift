//
//  Tab.swift
//  Pro Prothese
//
//  Created by Frederik Kohler on 23.04.23.
//

import SwiftUI

enum Tab: String, Codable, CaseIterable, Identifiable {
    case step = "Schrittzähler"
    case event = "Eventplaner"
    case timer = "Stoppuhr"
   
   
    //case map = "Karte"
    //case more = "Mehr"
    
    var id: Self { self }
    
    func TabIcon() -> String {
        switch self {
            case .step: return "prothesis"
            case .event: return "calendar.circle"
            case .timer: return "stopwatch"
            //case .map: return "location.circle"
            //case .more: return "ellipsis.circle"
        }
    }
    
    func TabTitle() -> String {
        switch self {
            case .step: return "Schritte"
            case .event: return "Events"
            case .timer: return "Profil"
            //case .map: return "GPS Tracking"
            //case .more: return "Mehr"
        }
    }
}

extension URL {
    var isDeeplink: Bool {
        return scheme == "ProProthese" // match ProProthese://timer
    }
    
    var tabIdentifier: Tab? {
        guard isDeeplink else {
            return nil
        }
        
        switch host {
        case "step" : return .step
        case "timer" : return .timer
        case "event" : return .event
        default: return nil
        }
    }
 
    
    
}

