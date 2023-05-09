//
//  RecordTimerActivityWidget.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 09.05.23.
//

import Foundation
import ActivityKit

struct RecordTimerAttributes: ActivityAttributes {
    public typealias RecordTimerState = ContentState

    public struct ContentState: Codable, Hashable {
        var isRunning: Bool
        var timeStamp: Date
        var state: String
        var endTime: String
    }

    var lastRecord: String
}
