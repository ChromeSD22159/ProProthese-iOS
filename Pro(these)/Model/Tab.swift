//
//  Tab.swift
//  Pro Prothese
//
//  Created by Frederik Kohler on 23.04.23.
//

import SwiftUI

enum Tab: String, CaseIterable, Identifiable {
    case step = "Profile"
    case timer = "Stoppuhr"
    case map = "Karte"
    case event = "Event"
    //case more = "Mehr"
    
    var id: Self { self }
    
    func TabIcon() -> String {
        switch self {
            case .step: return "prothesis"
            case .timer: return "stopwatch"
            case .map: return "location.circle"
            case .event: return "calendar.circle"
            //case .more: return "ellipsis.circle"
        }
    }
    
    func TabTitle() -> String {
        switch self {
            case .step: return "Schritte"
            case .timer: return "Profil"
            case .map: return "GPS Tracking"
            case .event: return "Events"
            //case .more: return "Mehr"
        }
    }
   
}


