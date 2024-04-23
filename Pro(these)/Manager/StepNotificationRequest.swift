//
//  StepNotificationRequest.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 13.08.23.
//

import SwiftUI

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}

enum StepNotificationRequest {
    
    static var handlerState = HandlerStates.shared
    
    static var appConfig = AppConfig.shared
    
    static func requestHandlerForHalfStepsGoal(debug: Bool, steps: Int, stepsDate: Date, error: Error?) -> Bool {
        guard error == nil else {
            return false
        }
        
        guard appConfig.PushNotificationProgress else { return false }
        
        guard Calendar.current.isDateInToday(stepsDate) && steps >= appConfig.targetSteps / 2 && steps <= (appConfig.targetSteps / 3 * 2)  else  { return false }
        
        guard !Calendar.current.isDateInToday(handlerState.sendReachedHalfTargetStepsNotificationDate) else  { return false }
        
        handlerState.sendReachedHalfTargetStepsNotificationDate = Date()
        
        return true
    }
    
    static func requestHandlerForFullStepsGoal(debug: Bool, steps: Int, stepsDate: Date, error: Error?) -> Bool {
        
        guard error == nil else  { return false }
        
        guard appConfig.PushNotificationProgress, appConfig.PushNotificationGoal else { return false }
        
        guard Calendar.current.isDateInToday(stepsDate) && steps >= appConfig.targetSteps else { return false }
        
        guard !Calendar.current.isDateInToday(handlerState.sendReachedFullTargetStepsNotificationDate) else  { return false }

        handlerState.sendReachedFullTargetStepsNotificationDate = Date()
        
        return true
        
    }
}
