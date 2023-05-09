

import SwiftUI
import HealthKit
import Combine
import Foundation

@main
struct Pro_theseApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    let persistenceController = PersistenceController.shared
    let healthStorage = HealthStorage()
    let pushNotificationManager = PushNotificationManager()
    let stepCounterManager = StepCounterManager()
    let stopWatchManager = StopWatchManager()
    let healthStore = HealthStore()
    let tabManager = TabManager()
    let eventManager = EventManager()
    let liveActivityManager = LiveActivityManager()
    
    @AppStorage("Days") var fetchDays:Int = 7
    @State private var LaunchScreen = true
    init() {
        pushNotificationManager.registerForPushNotifications()
    }
    
    
    var body: some Scene {
        WindowGroup {
            ZStack{
                
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(AppConfig())
                    .environmentObject(TabManager())
                    .environmentObject(healthStorage)
                    .environmentObject(stepCounterManager)
                    .environmentObject(pushNotificationManager)
                    .environmentObject(stopWatchManager)
                    .environmentObject(eventManager)
                    .environmentObject(healthStore)
                    .environmentObject(liveActivityManager)
                    .onChange(of: scenePhase) { newPhase in
                        if newPhase == .active {
                            pushNotificationManager.removeNotificationsWhenAppLoads()
                        } else if newPhase == .inactive {
                            
                        } else if newPhase == .background {
                            print("APP changed to Background")
                            if !AppConfig().PushNotificationDisable {
                                pushNotificationManager.setUpNonPermanentNotifications()
                            }
                        }
                    }
             
                    if LaunchScreen {
                        LaunchScreenView()
                    }

             
            }
            .onAppear{
                stopWatchManager.fetchTimesData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    withAnimation(.easeOut(duration: 2.0)) {
                        LaunchScreen = false
                    }
                })
            }
            
        }
    }
}


/*
 
 extension Publisher where Output: Sequence {
     public func mapArray<Input, Out>(_ transform: @escaping (Input) -> Out) -> Publishers.Map<Self, [Out]> where Output.Element == Input {
         map { $0.map { transform($0) } }
     }
 }
 */
