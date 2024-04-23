//
//  GoogleAppStart.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 29.08.23.
//

import SwiftUI
import GoogleMobileAds
import AppTrackingTransparency

final class GoogleAppOpenAd: NSObject, GADFullScreenContentDelegate, Observable {
   var appOpenAd: GADAppOpenAd?
   var loadTime = Date()
   
   func requestAppOpenAd() {
       ATTrackingManager.requestTrackingAuthorization { status in
           guard !AppConfig.shared.hasPro else {
               print("[OPEN AD] HAS PRO")
               return
           }
           
           guard AppConfig.shared.googleAppOpenAd != .dev else {
               print("[OPEN AD] DEV MODE")
               return
           }
           
           guard GoogleAppStartrequest.requestHandler else {
               print("[OPEN AD] HANDLER REQUEST FAILD")
               return
           }
           
           guard self.appOpenAd == nil else {
               print("[OPEN AD] Already loaded")
               return
           }
           
           print("[OPEN AD] REQUESTED")
     
           let request = GADRequest()

           GADAppOpenAd.load(withAdUnitID: GoogleAppStartrequest.requestType ,
                             request: request,
                             orientation: UIInterfaceOrientation.portrait,
                             completionHandler: { (appOpenAdIn, _) in
                                    self.appOpenAd = appOpenAdIn
                                    self.appOpenAd?.fullScreenContentDelegate = self
                                    self.loadTime = Date()
                                    print("[OPEN AD] Ad is loaded")
                                    
                                       DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                           self.tryToPresentAd()
                                       }
                             })
       }
   }
   
   func tryToPresentAd() {
       
       guard GoogleAppStartrequest.requestHandler else {
           return
       }
       
       if let gOpenAd = self.appOpenAd {
           
           let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
           
           gOpenAd.present(fromRootViewController: (windowScene?.windows.last?.rootViewController)!)
           
           AppConfig.shared.googleAppOpenAdLastShow = Date()
       } 
   }

   func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
       print("[OPEN AD] Failed: \(error)")
   }
   
   func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
       print("[OPEN AD] Ad dismissed")
   }
}


enum GoogleAppStartrequest {
    static var requestHandler: Bool {
        
        guard AppConfig.shared.googleAppOpenAd != .dev else {
            print("[OPEN AD] is DEV")
            return false
        }
        
        guard AppConfig.shared.googleAppOpenAdLastShow < targetDate.date else {
            print("[OPEN AD] Last seen before \(targetDate.error)")
            return false
        }

        return true
    }
    
    static var targetDate: (date: Date, error: String) {
        
        if AppConfig.shared.googleAppOpenAd == .dev || AppConfig.shared.googleAppOpenAd == .debug {
            return (Calendar.current.date(byAdding: .minute, value: -1, to: Date())!, "1 minute")
        } else {
           return (Calendar.current.date(byAdding: .hour, value: -6, to: Date())!, "6 Hours")
        }
        
    }
    
    static var testAd = "ca-app-pub-3940256099942544/3419835294"
    static var prodAd = "ca-app-pub-5150691613384490/5456422024"
    
    static var requestType: String {
        switch AppConfig.shared.googleAppOpenAd {
        case .debug: return self.testAd
        case .dev: return self.testAd
        case .prod: return self.prodAd
        }
    }
}

