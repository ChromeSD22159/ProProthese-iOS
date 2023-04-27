//
//  Tab.swift
//  Pro Prothese
//
//  Created by Frederik Kohler on 23.04.23.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case step = "Profile"
    case timer = "Stoppuhr"
    case map = "Karte"
    case more = "Mehr"
    
    func TabIcon() -> String {
        switch self {
            case .step: return "prothesis"
            case .timer: return "stopwatch"
            case .map: return "location.circle"
            case .more: return "ellipsis.circle"
        }
    }
    
    func TabTitle() -> String {
        switch self {
            case .step: return "Schritte"
            case .timer: return "Profil"
            case .map: return "GPS Tracking"
            case .more: return "Mehr"
        }
    }
   
}


