//
//  AppExtension.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 11.10.23.
//

import SwiftUI
import Intents
#if canImport(BackgroundTasks) && !os(watchOS)
import BackgroundTasks
#endif

extension App {
    func requestSiriAuthorization() {
        INPreferences.requestSiriAuthorization { status in
            switch status {
            case .authorized:
                print("[Siri] authorization status: Authorized")
            case .denied:
                print("[Siri] authorization status: Denied")
            case .notDetermined:
                print("[Siri] authorization status: Not Determined")
            case .restricted:
                print("[Siri] authorization status: Restricted")
            @unknown default:
                print("[Siri] authorization status: Unknown")
            }
        }
    }
    
    func registerAppBackgroundTask() {
        let backgroundTask = BGAppRefreshTaskRequest(identifier: "refresh")

        do {
            try? BGTaskScheduler.shared.submit(backgroundTask)
            print("[registerAppBackgroundTask] Successfully registered scheduled a background task ")
        }
    }
}
