//
//  WorkOutEntryView.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 19.05.23.
//

import SwiftUI

struct WorkOutEntryView: View {
    @EnvironmentObject var tabManager: TabManager
    @EnvironmentObject var workoutStatisticViewModel: WorkoutStatisticViewModel
    @EnvironmentObject var cal: MoodCalendar
    @EnvironmentObject var entitlementManager: EntitlementManager
    @EnvironmentObject var appConfig: AppConfig
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var googleInterstitial: GoogleInterstitialAd
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    
    @StateObject var healthStore = HealthStoreProvider()
    
    @State var stepCount: Double = 0
    @State var distanceCount: Double = 0
    @State var workoutSeconds: Double = 0
    
    @State var snapsheet: Bool = false
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                currentTheme.gradientBackground(nil).ignoresSafeArea()
                
                VStack {
                    FloatingClouds(speed: 1.0, opacity: 0.5, currentTheme: currentTheme)
                        .opacity(0.5).ignoresSafeArea()
                        .frame(height: proxy.size.height / 3)
                    
                    Spacer()
                }
                
                ScrollView(showsIndicators: false, content: {
                    VStack(alignment: .leading, spacing: 20) {
                        // MARK: - Page Header
                        Header("Your statistics")
                        
                        newStepPreview(snapsheet: $snapsheet)
                    }
                })
                
                
            }
            .onAppear{
                healthStore.queryDayCountbyType(date: Date(), type: .stepCount) { steps in
                    DispatchQueue.main.async {
                        self.stepCount = steps
                    }
                }
                healthStore.queryDayCountbyType(date: Date(), type: .distanceWalkingRunning) { steps in
                    DispatchQueue.main.async {
                        self.distanceCount = steps
                    }
                }
                healthStore.getWorkoutsByDate(date: Date(), workout: .default(), completion: { seconds in
                    DispatchQueue.main.async {
                        self.workoutSeconds = seconds
                    }
                })
            }
        }
    }
    
   
    
    @ViewBuilder
    func Header(_ text: LocalizedStringKey) -> some View {
        HStack{
            Spacer()
            
            Text(text)
                .foregroundColor(currentTheme.text)
            
            Spacer()
            
            Button(action: {
                snapsheet.toggle()
            }, label: {
                HStack {
                    Image(systemName: "square.and.arrow.up")
                        .padding(10)
                        .font(.title3)
                        .foregroundColor(currentTheme.text)
                }
            })
        }
        .padding(.top, 10)
        .padding(.horizontal)
    }
}
