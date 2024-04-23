import SwiftUI
import HealthKit
import Combine
import Foundation
import WidgetKit
import GoogleMobileAds
import CoreData
import StoreKit
import AppTrackingTransparency
import AdSupport
import Intents
import CoreMotion
#if canImport(BackgroundTasks) && !os(watchOS)
import BackgroundTasks
#endif
// IDFA: F8AC6B86-1C4E-4A34-9D1E-8848CC79B13B
// IDFA: F8AC6B00-1C4E-4A34-9D1E-8848CC79B13B


@main
struct Pro_theseApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @Environment(\.scenePhase) var scenePhase
    
    let healthKitManager = HealthStoreProvider()
    var persistenceController = PersistenceController.shared
    @StateObject private var googleInterstitial: GoogleInterstitialAd = GoogleInterstitialAd()
    @ObservedObject private var motionManager = MotionManager()
    @StateObject var healthStorage = HealthStorage()
    @StateObject var pushNotificationManager = PushNotificationManager()
    @StateObject var tabManager = TabManager()
    @StateObject var eventManager = EventManager()
    @StateObject var cal = MoodCalendar()
    @StateObject var workoutStatisticViewModel = WorkoutStatisticViewModel()
    @StateObject var painViewModel = PainViewModel()
    @StateObject var stopWatchProvider = StopWatchProvider()
    @StateObject var stateManager = StateManager()
    @ObservedObject var themeManager = ThemeManager()
    @StateObject var weatherModel = WeatherModel()
    @StateObject var handlerStates = HandlerStates()
    @StateObject var networkMonitor = NetworkMonitor()
    @State private var LaunchScreen = true
    @State var deepLink:URL?
    @StateObject private var loginViewModel = LoginViewModel()

    @StateObject private var entitlementManager: EntitlementManager

    @StateObject private var purchaseManager: PurchaseManager
    
    @StateObject private var appConfig = AppConfig()
    
    @State var notes: [UNNotificationRequest] = []
    
    @State var badgeManager = AppAlertBadgeManager(application: UIApplication.shared)
    
    init() {
        let entitlementManager = EntitlementManager()
        let purchaseManager = PurchaseManager(entitlementManager: entitlementManager)

        self._entitlementManager = StateObject(wrappedValue: entitlementManager)
        self._purchaseManager = StateObject(wrappedValue: purchaseManager)
        
        healthKitManager.setUpHealthRequest(healthStore: healthKitManager.healthStore, readSteps: {
            
        })
    }
    
    let locationProvider = LocationProvider()

    var body: some Scene {
        WindowGroup {
            ZStack{

             
                if LaunchScreen {
                    LaunchScreenView()
                        .environmentObject(themeManager)
                } else {
                    if loginViewModel.appUnlocked || AppConfig.shared.faceID == false {
                        
                        if let defaults = UserDefaults(suiteName: "group.FK.Pro-these-") {
                            ContentView(deepLink: $deepLink)
                                .colorScheme(.dark)
                                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                                .environmentObject(appConfig)
                                .environmentObject(themeManager)
                                .environmentObject(TabManager())
                                .environmentObject(healthStorage)
                                .environmentObject(locationProvider)
                                .environmentObject(pushNotificationManager)
                                .environmentObject(eventManager)
                                .environmentObject(googleInterstitial)
                                .environmentObject(cal)
                                .environmentObject(workoutStatisticViewModel)
                                .environmentObject(painViewModel)
                                .environmentObject(stateManager)
                                .environmentObject(entitlementManager)
                                .environmentObject(purchaseManager)
                                .environmentObject(appDelegate)
                                .environmentObject(handlerStates)
                                .environmentObject(networkMonitor)
                                .environmentObject(motionManager)
                                .defaultAppStorage(defaults)
                                .onChange(of: handlerStates.locationCity, perform: { _ in
                                    weatherModel.fetchWeather(city: handlerStates.locationCity)
                                })
                                .onAppear(perform: upDateLocation )
                                .onChange(of: scenePhase) { newPhase in
                                    if newPhase == .active {
                                        Task {
                                            await onOpenApp()
                                        }
                                    } else if newPhase == .inactive {
                                        WidgetCenter.shared.reloadAllTimelines()
                                    } else if newPhase == .background {
                                        print("APP changed to Background \(Date())")
                                       
                                        motionManager.stepPedometerDataInBackground()
                                        
                                        loginViewModel.appUnlocked = false
                                        
                                        let printNotificationsRegistering = true
                                        
                                        AppNotifications.setMoodReminderNotifications(printConsole: printNotificationsRegistering)
                                        AppNotifications.setGoodMorningNotifications(printConsole: printNotificationsRegistering)
                                        AppNotifications.setComebackNotifications(delay: Int.random(in: (6*60*60)...(8*60*60)), printConsole: printNotificationsRegistering) // 6h - 8h
                                        AppNotifications.setPushNotificationWeeklyReport(notes: notes, debug: printNotificationsRegistering)
                                        
                                        registerAppBackgroundTask()
                                        
                                        Task {
                                            await StepBadgeManager.updateHandler()
                                        }
                                        
                                        WidgetCenter.shared.reloadAllTimelines()
                                    }
                                }
                                .task {
                                   await purchaseManager.updatePurchasedProducts()
                                }
                            
                        } else {
                            Text("Error loading AppGroup")
                        }

                    } else {
                        LoginScreen()
                            .environmentObject(themeManager)
                            .onChange(of: scenePhase) { newPhase in
                                if newPhase == .active {
                                    loginViewModel.requestBiometricUnlock(type: .faceID)
                                }
                            }
                            .onAppear(perform: upDateLocation )
                            .environmentObject(loginViewModel)
                    }
                }

             
            }
            .onAppear{
                Task {
                    await onOpenApp()
                }
            }
            
        }
        .backgroundTask(.appRefresh("refresh"), action: {            
            if AppFirstLaunchManager.requestMissingMessage {
                await pushNotificationManager.MissingNotification()
                AppConfig.shared.requestMissingMessageDate = Date()
            }

            WidgetCenter.shared.reloadAllTimelines()
            
           // await motionManager.stepPedometerDataInBackground()
            
            // register the next BG Task
            registerAppBackgroundTask()
        })
    }

    func removeNotifications() {
        loadNotifications()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            AppNotifications.removeNotifications(keyworks: ["MOOD_REMINDER", "MOOD_GOOD_MORNING", "COMEBACK_REMINDER", "MISSING_REMINDER", "REPORT_A"], notes: notes)
        })
    }
    
    func loadNotifications() {
        PushNotificationManager().getAllPendingNotifications(debug: false) { note in
            DispatchQueue.main.async {
                notes.append(note)
                //print("Pro_theseApp: \(note.identifier)")
                //print("Pro_theseApp: \(note.content.title)")
                //print("Pro_theseApp: \(note.content.body) \(note.content)")
            }
        }
    }
    
    func onOpenApp() async {
        await SettingManager.fetchSettings(completion: {_ in
            
        })
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            GoogleAppOpenAd().requestAppOpenAd()
        })
        
        
        
        INPreferences.requestSiriAuthorization({status in
            // Handle errors here
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
            withAnimation(.easeOut(duration: 2.0)) {
                LaunchScreen = false
            }
        })
        
        removeNotifications()
        
        if WeeklyProgressReportManager.requestCoreDataHandler {

        }
        
        requestSiriAuthorization()
        
        weatherModel.fetchWeather(city: handlerStates.locationCity)

        AppFirstLaunchManager.requestFirstLaunch(debug: false)
        AppFirstLaunchManager.updateLaunchDate()

        let deviceLanguage = Bundle.main.preferredLocalizations.first
        LanguageController.shared.setLanguage(deviceLanguage!)
        
        if !self.appConfig.hasPro {
            self.appConfig.faceID = false
            self.appConfig.PushNotificationDailyMoodRemembering = true
            self.appConfig.PushNotificationComebackReminder = true
            self.appConfig.PushNotificationGoodMorning = true
        }
    }
    
    func upDateLocation() {
        locationProvider.startMonitoring()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            locationProvider.stopMonitoring()
        })
    }

}
