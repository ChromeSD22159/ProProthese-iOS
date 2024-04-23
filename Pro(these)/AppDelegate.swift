//
//  AppDelegate.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 16.10.23.
//

import SwiftUI
import GoogleMobileAds
import CoreMotion
import AppTrackingTransparency
import WidgetKit
import UserNotifications
import OneSignalFramework

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, ObservableObject {
    
    @StateObject var handler = HandlerStates()
    
    @ObservedObject private var motionManager = MotionManager()
    
    let healthKitManager = HealthStoreProvider()

    let pedometer = CMPedometer()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        requestTrackingAuthorization()
        
        
        if #available(iOS 14, *) {
            
            ATTrackingManager.requestTrackingAuthorization { status in
                if !AppConfig.shared.hasPro {
                  if AppConfig.shared.adsDebug {
                        GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "550578b8f99033c15cec59b88b2e9249" ]
                    } else {
                        GADMobileAds.sharedInstance().start(completionHandler: nil)
                    }
                }
            }
        } else {
            // Vor iOS 14, hier wird der IDFA ohne explizite Erlaubnis verfügbar sein
            print("App-Tracking ist verfügbar (vor iOS 14).")
            if !AppConfig.shared.hasPro {
              if AppConfig.shared.adsDebug {
                    GADMobileAds.sharedInstance().requestConfiguration.testDeviceIdentifiers = [ "550578b8f99033c15cec59b88b2e9249" ]
                } else {
                    GADMobileAds.sharedInstance().start(completionHandler: nil)
                }
            }
        }
        
        /* TEST */
        UNUserNotificationCenter.current().delegate = self
        
        UIApplication.shared.registerForRemoteNotifications()
        
        WidgetCenter.shared.reloadAllTimelines()
          
        // OneSignal initialization
        OneSignal.initialize("4e5d8b05-bfd4-4e17-b2e0-092020e4c89c", withLaunchOptions: launchOptions)
          
        // requestPermission will show the native iOS notification permission prompt.
        // We recommend removing the following code and instead using an In-App Message to prompt for notification permission
        OneSignal.Notifications.requestPermission({ accepted in
            print("User accepted notifications: \(accepted)")
        }, fallbackToSettings: true)
        
        return true
    }
    
    // notification when app is active
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        UNUserNotificationCenter.current().delegate = self

        print("willPresent ID: \(userInfo)")
        
        if let firstValue = userInfo.map({ $0.value }).first as? String, !firstValue.isEmpty {
            HandlerStates.shared.msgDeepLink = firstValue
        } else {
            HandlerStates.shared.msgDeepLink = ""
        }
        
        if notification.request.identifier == "NEW_REPORT_AVAIBLE" {
            
            if WeeklyProgressReportManager.requestCoreDataHandler {

            }
        }
    }

    // notification when app is in background
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        UNUserNotificationCenter.current().delegate = self
        
        let userInfo = response.notification.request.content.userInfo
        
        if let firstValue = userInfo.map({ $0.value }).first as? String, !firstValue.isEmpty {
            HandlerStates.shared.msgDeepLink = firstValue
        } else {
            HandlerStates.shared.msgDeepLink = ""
        }
        
        if HandlerStates.shared.msgDeepLink as String == Tab.pain.rawValue {
            HandlerStates.shared.isPainSheetPresentedByNotification = true
        }
        
        if HandlerStates.shared.msgDeepLink == Tab.feeling.rawValue {
            HandlerStates.shared.isMoodSheetPresentedByNotification = true
        }
        
        if HandlerStates.shared.msgDeepLink == "LINER" {
            HandlerStates.shared.isLinerSheetPresentedByNotification = true
        }
        
        if response.notification.request.identifier == "NEW_REPORT_AVAIBLE" {
            // Führe hier deine gewünschte Funktion aus
            // Zum Beispiel:
            
            if WeeklyProgressReportManager.requestCoreDataHandler {

            }
        }
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
         let sceneConfig: UISceneConfiguration = UISceneConfiguration(name: nil, sessionRole: connectingSceneSession.role)
         sceneConfig.delegateClass = SceneDelegate.self
         return sceneConfig
     }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
       // Handle any background URL session events if needed
        print("[BGTASK IN DELEGATE]")
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(deviceToken.reduce("", { $0 + String(format: "%02X", $1) }))
        let _ = deviceToken.reduce("", { $0 + String(format: "%02X", $1) })
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
       // Try again later.
    }
    
}
