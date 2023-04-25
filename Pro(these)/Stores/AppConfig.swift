//
//  AppConfig.swift
//  Pro Prothese
//
//  Created by Frederik Kohler on 23.04.23.
//

import SwiftUI
import Combine
import Foundation

class AppConfig: ObservableObject {
    let minVersion: String = "0.0.1"
    
    
    var background          = Color(red: 32/255, green: 40/255, blue: 63/255)
    var foreground          = Color(red: 167/255, green: 178/255, blue: 210/255)
    var backgroundLabel     = LinearGradient(colors: [Color(red: 32/255, green: 40/255, blue: 63/255)], startPoint: .top, endPoint: .bottom)
    var backgroundGradient  = LinearGradient(colors: [Color(red: 32/255, green: 40/255, blue: 63/255), Color(red: 4/255, green: 5/255, blue: 8/255)], startPoint: .top, endPoint: .bottom)
    
    
    
    // MARK: SETTINGS StepsCount
    var ChartBarIsShowing                       = false     // BarMarks - Shows a green bar when your daily target has been reached
    var ChartLineDistanceIsShowing              = false     // LineMark - Show a red line Marker Stroke, with the daily distance
    var ChartLineStepsIsShowing                 = true      //  LineMark - Show a white/blue line Marker Stroke, with the daily steps
    
    // Notification
    var PushNotificationDailyMoodRemembering    = true     // Send Mood Reminder Notification
    var PushNotificationDisable                 = false     // Send no Notification
    var PushNotificationGoodMorning             = true      // Send GoodMorning Notification
    
    // Live Notification
    var showLiveActivity                        = true
}

