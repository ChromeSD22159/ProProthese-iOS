//
//  StepCounterManager.swift
//  Pro Prothese
//
//  Created by Frederik Kohler on 24.04.23.
//

import SwiftUI
import HealthKit

class StepCounterManager: ObservableObject {
    
    @Published var activeChartCirle: Int = 0
    @Published var devideSizeWidth: CGFloat = 0
    
    // tab gesture
    @Published var activeDateCicle: Date = Date()
    @Published var activeisActive: Bool = false
    @Published var activeStepCount: Int = 0
    @Published var activeStepDistance: Double = 0
  
    @AppStorage("StepsTarget") var targetSteps: Int = 10000
    
    // Circle
    @Published var drawingRingStroke: Bool = false
    @Published var drawingshowRecordStroke: Bool = false
    @Published var drawingRecordStroke: Bool = false
    @Published var angleGradient = AngularGradient(colors: [.white.opacity(0.5), .blue.opacity(0.5)], center: .center, startAngle: .degrees(-90), endAngle: .degrees(360))
    @Published var recordGradient = AngularGradient(colors: [.orange, .red], center: .center, startAngle: .degrees(-90), endAngle: .degrees(360))
    @AppStorage("Days") var fetchDays:Int = 7

    func percent(Int: Int) -> Double {
        return Double(Int) / Double(targetSteps) * 100
    }
        
    func dez(Int: Int) -> Double {
        return Double(Int) / Double(targetSteps) * 1
    }
    
    func calcChartItemSize() -> CGFloat {
        let days = fetchDays
        let itemSize = (devideSizeWidth / 7)
        return itemSize * CGFloat(days)
    }
    
    func maxSteps(steps: [Step]) -> Int {
        let max = steps.max(by: { (a, b) -> Bool in
            return a.count < b.count
        })
        return max?.count ?? 0
    }
    
    func minSteps(steps: [Step]) -> Int {
        let min = steps.min(by: { (a, b) -> Bool in
            return a.count < b.count
        })
        return min?.count ?? 0
    }
    
    func avgSteps(steps: [Step]) -> Int {
        let days = self.fetchDays
        let avg = (self.totalSteps(steps: steps) / days)
        return avg
    }
    
    func totalSteps(steps: [Step]) -> Int {
       return steps.map { $0.count }.reduce(0,+)
   }
}

