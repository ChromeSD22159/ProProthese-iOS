//
//  AppNotifications.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 13.08.23.
//

import SwiftUI

enum AppNotifications {
    
    @AppStorage("PushNotificationDailyMoodRemembering") static var PushNotificationDailyMoodRemembering = true
    
    @AppStorage("PushNotificationGoodMorning") static var PushNotificationGoodMorning = true
    
    @AppStorage("PushNotificationComebackReminder") static var PushNotificationComebackReminder = true
    
    private static var name = "AppNotifications"
    
    static func removeNotifications(keyworks: [String], notes: [UNNotificationRequest]) {
        for keyword in keyworks {
            let note = notes.filter({  $0.identifier.contains(keyword)  })
          
            if note.count > 0 {
                let _ = note.map {
                    PushNotificationManager().removeNotification(identifier: $0.identifier, printConsole: true)
                }
            }
            
        }
    }
    
    static func isNotification(identfier: String, notes: [UNNotificationRequest]) -> Bool {
        
        let result = notes.filter({  $0.identifier.contains(identfier)  }).count
        
        return result == 0 ? false : true
    }
    
    static func setMoodReminderNotifications(printConsole: Bool? = nil) {
        if PushNotificationDailyMoodRemembering {
            let note = MoodReminderNotifications.shared.randomNotification
            
            PushNotificationManager().PushNotificationByDate(
                identifier: note.identifier,
                title: note.title,
                body: note.body,
                triggerHour: note.triggerHour,
                triggerMinute: note.triggerMinute,
                repeater: note.repeater,
                url: note.url,
                userInfo: note.userInfo,
                printConsole: printConsole
            )
        }
    }
    
    static func setGoodMorningNotifications(printConsole: Bool? = nil) {
        if PushNotificationGoodMorning {
            let note = GoodMonrningNotifications.shared.randomNotification
            
            PushNotificationManager().PushNotificationByDate(
                identifier: note.identifier,
                title: note.title,
                body: note.body,
                triggerHour: note.triggerHour,
                triggerMinute: note.triggerMinute,
                repeater: note.repeater,
                url: note.url,
                userInfo: note.userInfo,
                printConsole: printConsole
            )
        }
    }
    
    static func setComebackNotifications(delay: Int, printConsole: Bool? = nil) {
        if PushNotificationComebackReminder {
            let targetTriggerDate = Calendar.current.date(byAdding: .second, value: delay, to: Date())!
            let startNotificationWindow = Calendar.current.date(bySetting: .hour, value: 8, of: Date())!
            let endNotificationWindow = Calendar.current.date(bySetting: .hour, value: 21, of: Date())!
            
            if Date.now > startNotificationWindow && targetTriggerDate < endNotificationWindow {
                let note = ComebackReminderNotifications.shared.randomNotification
                
                PushNotificationManager().PushNotificationByTimer(
                    identifier: note.identifier,
                    title: note.title,
                    body: note.body,
                    triggerTimer: delay,
                    url: note.url,
                    userInfo: note.userInfo,
                    printConsole: printConsole
                )
                
                print("[\(name)] Next ComebackNotification: \(targetTriggerDate)")
            }  else {
                print("[\(name)] ComebackNotification not in date range")
            }
        }
    }
    
    static func setPushNotificationWeeklyReport(notes: [UNNotificationRequest], debug: Bool? = nil) {
        let notification = ReportNotification.shared.randomNotification
        
        if AppConfig.shared.PushNotificationReports {
            let content = UNMutableNotificationContent()
                content.title = notification.title
                content.body = notification.body
                content.userInfo = ["Tab" : Tab.home.rawValue]
            
                // Setzen Sie den gewünschten Tag und die gewünschte Stunde für die Benachrichtigung (Montag, 9:30 Uhr)
                var dateComponents = DateComponents()
                    dateComponents.weekday = 2
                    dateComponents.hour = 9
                    dateComponents.minute = 30
            
                // Erstellen Sie einen Trigger, der sich jede Woche am Montag wiederholt
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

                // Erstellen Sie die Benachrichtigungsanfrage
                let request = UNNotificationRequest(identifier: notification.identifier, content: content, trigger: trigger)

                // Fügen Sie die Benachrichtigungsanfrage zur Benachrichtigungs-Warteschlange hinzu
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
            if debug ?? false {
                print("[WeeklyReportNotification] Now registered:  \(notification.identifier) - \(notification.title) - Trigger: \(dateComponents.hour!):\(dateComponents.minute!), - userInfo: \(content.userInfo)")
            }
        } else {
            if debug ?? false {
                print("[WeeklyReportNotification] User has disable")
            }
        }
    }
}
