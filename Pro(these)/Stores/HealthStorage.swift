//
//  HealthStorage.swift
//  Pro Prothese
//
//  Created by Frederik Kohler on 24.04.23.
//

import SwiftUI

class HealthStorage: ObservableObject {
    @Published var showDate: Date = Date()
    @Published var showStep: Int = 0
    @Published var showDistance: Double = 0
    
    @AppStorage("Days") var fetchDays:Int = 7
    
    @Published var Distances: [Double] = [Double]()
    @Published var Steps: [Step] = [Step]()
    
    @Published var Merged: [Step] = [Step]()
    
    @Published var StepCount: Int = 0
}
