//
//  StepsNotification.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 14.08.23.
//

import SwiftUI

class StepsNotifications {
    static var shared = StepsNotifications()
    
    private var stepCount: Int = 0
    
    var halfNotifications: [NotificationByTimer] {
        let identifier = "REACHED_HALF_DAILY_GOAL"
        return [
            
            NotificationByTimer(
                identifier: identifier,
                title: LocalizedStringKey("Keep it up! 🥳").localizedstring(),
                body: LocalizedStringKey("Great, half done! You have now reached more than 50% of your step goal. 🥳 🥳").localizedstring(),
                triggerTimer: Int.random(in: 60...580),
                url: "",
                userInfo: ["Tab" : Tab.home.rawValue]
            ),
            
            NotificationByTimer(
                identifier: identifier,
                title: LocalizedStringKey("Keep it up! 👏").localizedstring(),
                body: LocalizedStringKey("You've already reached 50% of your daily step goal.").localizedstring(),
                triggerTimer: Int.random(in: 60...580),
                url: "",
                userInfo: ["Tab" : Tab.home.rawValue]
            ),
            
            NotificationByTimer(
                identifier: identifier,
                title: LocalizedStringKey("Great progress today!").localizedstring(),
                body: String(format: NSLocalizedString("WOW, you've already walked %lld steps today, that's more than half of your daily goal. 🥳 👏", comment: ""), stepCount),
                triggerTimer: Int.random(in: 60...580),
                url: "",
                userInfo: ["Tab" : Tab.home.rawValue]
            )
            
        ]
    }
    
    var fullNotifications: [NotificationByTimer] {
        let identifier = "REACHED_FULL_DAILY_GOAL"
        
        return [
            NotificationByTimer(
                identifier: identifier,
                title: AppConfig().username.isEmpty ? String(format: NSLocalizedString("Congratulations on reaching your goal for the day 🥳", comment: "")) :  String(format: NSLocalizedString("Congratulations, %@! 🥳", comment: ""), AppConfig().username),
                body: String(format: NSLocalizedString("Congratulations, you have reached your daily goal! You walked more than %lld steps today. 🥳 🥳", comment: ""), AppConfig().targetSteps),
                triggerTimer: Int.random(in: 60...580),
                url: "",
                userInfo: ["Tab" : Tab.home.rawValue]
            ),
        
            NotificationByTimer(
                identifier: identifier,
                title: String(format: NSLocalizedString("More than %lld steps. 🥳 🎉", comment: ""), AppConfig().targetSteps),
                body: String(format: NSLocalizedString("You have reached your goal today!", comment: ""), AppConfig().targetSteps),
                triggerTimer: Int.random(in: 60...580),
                url: "",
                userInfo: ["Tab" : Tab.home.rawValue]
            )
        ]
    }
    
    func randomHalfNotification(steps: Int) -> NotificationByTimer {
        let index = self.countHalfNotifications
        let randomIndex = Int.random(in: 0...index)
        stepCount = steps
        return halfNotifications[randomIndex]
    }
    
    func randomFullNotification(steps: Int) ->  NotificationByTimer {
        let index = self.countFullNotifications
        let randomIndex = Int.random(in: 0...index)
        stepCount = steps
        return fullNotifications[randomIndex]
    }
    
    var countHalfNotifications: Int {
        let c = self.halfNotifications.count
        return c == 0 ? 0 : self.halfNotifications.count - 1
    }
    
    var countFullNotifications: Int {
        let c = self.fullNotifications.count
        return c == 0 ? 0 : self.fullNotifications.count - 1
    }
}
