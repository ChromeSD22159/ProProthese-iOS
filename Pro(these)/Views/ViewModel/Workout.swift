//
//  Workout.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 12.05.23.
//

import Foundation
import HealthKit
import CoreLocation

struct Workout: Identifiable, Hashable {
    let id = UUID()
    let startDate: Date
    let endDate: Date
    let duration: Double
    let workout: HKWorkout
    let workoutRouteSample: HKSample?
    let route: [CLLocation]?
}
