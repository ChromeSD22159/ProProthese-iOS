//
//  Tab.swift
//  Pro Prothese
//
//  Created by Frederik Kohler on 23.04.23.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case home = "Home"
    case timer = "Stoppuhr"
    case profil = "Profile"
    case more = "Mehr"
    
    func TabIcon() -> String {
        switch self {
            case .home: return "house.fill"
            case .timer: return "prothesis"
            case .profil: return "slider.horizontal.3"
            case .more: return "ellipsis.circle"
        }
    }
    
    func TabTitle() -> String {
        switch self {
            case .home: return "Home"
            case .timer: return "Schritte"
            case .profil: return "Profil"
            case .more: return "Mehr"
        }
    }
}

class TabManager: ObservableObject {
    @Published var currentTab: Tab = .home
}
