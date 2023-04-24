//
//  PushNotificationManager.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 24.04.23.
//

import SwiftUI
import UserNotifications

class PushNotificationManager : ObservableObject {
    
    var pendingNotification: [String] = []
    
    init(){
        if AppConfig().PushNotificationDailyMoodRemembering {
            PushNotificationMoodReminder()
        }
        
        if !AppConfig().PushNotificationDisable {
            request()
        }
        self.PushNotificationGoodMorning()
    }
    
    
    // MARK: Remember add the daily Mood/Note
    func PushNotificationMoodReminder(){
        let strIdentifier = "PROTHESE_MOOD_REMINDER"
        
        let content = UNMutableNotificationContent()
        content.title = "Erzähle mir von deinem Tag 🦾 🦾 "
        content.body = "Hinterlasse keine leere Seite in deinem Prothesentagebuch. ✌️"
        content.sound = UNNotificationSound.default
        
        var date = DateComponents()
        date.hour = 20
        date.minute = 30
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: strIdentifier, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
        
        print("Register Notification: FK_PROTHESE_MOOD_REMINDER")
    }
    
    // MARK: Say good morning
    func PushNotificationGoodMorning(){
        let strIdentifier = "PROTHESE_MOOD_GOOD_MORNING"
        
        let content = UNMutableNotificationContent()
        content.title = "Starte gut in den Tag 🦾 🦾 "
        content.body = "Denke an dein Prothesentagebuch und träge brav deine Zeit. ✌️"
        content.sound = UNNotificationSound.default
        
        var date = DateComponents()
        date.hour = 7
        date.minute = 30
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: strIdentifier, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
        
        print("Register Notification:  FK_PROTHESE_MOOD_GOOD_MORNING")
    }
    
    // MARK: Come back Push Notification
    func PushNotificationComeBack(){
        let strIdentifier = "PROTHESE_COMEBACK_REMINDER"
        
        let content = UNMutableNotificationContent()
        content.title = "Wir haben dich heute noch nicht gesehen 😢" //
        content.body = "Komm bald wieder vorbei, es wird Spannend ✌️"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(Int(300)), repeats: false)

        // choose a random identifier
        let request = UNNotificationRequest(identifier: strIdentifier, content: content, trigger: trigger)

        // add our notification request
        UNUserNotificationCenter.current().add(request)
        
        print("Register Notification:  FK_PROTHESE_MOOD_GOOD_MORNING")
    }
    
    
    
    
    
    // MARK: User AUTH Request
    func request(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
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
