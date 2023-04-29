//
//  ContentView.swift
//  ProWatchOS Watch App
//
//  Created by Frederik Kohler on 29.04.23.
//

import SwiftUI

// WATCH

struct WatchContentView: View {
    @ObservedObject var timerViewModel = TimerViewModel()

    
    var body: some View {
        NavigationStack {
            TabView{
                StepCounterWatchView()
                    .tabItem {
                        Label("figure.walk", systemImage: "square.and.pencil")
                    }
            }
            .navigationTitle("Pro Prothese")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct WatchContentView_Previews: PreviewProvider {
    static var previews: some View {
        WatchContentView()
    }
}
