//
//  calculateCorrelation.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 09.10.23.
//

import CoreData
import Foundation
import SwiftUI



// Funktion zur Berechnung des Korrelationskoeffizienten nach Pearson
func pearsonCorrelation(_ x: [Double], _ y: [Double]) -> Double {
    precondition(x.count == y.count, "Input arrays must have the same length")

    let n = x.count
    let xMean = x.reduce(0, +) / Double(n)
    let yMean = y.reduce(0, +) / Double(n)

    var numerator = 0.0
    var denominatorX = 0.0
    var denominatorY = 0.0

    for i in 0..<n {
        let xDiff = x[i] - xMean
        let yDiff = y[i] - yMean

        numerator += xDiff * yDiff
        denominatorX += xDiff * xDiff
        denominatorY += yDiff * yDiff
    }

    guard denominatorX != 0, denominatorY != 0 else { return 0 }

    return numerator / sqrt(denominatorX * denominatorY)
}

enum DayTime: Int {
    case morning
    case midday
    case afternoon
    case evening
    case night
    case none

    var timeString: LocalizedStringKey {
        switch self {
        case .morning: return "Mostly in the morning"
        case .midday:  return "Mostly at midday"
        case .afternoon: return "Mostly in the afternoon"
        case .evening: return "Mostly in the evening"
        case .night: return "Mostly in the night"
        case .none: return "No time date"
        }
    }
    
    var iconString: String {
        switch self {
        case .morning: return "sun.horizon"
        case .midday:  return "sun.max.fill"
        case .afternoon: return "sun.horizon.fill"
        case .evening: return "moon.haze.fill"
        case .night: return "moon.zzz"
        case .none: return "No time date"
        }
    }
    
    var identifier: Double {
        switch self {
        case .morning: return 1.0
        case .midday: return 2.0
        case .afternoon: return 3.0
        case .evening: return 4.0
        case .night: return 5.0
        case .none: return 6.0
        }
    }
    
    var isDay: Bool {
        switch self {
        case .morning: return true
        case .midday: return true
        case .afternoon: return true
        case .evening: return false
        case .night: return false
        case .none: return false
        }
    }
}

func determineDayTime(for date: Date) -> Double {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.hour], from: date)
    
    if let hour = components.hour {
        switch hour {
        case 6..<12: return DayTime.morning.identifier
        case 12..<15: return DayTime.midday.identifier
        case 15..<18:  return DayTime.afternoon.identifier
        case 18..<21: return DayTime.evening.identifier
        default: return DayTime.night.identifier
        }
    }
    
    return 0.0
}
