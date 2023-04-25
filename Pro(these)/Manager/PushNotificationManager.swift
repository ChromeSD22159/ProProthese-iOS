//
//  PushNotificationManager.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 24.04.23.
//

import SwiftUI
import UserNotifications

class PushNotificationManager : ObservableObject {
    
    @StateObject var PushNotification = PushNotifications()
    
    var pendingNotification: [String] = []
    
    init(){
        if !AppConfig().PushNotificationDisable {
            setUpDailyNotifications()
        }
    }
    
    
    /// Register Push Notification and ask for Authorizarion.
    func registerForPushNotifications(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    /// Write the Notification Settings into the debug console.
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("Notification settings: \(settings)")
      }
    }
    
    /// Remove Notifications when the App appear or change in foreground.
    ///
    /// Important
    /// The func is fired as soon as the scene is in the foreground and when the app is started.
    ///
    /// ```swift
    ///   .onChange(of: scenePhase) { newPhase in
    ///       if newPhase == .active {  // APP is in Foreground / Active
    ///         pushNotificationManager.removeNotifications()
    ///       } else if newPhase == .inactive { // // APP changed to Inactive
    ///         pushNotificationManager.setUpNotifications()
    ///    } else if newPhase == .background { // APP changed to Background
    ///         print("APP changed to Background")
    ///    }
    /// ```
    func removeNotificationsWhenAppLoads(){
        removeNotification(identifier: "PROTHESE_COMEBACK_REMINDER")
    }
    
    func setUpDailyNotifications(){
        if AppConfig().PushNotificationDailyMoodRemembering {
            PushNotificationByDate(
                identifier: "PROTHESE_MOOD_REMINDER",
                title: "Erzähle mir von deinem Tag 🦾 🦾 ",
                body: "Hinterlasse keine leere Seite in deinem Prothesentagebuch. ✌️",
                triggerHour: 20,
                triggerMinute: 30,
                repeater: true)
        }
        
        PushNotificationByDate(
            identifier: "PROTHESE_MOOD_GOOD_MORNING",
            title: "Starte gut in den Tag 🦾 🦾",
            body: "Denke an dein Prothesentagebuch und träge brav deine Zeit. ✌️",
            triggerHour: 7,
            triggerMinute: 30, repeater: true)
        
        
    }
    
    /// Set Notifications new Notifications when the App getting starting or change to foreground.
    ///
    /// Important
    /// The func is fired as soon as the scene is in the foreground and when the app is started.
    ///
    func setUpNotifications() {
        PushNotificationByTimer(
            identifier: "PROTHESE_COMEBACK_REMINDER",
            title: "Wir haben dich heute noch nicht gesehen 😢",
            body: "Komm bald wieder vorbei, es wird Spannend ✌️",
            triggerTimer: 20
        )
    }
    
    /// Setup a new Notification with an Timer Trigger
    ///
    /// - Parameter identifier:    (String)     - Set Notification Identifier - To search for it or delele
    /// - Parameter title:         (String)     - Set Notification Headline (String)
    /// - Parameter body:          (String)     - Set Notification Body Text (String)
    /// - Parameter triggerTimer:  (String)     - Set Notification Timer (Int) in seconds after trigger/ register the Notification
    func PushNotificationByTimer(identifier: String, title: String, body: String, triggerTimer: Int) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(triggerTimer), repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
        
        print("Register Notification:  \(identifier)")
    }
    
    /// Setup a new Notification with an Date Trigger
    ///
    /// - Parameter identifier:    (String)     - Set Notification Identifier - To search for it or delele
    /// - Parameter title:         (String)     - Set Notification Headline (String)
    /// - Parameter body:          (String)     - Set Notification Body Text (String)
    /// - Parameter triggerTimer:  (String)     - Set Notification Timer (Int) in seconds after trigger/ register the Notification
    func PushNotificationByDate(identifier: String, title: String, body: String, triggerHour: Int, triggerMinute: Int, repeater: Bool) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        var date = DateComponents()
        date.hour = triggerHour
        date.minute = triggerMinute
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: repeater)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
        
        print("Register Notification:  \(identifier)")
    }
    
    
    // MARK: Remove all pending Notifications
    func removeAllPendingNotificationRequests(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
    
    // MARK: Remove an registered Notification by the identifier
    func removeNotification(identifier: String){
        let strIdentifier = identifier
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["\(strIdentifier)"])
    }
    
    // MARK: Print all Array for all Registered Notifications
    func getAllNotifications() {
        UNUserNotificationCenter.current().getDeliveredNotifications { (notifications) in
            for notification:UNNotification in notifications {
                print(notification.request.content)
                print(notification.request.identifier)
            }
        }
    }
    
    // MARK: Returns an Array for all Pending Notifications
    func getAllPendingNotifications() -> [String] {
        let center = UNUserNotificationCenter.current()
        var note: [String] = []
        
        center.getPendingNotificationRequests(completionHandler: { requests in
            for request in requests {
                note.append(request.identifier)
                print("Pending Notification: \(request.identifier)")
            }
        })
        return note
    }
    
    
    
    
    
    
    
    // MARK: TEST
    func schedule(title: String, subtitle: String, body: String, hour: Int, minute: Int, identifier: Int, repeatX: Bool){
        let content = UNMutableNotificationContent()
        
        let strIdentifier = "FK_PROTHESE_\(identifier)"
        
        content.title = title
        if subtitle != "" {
            content.subtitle = subtitle
        }
        content.subtitle = body
        content.sound = UNNotificationSound.default

        var date = DateComponents()
        date.hour = hour
        date.minute = minute
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: repeatX)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: strIdentifier, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
    }
    
    func testSchedule(title: String, subtitle: String, body:String, sec: String, repeatX: Bool){
        let content = UNMutableNotificationContent()
        
        let strIdentifier = UUID().uuidString
        
        if title != "" {
            content.title = title
        }
        if subtitle != "" {
            content.subtitle = subtitle
        }
        if body != "" {
            content.body = body
        }
        
       
        content.sound = UNNotificationSound.default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(Int(sec)!), repeats: repeatX)


        // choose a random identifier
        let request = UNNotificationRequest(identifier: strIdentifier, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
      
    }
}



class Random {
//   Random().int(between: 1, and: 10)
    func int(between: Int, and: Int) -> Int {
      return Int.random(in: between...and)
    }

    func double(between: Double, and: Double) -> Double {
      return Double.random(in: between...and)
    }
}

    
    
    
