//
//  AppConfig.swift
//  Pro Prothese
//
//  Created by Frederik Kohler on 23.04.23.
//

import SwiftUI
import Combine
import Foundation
import CoreLocation

class AppConfig: ObservableObject {
    
    static let shared = AppConfig()

    static var store = UserDefaults(suiteName: "group.FK.Pro-these-")
    
    @AppStorage("currentTheme", store: AppConfig.store) var currentTheme: String = "blue"
    
    var adsDebug = true // !!!!!! FOR DEBUG TRUE // PRODUCTION FALSE
    
    var appState = GoogleAds.prod
    var googleAppOpenAd: GoogleAds = .prod
    var googleInterstitialAds: GoogleAds = .prod
    
    @AppStorage("GoogleAppOpenAdLastShow", store: AppConfig.store) var googleAppOpenAdLastShow: Date = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    @AppStorage("GoogleInterstitialLastShow", store: AppConfig.store) var googleInterstitialLastShow: Date = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
    var debugPW = "x"
    
    /// currentTheme.primary
    var foreground          = Color(red: 167/255, green: 178/255, blue: 210/255)

    ///currentTheme.gradientBackground(nil)
    var backgroundGradient  = LinearGradient(colors: [Color(red: 32/255, green: 40/255, blue: 63/255), Color(red: 4/255, green: 5/255, blue: 8/255)], startPoint: .top, endPoint: .bottom)
    var backgroundRadial    = RadialGradient(gradient: Gradient(colors: [ Color(red: 5/255, green: 5/255, blue: 15/255).opacity(0.7), Color(red: 5/255, green: 5/255, blue: 15/255).opacity(1) ]), center: .center, startRadius: 50, endRadius: 300)

    /// currentTheme.gaugeGradient
    var gaugeGradientBad = LinearGradient(colors: [Color(red: 32/255, green: 40/255, blue: 63/255)], startPoint: .top, endPoint: .bottom)
    
    /// currentTheme.gaugeGradient
    var gaugeGradientGood = LinearGradient(colors: [Color(red: 32/255, green: 40/255, blue: 63/255)], startPoint: .top, endPoint: .bottom)
    
    @AppStorage("Days") var fetchDays:Int = 7
    
    
    // MARK: PERSONAL
    /// Saves the Username
    @AppStorage("Username") var username = ""
    
    @AppStorage("hapticFeedback") var hapticFeedback = true
    
    @AppStorage("AmputationDate") var amputationDate: Date = Date()
    
    @AppStorage("ProsthesisDate") var prosthesisDate: Date = Date()
    
    /// Saves the Username
    @AppStorage("UserPin") var userPin:String = ""
    
    @AppStorage("showBadgeSteps", store: AppConfig.store) var showBadgeSteps = false

    @AppStorage("selectedProtheseString") var selectedProtheseString: String = ""
    @AppStorage("selectedProtheseKind") var selectedProtheseKind: String = ""
    @AppStorage("selectedProtheseType") var selectedProtheseType: String = ""
    @AppStorage("selectedProtheseIcon") var selectedProtheseIcon: String = ""
    
    /// Saves the daily Steptarget
    @AppStorage("targetSteps") var targetSteps = 10000
    @AppStorage("targetFloors") var targetFloors = 5
    /// Set the Entry Site
    @AppStorage("EntrySite") var entrySite:Tab = .home
    
    @AppStorage("LastSite") var LastSite:Tab = .ignore
    
    @AppStorage("dismissNavigationLink") var dismissNavigationLink:Bool = false
    
    @AppStorage("NFCallowMyprotheses") var NFCallowMyprotheses:Bool = true
    
    @AppStorage("showTargetStepsOnChartBackground") var showTargetStepsOnChartBackground = true
    
    @AppStorage("showAvgStepsOnChartBackground") var showAvgStepsOnChartBackground = true
    
    ///  LineMark - Show mini Recorder on the StepCounterView
    @AppStorage("ShowToDayRecordingPercentageToAvg") var ShowToDayRecordingPercentageToAvg = true

    /// BarMarks - Shows a yellow rulemark for Avarage Daildy Steps
    @AppStorage("stepRuleMark") var stepRuleMark = true
    
