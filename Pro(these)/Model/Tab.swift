//
//  Tab.swift
//  Pro Prothese
//
//  Created by Frederik Kohler on 23.04.23.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case home = "Home"
    case step = "Profile"
    case timer = "Stoppuhr"
    case more = "Mehr"
    
    func TabIcon() -> String {
        switch self {
            case .home: return "house.fill"
            case .step: return "prothesis"
            case .timer: return "timer"
            case .more: return "ellipsis.circle"
        }
    }
    
    func TabTitle() -> String {
        switch self {
            case .home: return "Home"
            case .step: return "Schritte"
            case .timer: return "Profil"
            case .more: return "Mehr"
        }
    }
}

class TabManager: ObservableObject {
    @Published var currentTab: Tab = .timer
}
