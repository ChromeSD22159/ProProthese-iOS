//
//  ProWatchOSApp.swift
//  ProWatchOS Watch App
//
//  Created by Frederik Kohler on 29.04.23.
//

import SwiftUI

@main
struct ProWatchOS_Watch_AppApp: App {
    var body: some Scene {
        let healthStorage = HealthStorage()
        let stepCounterManager = StepCounterManager()
        let healthStore = HealthStore()

        WindowGroup {
            WatchContentView()
                .environmentObject(AppConfig())
                .environmentObject(healthStorage)
                .environmentObject(stepCounterManager)
                .environmentObject(healthStore)
        }
    }
}

/*
 VStack {
             Text("Adjust value")
             Slider(
                 value: $value,
                 in: 0...3,
                 step: 1,
                 minimumValueLabel: Text("-"),
                 maximumValueLabel: Text("+")
             ) {}
             .buttonStyle(PlainButtonStyle())
             .background(Color.clear)
             .accentColor(.green)
             
             Text("VALUE")
                 .foregroundColor(.white)
         }
         .padding()
         .background(Color(red: 0.1, green: 0.2, blue: 0.3, opacity: 1.0))
         .cornerRadius(10.0)
 */
