

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
    let tabManager = TabManager()
    let eventManager = EventManager()
    let cal = MoodCalendar()
    let workoutStatisticViewModel = WorkoutStatisticViewModel()
    let painViewModel = PainViewModel()
    @AppStorage("Days") var fetchDays:Int = 7
    @State private var LaunchScreen = true
    @StateObject private var loginViewModel = LoginViewModel()
    
    init() {
        pushNotificationManager.registerForPushNotifications()
    }
    
    
    var body: some Scene {
        WindowGroup {
            ZStack{
                if loginViewModel.appUnlocked {
                    ContentView(loc: LocationProvider.shared.getLocation())
                        .environment(\.managedObjectContext, persistenceController.container.viewContext)
                        .environmentObject(AppConfig())
                        .environmentObject(TabManager())
                        .environmentObject(healthStorage)
                        .environmentObject(pushNotificationManager)
                        .environmentObject(eventManager)
                        .environmentObject(cal)
                        .environmentObject(workoutStatisticViewModel)
                        .environmentObject(painViewModel)
                        .onChange(of: scenePhase) { newPhase in
                            if newPhase == .active {
                                pushNotificationManager.removeNotificationsWhenAppLoads()
                                
                            } else if newPhase == .inactive {
                            
                            } else if newPhase == .background {
                                print("APP changed to Background")
                                loginViewModel.appUnlocked = false
                                if !AppConfig().PushNotificationDisable {
                                    pushNotificationManager.setUpNonPermanentNotifications()
                                }
                              
                            }
                        }
                
                } else {
                    LoginScreen()
                        .onChange(of: scenePhase) { newPhase in
                            if newPhase == .active {
                                loginViewModel.requestBiometricUnlock(type: .faceID)
                            } 
                        }
                        .environmentObject(loginViewModel)
                }
                
                
             
                if LaunchScreen {
                    LaunchScreenView()
                }

             
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    withAnimation(.easeOut(duration: 2.0)) {
                        LaunchScreen = false
                    }
                })
            }
            
        }
    }
}
