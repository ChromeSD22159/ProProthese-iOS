//
//  LiveActivityManager.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 09.05.23.
//

import Foundation
import SwiftUI
import ActivityKit
import WidgetKit

class LiveActivityManager: ObservableObject {
    let minutes = 30
    let seconds = 30
    
    @Published var activities = Activity<RecordTimerAttributes>.activities    
    @Published var activity: Activity<RecordTimerAttributes>? = nil
    
    func LiveActivityStart(name: String){
            if ActivityAuthorizationInfo().areActivitiesEnabled {
                do {
                    if #available(iOS 16.2, *) {
                        let attributes = RecordTimerAttributes(lastRecord: name)
                        let state = RecordTimerAttributes.ContentState(isRunning: true, timeStamp: Date.now, state: "Zeichnet auf", endTime: "" )
                        
                        activity = try? Activity<RecordTimerAttributes>.request(attributes: attributes, contentState: state, pushType: nil)
                        
                        print("Requested a LiveRecordTimer - Live Activity \(String(describing: activity?.id)).")
                    }
                }
            }
    }
        
    func liveActivityStop(isRunning: Bool, endTime: String){
        
        let finalDeliveryStatus = RecordTimerAttributes.ContentState(isRunning: isRunning, timeStamp: Date.now, state: "Beendet", endTime: endTime)
        
        if #available(iOS 16.2, *) {
            let finalContent = ActivityContent(state: finalDeliveryStatus, staleDate: nil)
            Task {
                for activity in Activity<RecordTimerAttributes>.activities {
                    await activity.end(finalContent, dismissalPolicy: .default)
                    print("Ending the Live Activity: \(activity.id)")
                }
            }
        }
    }
        
    
    
    
    
    /*
    func createActivity() {
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            print("Live Enavled")
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                
                if let error = error {
                    // Handle the error here.
                }
                
                // Enable or disable features based on the authorization.
            }
            
            let attributes = RecordTimerAttributes(numberOfPizzas: 1, totalAmount: "", orderNumber: "")
            let contentState = RecordTimerAttributes.RecordTimerState(driverName: "driver", deliveryTimer: .now + 120)
            do {
                let Activity = try Activity<RecordTimerAttributes>.request( attributes: attributes, contentState: contentState, pushType: nil)
                print("Live: \(Activity.id)")
            } catch (let error) {
                print("Live: \(error.localizedDescription)")
            }
        }
    }
    
    func update(activity: Activity<RecordTimerAttributes>) {
        Task {
            let updatedStatus = RecordTimerAttributes.RecordTimerState(driverName: "Adam", deliveryTimer: .now + 150)
            await activity.update(using: updatedStatus)
        }
    }
    
    func end(activity: Activity<RecordTimerAttributes>) {
        Task {
            await activity.end(dismissalPolicy: .immediate)
        }
    }
    
    func endAllActivity() {
        Task {
            for activity in Activity<RecordTimerAttributes>.activities{
                await activity.end(dismissalPolicy: .immediate)
            }
        }
    }
    
    func listAllDeliveries() {
          var activities = Activity<RecordTimerAttributes>.activities
          activities.sort { $0.id > $1.id }
          self.activities = activities
      }
    */
}


