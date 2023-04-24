//
//  AppConfig.swift
//  Pro Prothese
//
//  Created by Frederik Kohler on 23.04.23.
//

import SwiftUI
import Combine
import Foundation

class AppConfig: ObservableObject {
    let minVersion: String = "0.0.1"
    
    
    var background          = Color(red: 32/255, green: 40/255, blue: 63/255)
    var foreground          = Color(red: 167/255, green: 178/255, blue: 210/255)
    var backgroundLabel     = LinearGradient(colors: [Color(red: 32/255, green: 40/255, blue: 63/255)], startPoint: .top, endPoint: .bottom)
    var backgroundGradient  = LinearGradient(colors: [Color(red: 32/255, green: 40/255, blue: 63/255), Color(red: 4/255, green: 5/255, blue: 8/255)], startPoint: .top, endPoint: .bottom)
    
    
    var ChartBarIsShowing           = false
    var ChartLineDistanceIsShowing  = false
    var ChartLineStepsIsShowing     = true
}

