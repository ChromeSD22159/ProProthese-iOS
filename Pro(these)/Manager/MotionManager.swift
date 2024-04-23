//
//  MotionManager.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 16.10.23.
//

import SwiftUI
import CoreMotion

class MotionManager: ObservableObject {
    private var motionManager = CMMotionManager()
    private var pedoMeter = CMPedometer()
     
    @MainActor func stepPedometerDataInBackground() {
        if CMPedometer.isStepCountingAvailable() {
           let fromDate = Date().startEndOfDay().start
            
           pedoMeter.startUpdates(from: fromDate) { data, error in
               if let numberOfSteps = data?.numberOfSteps.doubleValue {
                   print("Schritte: \(numberOfSteps)")
                   // Hier können Sie Ihre Benachrichtigungslogik einfügen
                   guard error == nil else {
                       print(error?.localizedDescription ?? "pedometer numberOfSteps error")
                       return
                   }

                   if StepNotificationRequest.requestHandlerForHalfStepsGoal(debug: false, steps: Int(numberOfSteps ), stepsDate: Date(), error: error) {
                       PushNotificationManager().reachedHalfOfTargetStepsNotification(steps: Int(numberOfSteps ))
                   }
                   
                   if StepNotificationRequest.requestHandlerForFullStepsGoal(debug: false, steps: Int(numberOfSteps ), stepsDate:  Date(), error: error) {
                       PushNotificationManager().reachedFullOfTargetStepsNotification(steps: Int(numberOfSteps ))
                   }
                   
                   if HandlerStates.showBadgeSteps {
                       StepBadgeManager.badgeManager.setAlertBadge(number: Int(numberOfSteps ))
                   } else {
                       StepBadgeManager.badgeManager.resetAlertBadgetNumber()
                   }
               }
               
               if let floors = data?.floorsAscended?.intValue {
                   print("Stockwerke: \(floors)")
                   if FloorsNotificationRequest.requestHandlerForGoal(debug: false, floors: floors, date: Date(), error: nil) {
                       HandlerStates.shared.sendReachedFullTargetFloorNotificationDate = Date()
                       PushNotificationManager().reachedTargetFloorsNotification(floors: floors)
                   }
               }
           }

           DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
               self.pedoMeter.stopUpdates()
           }
       }
    }
    
    @MainActor func stepPedometerDataInBackgroundEvent() {
        if CMPedometer.isStepCountingAvailable() {
            pedoMeter.startEventUpdates(handler: {_,_ in
                self.stepPedometerDataInBackground()
            })

           DispatchQueue.main.asyncAfter(deadline: .now() + 60) {
               self.pedoMeter.stopUpdates()
           }
       }
    }
}
