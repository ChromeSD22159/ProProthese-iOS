//
//  SnapShot.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 05.10.23.
//

import SwiftUI

enum SnapShot {
    enum SnapshotBackground: LocalizedStringKey, CaseIterable, Hashable {
        case background = "Background"
        case content = "Content"
    }
    
    enum SnapshotViews: LocalizedStringKey, CaseIterable, Hashable {
        case stepsToday = "Steps"
        case stepsWeek = "Week Step"
        case dateToday = "Date"
        case stepDistance = "Distance"
        case logo = "Logo"
        case location = "Location"
        case waether = "Weather"
        case none = "Empty"
    }
    
    enum SnapshotEdge: LocalizedStringKey, CaseIterable {
        case topLeft = "Top-Left"
        case topRight = "Top-Right"
        case bottomLeft = "Bottom-Left"
        case bottomRight = "Bottom-Right"
    }
}
