//
//  ActivityState.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 08.06.23.
//

import Foundation
import ActivityKit


struct LiveStopWatchAttributes: ActivityAttributes {
    public typealias LiveStopWatchStatus = ContentState

    // Dynamic States
    public struct ContentState: Codable, Hashable {
        var driverName: String
        var deliveryTimer: ClosedRange<Date>
    }

    // Static States
}
