//
//  ContentView.swift
//  Pro Prothese
//
//  Created by Frederik Kohler on 23.04.23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @EnvironmentObject private var tabManager: TabManager
    @EnvironmentObject private var healthStore: HealthStorage
    @State var activeTab: Tab = .step
    var body: some View {
        
        NavigationView {
            ZStack {
                AppConfig().backgroundGradient
                    .ignoresSafeArea()
                
                CircleAnimationInBackground(delay: 1, duration: 2)
                    .opacity(0.2)
                    .ignoresSafeArea()
                
                VStack(){
                    
                    switch activeTab {
                    case .step: StepCounterView()
                    case .timer: StopWatchView()
                    //case .map: LocationTracker()
                    case .event: Events()
                    //case .more: MoreView()
                    }
                    
                    TabStack(activeTab: $activeTab)
                        
                }
                .foregroundColor(AppConfig().foreground)
            }
        }
        .sheet(isPresented: $tabManager.isSettingSheet, content: {
            SettingsSheet()
        })
        .onOpenURL{ url in
            activeTab = url.tabIdentifier ?? .step
        }
        .onAppear{
            activeTab = AppConfig().entrySite
        }
    }
}
