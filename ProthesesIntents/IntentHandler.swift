//
//  IntentHandler.swift
//  ProthesesIntents
//
//  Created by Frederik Kohler on 11.10.23.
//

import Intents

class IntentHandler: INExtension, StartProthesenTimerIntentHandling, StopProthesenTimerIntentHandling {
    var appConfig = AppConfig.shared
    
    func handle(intent: StartProthesenTimerIntent) async -> StartProthesenTimerIntentResponse {
        if appConfig.recorderState == .started {
            return  StartProthesenTimerIntentResponse(code: .failure, userActivity: nil)
        }
        
        if appConfig.recorderState == .notStarted {
            appConfig.recorderState = .started
            appConfig.recorderTimer = Date()
            return  StartProthesenTimerIntentResponse(code: .success, userActivity: nil)
        }
        
        return StartProthesenTimerIntentResponse(code: .success, userActivity: nil)
    }
    
    func handle(intent: StopProthesenTimerIntent) async -> StopProthesenTimerIntentResponse {
        if appConfig.recorderState == .started { // end Timer
            appConfig.recorderState = .notStarted
            return  StopProthesenTimerIntentResponse(code: .success, userActivity: nil)
        }
        
        if appConfig.recorderState == .notStarted { // start Timer
            return  StopProthesenTimerIntentResponse(code: .failure, userActivity: nil)
        }
        
        return StopProthesenTimerIntentResponse(code: .success, userActivity: nil)
    }
}
