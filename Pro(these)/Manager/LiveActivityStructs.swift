//
//  LiveActivityStructs.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 27.04.23.
//

import SwiftUI
import ActivityKit


// Old
struct Prothesen_widgetAttributes: ActivityAttributes {
    public typealias ProthesenTimerStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var isRunning: Bool
        var timeStamp: Date
        var state: String
        var endTime: String
    }
}
// new
struct TimeTrackingAttributes: ActivityAttributes {
    public typealias TimeTrackingStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        var isRunning: Bool
        var timeStamp: Date
        var state: String
        var endTime: String
    }
}
