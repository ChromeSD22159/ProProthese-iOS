//
//  ContentView.swift
//  ProWatchOS Watch App
//
//  Created by Frederik Kohler on 29.04.23.
//

import SwiftUI
import WatchKit

struct WatchContentView: View {
    @EnvironmentObject private var workoutManager: WorkoutManager
    var body: some View {
        NavigationStack {
            TabView{

                ChartView()
                    .tabItem {
                        Label("Chart", systemImage: "chart.bar.fill")
                    }
                    .navigationTitle("Pro Prothese")
                
                FitnessView()
                    .tabItem {
                        Label("Tracking", systemImage: "figure.walk")
                    }
                    .navigationTitle("Pro Prothese Workout")
                
                if workoutManager.running {
                    NowPlayingView()
                        .tabItem {
                            Label("Now Playing", systemImage: "play")
                        }
                        .navigationTitle("Pro Prothese Workout")
                }
                
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}


struct WatchContentView_Previews: PreviewProvider {
    static var previews: some View {
        WatchContentView()
            .environment(\.locale, Locale(identifier: "de"))
    }
}
