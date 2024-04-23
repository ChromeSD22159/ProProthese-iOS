//
//  FloorsNotificationRequest.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 17.10.23.
//

import SwiftUI

enum FloorsNotificationRequest {
    
    static var handlerState = HandlerStates.shared
    
    static var appConfig = AppConfig.shared

    static func requestHandlerForGoal(debug: Bool, floors: Int, date: Date, error: Error?) -> Bool {
        
        print("[requestHandlerForGoal]: \(floors) \(appConfig.targetFloors)")
        
        guard error == nil else  { return false }
        
        guard appConfig.PushNotificationFloorGoal else {
            print("[requestHandlerForGoal]: No Notification allowed")
            return false
        }
        
        guard Calendar.current.isDateInToday(date) && floors >= appConfig.targetFloors else {
            print("[requestHandlerForGoal]: Is not Today and less floors")
            return false
        }
        
        guard !Calendar.current.isDateInToday(handlerState.sendReachedFullTargetFloorNotificationDate) else  {
            print("[requestHandlerForGoal]: Sendet is same day")
            return false
        }
        
        return true
    }
}