    /// Send Mood Reminder Notification
    @AppStorage("PushNotificationDailyMoodRemembering") var PushNotificationDailyMoodRemembering = true
    @AppStorage("PushNotificationDailyMoodRememberingDate", store: store) var PushNotificationDailyMoodRememberingDate: Date = Calendar.current.date(bySettingHour: 20, minute: 00, second: 00, of: Date())!

    @AppStorage("PushNotificationComebackReminder") var PushNotificationComebackReminder = true
    
    @AppStorage("PushNotificationReports") var PushNotificationReports = true
    // Send no Notification
    @AppStorage("PushNotificationDisable") var PushNotificationDisable = false
    /// Send GoodMorning Notification
    @AppStorage("PushNotificationGoodMorning") var PushNotificationGoodMorning = true
    @AppStorage("PushNotificationGoodMorningDate", store: store) var PushNotificationGoodMorningDate: Date = Calendar.current.date(bySettingHour: 7, minute: 30, second: 00, of: Date())!
    
    @AppStorage("PushNotificationReminder") var PushNotificationReminder = true
        
    @AppStorage("RequestMissingMessageDate") var requestMissingMessageDate = Calendar.current.date(byAdding: .day, value: -5, to: Date())!
    
    @AppStorage("PushNotificationProgress") var PushNotificationProgress = true
    @AppStorage("PushNotificationGoal") var PushNotificationGoal = true
    @AppStorage("PushNotificationGoal") var PushNotificationFloorGoal = true
    
    /// Live Notification
    @AppStorage("showLiveActivity") var showLiveActivity = true
    
    @AppStorage("showChangeLog") var showChangeLog = true
    
    // MARK: - SETTINGS Terminplaner
    @AppStorage("showAllPastEvents") var showAllPastEvents = true
    @AppStorage("showAllPastEventsIsExtended") var showAllPastEventsIsExtended = false
    @AppStorage("showPastWeekEvents") var showPastWeekEvents = true
    @AppStorage("showPastWeekEventsIsExtended") var showPastWeekEventsIsExtended = false
    
    @AppStorage("showAllEvents") var showAllEvents = true
    @AppStorage("EventShowCalendar") var EventShowCalendar = false
    @AppStorage("EventShowList") var EventShowList = true
    
    @AppStorage("faceID") var faceID = false
    
    @AppStorage("debug") var debug = false
    
    @AppStorage("hideInfomations") var hideInfomations = true
    
    @AppStorage("hasUnlockedPro") var hasUnlockedPro = false
    
    var placeholder = [
        "info": "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren."
    ]
  
    
    @AppStorage("hasPro", store: store) var hasPro: Bool = false
    @AppStorage("hasProduct", store: store) var hasProduct: String = ""
    
    @AppStorage("recorderState", store: store) var recorderState: WorkoutSessionState = .notStarted
    @AppStorage("recorderTimer", store: store) var recorderTimer: Date = Date()
    
    // MARK: - Global Strings
    var AppName = "Pro Prothese"
    var EventTitelUnknown = "Prothese App - Unbekanter Termin"
    var ContactTitelUnknown = "Prothese App - Unbekanter Kontakt"
    
    
    // AURORA
    @AppStorage("AuroraBlur") var AuroraBlur: Double = 1.0
    @AppStorage("AuroraSpeed") var AuroraSpeed: Double = 1.0
    @AppStorage("AuroraOpacity") var AuroraOpacity: Double = 1.0
    
    // Temp
    @AppStorage("WidgetContentTemp") var WidgetContentTemp: temp = .c
    
    enum WorkoutSessionState: String, Codable, CaseIterable {
        case notStarted = "Not started"
        case started = "Started"
    }
}

enum Launch: String, Codable, CaseIterable {
    case hasLaunched
    case notLaunchedbefore
    
    var rawValue: String {
        switch self {
        case .hasLaunched: return "hasLaunched"
        case .notLaunchedbefore: return "notLaunchedbefore"
        }
    }
}

enum temp: String, Codable {
    case c
    case f
}

enum GoogleAds {
    case dev, debug, prod
}
