//
//  FloorNotifications.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 17.10.23.
//

import SwiftUI

class FloorNotifications {
    static var shared = FloorNotifications()
    
    private var floorCount: Int = 0
    
    var goalNotifications: [NotificationByTimer] {
        let identifier = "REACHED_FLOOR_GOAL"
        return [
            
           
            
            NotificationByTimer(
                identifier: identifier,
                title: LocalizedStringKey("Keep it up! 🥳").localizedstring(),
                body: String(format: NSLocalizedString("Great, your goal has been achieved! Your daily goal of at least %lld stairs has been reached.🥳 🥳", comment: ""), AppConfig().targetFloors),
                triggerTimer: Int.random(in: 60...580),
                url: "",
                userInfo: ["Tab" : Tab.home.rawValue]
            ),
            
        ]
    }
    
    func randomGoalNotification(floors: Int) -> NotificationByTimer {
        let index = self.countGoalNotifications
        let randomIndex = Int.random(in: 0...index)
        floorCount = floors
        return goalNotifications[randomIndex]
    }

    var countGoalNotifications: Int {
        let c = self.goalNotifications.count
        return c == 0 ? 0 : self.goalNotifications.count - 1
    }
}
