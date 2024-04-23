//
//  GoogleInterstitialAd.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 29.08.23.
//


import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency

final class GoogleInterstitialAd: NSObject, GADFullScreenContentDelegate, ObservableObject {

    var interstitial: GADInterstitialAd?
    
    override init() {
        super.init()
    }
    
    var lastShown: Date {
        let lastShown = AppConfig.shared.googleInterstitialLastShow
        print("[Interstitial AD] last Showed ad: \(lastShown)")
        return lastShown
    }

    func requestInterstitialAds() {
        ATTrackingManager.requestTrackingAuthorization { status in
            guard self.regGuards else {
                return
            }
            
            let request = GADRequest()
            let unitID = "ca-app-pub-5150691613384490/2062248759"
            
            request.scene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            
            GADInterstitialAd.load(withAdUnitID: unitID, request: request, completionHandler: { [self] ad, error in
                if let error = error {
                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                    return
                }
                
                interstitial = ad
                interstitial?.fullScreenContentDelegate = self
                
                print("[Interstitial AD] REQUESTED")
            })
        }
    }
    
    func showAd() {
        guard guards else {
            return
        }

        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene

        let root = windowScene?.windows.last?.rootViewController
        
        if let fullScreenAds = interstitial {
            fullScreenAds.present(fromRootViewController: root!)
            
            AppConfig.shared.googleInterstitialLastShow = Date()

            print("[Interstitial AD] AD is displaying")
        } else {
            print("[Interstitial AD] AD not ready")
        }
    }
    
    var guards: Bool {
        guard AppConfig.shared.googleInterstitialAds != .dev else {
            print("[Interstitial AD] is in DEV")
            return false
        }
        
        guard !AppConfig.shared.hasPro else {
            print("[Interstitial AD] HAS PRO")
            
            return false
        }
        
        guard AppConfig.shared.googleInterstitialLastShow < targetDate.date else {
            print("[Interstitial AD] Last seen before \(targetDate.error) | LAST SHOWED: \(AppConfig.shared.googleInterstitialLastShow)")
            
            let countdown = Calendar.current.component(.second, from: targetDate.date)
            
            print("[Interstitial AD] Next register date: in \(countdown)secs.")
            return false
        }
        
        return true
    }
    
    var regGuards: Bool {
        guard AppConfig.shared.googleInterstitialAds != .dev else {
            print("[Interstitial AD] is in DEV")
            return false
        }
        
        guard !AppConfig.shared.hasPro else {
            print("[Interstitial AD] HAS PRO")
            
            return false
        }
        
        guard AppConfig.shared.googleInterstitialLastShow < targetDate.date else {
            print("[Interstitial AD] Last seen before \(targetDate.error) | LAST SHOWED: \(AppConfig.shared.googleInterstitialLastShow)")
            
            let countdown = Calendar.current.component(.second, from: targetDate.date)
            
            print("[Interstitial AD] Next register date: in \(countdown)secs.")
            return false
        }
        
        guard interstitial == nil else {
            print("[Interstitial AD] Ads already registered")
            return false
        }
        
        return true
    }
    
    @State var tab = 0
    
    var tabGuard: Bool {
        guard tab > 15 else {
            tab += 1
            
            return false
        }
        
        tab = 0
        
        return true
    }
    
    var targetDate: (date: Date, error: String) {
        
        if AppConfig.shared.googleInterstitialAds == .dev || AppConfig.shared.googleInterstitialAds == .debug {
            return (Calendar.current.date(byAdding: .minute, value: -5, to: Date())!, "5 Minutes")
        } else {
            return (Calendar.current.date(byAdding: .minute, value: -5, to: Date())!, "5 Minutes")
        }
        
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("[Interstitial AD] Failed: \(error)")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("[Interstitial AD] Ad dismissed")
    }
    
}

