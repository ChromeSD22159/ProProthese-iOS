//
//  workOutViewModel.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 11.05.23.
//

import Foundation

import Foundation
import HealthKit
import MapKit

class workOutViewModel: ObservableObject {
    
    static var shared = workOutViewModel()
    
    private var workOutManager = WorkoutManager.shared
    
   

}




// Workout States
enum WorkoutSessionState {
    case notStarted, started, finished
}



