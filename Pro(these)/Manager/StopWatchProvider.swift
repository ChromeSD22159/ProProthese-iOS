//
//  StopWatchProvider.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 19.05.23.
//

import Foundation
import HealthKit
import WidgetKit
import SwiftUI
import CoreData

#if canImport(ActivityKit) && !os(watchOS)
import ActivityKit
#endif

class StopWatchProvider: NSObject, ObservableObject {
    
    static var shared = StopWatchProvider()
    
    let persistenceController = PersistenceController.shared
    
    var store = HKHealthStore()
    
    var appConfig = AppConfig.shared
    
    @Published var recorderState: WorkoutSessionState = .notStarted
    @Published var recorderStartTime: Date?

    func toggleTimer() {
        
        switch appConfig.recorderState {
            case .notStarted:
                let date = Date()
                appConfig.recorderState = .started
                appConfig.recorderTimer = date
                startLiveActivity(date: date, prothese: AppConfig.shared.selectedProtheseString)
            
            case .started:
                let date = appConfig.recorderTimer
                appConfig.recorderState = .notStarted
                endLiveActivity(startDate: date, prothese: AppConfig.shared.selectedProtheseString)
        }
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func endTimer() {
        let date = appConfig.recorderTimer
        let workoutSecound = Calendar.current.dateComponents([.second], from: date, to: Date()).second!
        
        if workoutSecound < 345500 {
            completeWorkout(workout: .walking, start: date, end: Date())
            
            saveWorkoutToCoreData(start: date, end: Date(), duration: Int32(workoutSecound), showLog: true)
        }
    }
    
    func saveWorkoutToCoreData(start: Date, end: Date, duration: Int32, showLog: Bool? = nil) {
        let newWearingTime = WearingTimes(context: PersistenceController.shared.container.viewContext)
        newWearingTime.start = start
        newWearingTime.end = end
        newWearingTime.duration = duration

        if let prothese = fetchProstheses(ofKind: AppConfig.shared.selectedProtheseKind, ofType: AppConfig.shared.selectedProtheseType) {
            newWearingTime.prothese = prothese
            
            prothese.addToWearingTimes(newWearingTime)
        }

        do {
            try? persistenceController.container.viewContext.save()
        }
        
        if showLog ?? false {
            print("Workout: Saved to CoreData!")
            print(newWearingTime)
        }
    }
    
    func fetchProstheses(ofKind kind: String, ofType type: String) -> Prothese? {
        var prostheses = [Prothese]()

        let fetchRequest: NSFetchRequest<Prothese> = Prothese.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "kind == %@ AND type == %@", kind, type)

        do {
            let context = persistenceController.container.viewContext
            prostheses = try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch prostheses: \(error.localizedDescription)")
        }

        return prostheses.first
    }

    func startLiveActivity(date: Date, prothese: String) {
        if AppConfig.shared.showLiveActivity {
            if ActivityAuthorizationInfo().areActivitiesEnabled {

                let LiveAttributes = ProProtheseWidgetAttributes()
                
                let initialContentState = ProProtheseWidgetAttributes.ContentState(isRunning: true, date: date, prothese: AppConfig.shared.selectedProtheseString)
                
                // Start the Live Activity.
                do {

                    let newActivity = try Activity<ProProtheseWidgetAttributes>.request( attributes: LiveAttributes, contentState: initialContentState, pushType: nil)
                    
                    print("Requested a Live Activity \(String(describing: newActivity.id)).")
                } catch (let error) {
                    print("Error requesting pizza delivery Live Activity \(error.localizedDescription).")
                }
            }
        }
    }
    
    func endLiveActivity(startDate: Date, prothese: String) {
        if AppConfig.shared.showLiveActivity {
            let diffTime = Calendar.current.dateComponents([.second], from: startDate, to: Date()).second
            
            let finalDeliveryStatus = ProProtheseWidgetAttributes.ContentState(isRunning: false, date: Date(), endTime: diffTime, prothese: prothese)
            let finalContent = ActivityContent(state: finalDeliveryStatus, staleDate: nil)

            Task {
                for activity in Activity<ProProtheseWidgetAttributes>.activities {
                    await activity.end(finalContent, dismissalPolicy: .immediate)
                    print("Ending the Live Activity: \(activity.id)")
                }
            }
        }
    }

    var builder: HKWorkoutBuilder?

    func completeWorkout(workout: HKWorkoutActivityType, start: Date, end: Date) {
        // generate an WorkOut Session
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .other
        let builder = HKWorkoutBuilder(healthStore: store, configuration: workoutConfiguration, device: .local())
        
        // Finish the Workoutsession
        builder.finishWorkout { (_, error) in
            _ = error == nil
        }
        
        // Generatre Workout
        let inputState = HKWorkout(
            activityType: .other,
            start: start,
            end: end,
            duration: end.timeIntervalSince(start),
            totalEnergyBurned: nil,
            totalDistance: nil,
            device: .local(),
            metadata: nil
        )

        // save Workout to Fitness Store
        self.store.save(inputState) { success, error in
             if (error != nil) {
                 print("Error: \(String(describing: error))")
             }
             if success {
                 print("Saved: \(success)")
             }
        }
        
        // Reset WorkoutBuilder
        self.builder = nil
    }
    
    enum WorkoutSessionState: String, Codable, CaseIterable {
        case notStarted = "Not started"
        case started = "Started"
    }
}
