//
//  StopWatchProvider.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 19.05.23.
//

import Foundation
import HealthKit

class StopWatchProvider: NSObject, ObservableObject {
    
    static var shared = StopWatchProvider()
    
    var store = HKHealthStore()
    
    @Published var recorderState: WorkoutSessionState = .notStarted
    @Published var recorderStartTime: Date?
    
    func startRecording(){
        let date = Date()
        self.recorderStartTime = date
        UserDefaults.standard.set(self.recorderStartTime, forKey: "startTime")
        self.recorderState = .started
    }
    
    func stopRecording(){
        let startTime = recorderFetchStartTime()
        guard startTime != nil else {
            return print("stopRecording: Start Time is unset")
        }
        completeWorkout(workout: .walking, start: startTime!, end: Date())

        self.recorderStartTime = nil
        UserDefaults.standard.set(nil, forKey: "startTime")
        self.recorderState = .notStarted
    }
    
    func recorderFetchStartTime() -> Date? {
        if (UserDefaults.standard.object(forKey: "startTime") != nil) {
            return UserDefaults.standard.object(forKey: "startTime") as? Date
        } else {
            return nil
        }
    }
    
    func deleteWorkout(start: Date, end: Date){

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
}
