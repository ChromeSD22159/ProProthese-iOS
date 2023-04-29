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
    var fontColor:Color     = .white
    var fontLight:Color     = .gray
    var backgroundLabel     = LinearGradient(colors: [Color(red: 32/255, green: 40/255, blue: 63/255)], startPoint: .top, endPoint: .bottom)
    var backgroundGradient  = LinearGradient(colors: [Color(red: 32/255, green: 40/255, blue: 63/255), Color(red: 4/255, green: 5/255, blue: 8/255)], startPoint: .top, endPoint: .bottom)
    
    
    @AppStorage("Days") var fetchDays:Int = 7
    
    /// Shows the App Name
    var AppName = "Pro Prothese"
    
    // MARK: PERSONAL
    /// Saves the Username
    @AppStorage("Username") var username = "name"
    /// Saves the daily Steptarget
    @AppStorage("targetSteps") var targetSteps = 10000
    
    
    
    // MARK: SETTINGS StepsCount
    /// BarMarks - Shows a green bar when your daily target has been reached
    @AppStorage("ChartBarIsShowing") var ChartBarIsShowing = false
    /// LineMark - Show a red line Marker Stroke, with the daily distance
    @AppStorage("ChartLineDistanceIsShowing") var ChartLineDistanceIsShowing = false
    ///  LineMark - Show a white/blue line Marker Stroke, with the daily steps
    @AppStorage("ChartLineStepsIsShowing") var ChartLineStepsIsShowing = true
    
    ///  LineMark - Show mini Recorder on the StepCounterView
    @AppStorage("ShowRecordOnHomeView") var ShowRecordOnHomeView = true

    /// BarMarks - Shows a yellow rulemark for Avarage Daildy Steps
    @AppStorage("stepRuleMark") var stepRuleMark = true
    
    /// Send Mood Reminder Notification
    @AppStorage("PushNotificationDailyMoodRemembering") var PushNotificationDailyMoodRemembering = true
    // Send no Notification
    @AppStorage("PushNotificationDisable") var PushNotificationDisable = false
    /// Send GoodMorning Notification
    @AppStorage("PushNotificationGoodMorning") var PushNotificationGoodMorning = true
    
    /// Live Notification
    @AppStorage("showLiveActivity") var showLiveActivity                        = true
}

