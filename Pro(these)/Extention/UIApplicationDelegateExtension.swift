//
//  UIApplicationDelegateExtension.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 11.10.23.
//

import SwiftUI

#if canImport(AppTrackingTransparency) && !os(watchOS)
import AppTrackingTransparency
#endif

extension UIApplicationDelegate {
    func requestTrackingAuthorization() {
            if #available(iOS 14, *) {
                ATTrackingManager.requestTrackingAuthorization { status in
                    switch status {
                    case .authorized:
                        print("[ATTrackingManager] App-Tracking ist erlaubt.")
                    case .denied:
                        print("[ATTrackingManager] App-Tracking wurde abgelehnt.")
                    case .notDetermined:
                        print("[ATTrackingManager] App-Tracking wurde noch nicht festgelegt.")
                    case .restricted:
                        print("[ATTrackingManager] App-Tracking ist eingeschränkt.")
                    @unknown default:
                        print("[ATTrackingManager] Unbekannter Status für App-Tracking.")
                    }
                }
            } else {
                // Vor iOS 14, hier wird der IDFA ohne explizite Erlaubnis verfügbar sein
                print("App-Tracking ist verfügbar (vor iOS 14).")
            }
        }
}
