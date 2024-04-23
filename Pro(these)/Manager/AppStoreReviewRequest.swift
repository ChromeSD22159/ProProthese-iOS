//
//  AppStoreReviewRequest.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 09.08.23.
//

import SwiftUI
import StoreKit

enum AppStoreReviewRequest {
    
    static let threehold = 10
    
    @AppStorage("runsSinceLastRequest", store: AppConfig.store) static var runsSinceLastRequest = 0
    
    @AppStorage("storedVersion", store: AppConfig.store) static var storedVersion = ""
    
    @AppStorage("storedVersionStartApp", store: AppConfig.store) static var storedVersionStartApp = ""
    
    @AppStorage("showedAppStoreReview", store: AppConfig.store) static var showedAppStoreReview: Bool = false
    
    @AppStorage("showedAppStoreReviewInShopSheet", store: AppConfig.store) static var showedAppStoreReviewInShopSheet: Date = Calendar.current.date(byAdding: .day, value: -3, to: Date())!
    
    @AppStorage("showedAppStoreReviewDate", store: AppConfig.store) static var showedAppStoreReviewDate: Date = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
    
    @AppStorage("showedAppStoreReviewDateAppStart", store: AppConfig.store) static var showedAppStoreReviewDateAppStart: Date = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
    
    static var requestReviewHandlerWithoutLimits: Bool {
        guard showedAppStoreReviewInShopSheet < Calendar.current.date(byAdding: .day, value: -2, to: Date())! else {
            print("[requestReviewHandler] last show not more them 2 days")
            return false
        }
        
        AppStoreReviewRequest.showedAppStoreReviewInShopSheet = Date()
        
        return true
    }
    
    static var requestReviewHandlerStartApp: Bool {
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        
        guard Date() > AppTrailManager.twoDayBeforeEndFreeTrail else {
            
            if AppConfig.shared.appState == .dev || AppConfig.shared.appState == .debug {
                print("[requestReviewHandlerStartApp] Dont Show Requestview in Trail")
            }
            
            runsSinceLastRequest = 0
            return false
        }
        
        guard storedVersionStartApp != appVersion else {
            if AppConfig.shared.appState == .dev || AppConfig.shared.appState == .debug {
                print("[requestReviewHandlerStartApp] theres no updates since Last Request")
            }
            
            runsSinceLastRequest = 0
            return false
        }
       
        guard runsSinceLastRequest >= 10 else {
            runsSinceLastRequest += 1
            print("[requestReviewHandlerStartApp] threehold is under \(threehold)")
            return false
        }
        
        guard AppStoreReviewRequest.showedAppStoreReviewDateAppStart < Calendar.current.date(byAdding: .day, value: -30, to: Date())! else {
            print("[requestReviewHandlerStartApp] last show not more them 30 days")
            return false
        }
        
        if AppConfig.shared.appState == .dev || AppConfig.shared.appState == .debug {
            print("[requestReviewHandlerStartApp] theres a new Version avaible to make a request for this version")
        }
        
        storedVersionStartApp = appVersion
        runsSinceLastRequest = 0
        AppStoreReviewRequest.showedAppStoreReviewDateAppStart = Date()
        return true
    }
    
    static var requestReviewHandler: Bool {
        let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String
        
        guard Date() > AppTrailManager.twoDayBeforeEndFreeTrail else {
            
            if AppConfig.shared.appState == .dev || AppConfig.shared.appState == .debug {
                print("[requestReviewHandler] Dont Show Requestview in Trail")
            }
            
            runsSinceLastRequest = 0
            return false
        }
        
        guard storedVersion != appVersion else {
            if AppConfig.shared.appState == .dev || AppConfig.shared.appState == .debug {
                print("[requestReviewHandler] theres no updates since Last Request")
            }
            
            runsSinceLastRequest = 0
            return false
        }
       
        guard runsSinceLastRequest >= threehold else {
            runsSinceLastRequest += 1
            print("[requestReviewHandler] threehold is under \(threehold)")
            return false
        }
        
        guard lastShowedRequestMoreThem14Days else {
            print("[requestReviewHandler] last show not more them 20 days")
            return false
        }
        
        if AppConfig.shared.appState == .dev || AppConfig.shared.appState == .debug {
            print("[requestReviewHandler] theres a new Version avaible to make a request for this version")
        }
        
        storedVersion = appVersion
        runsSinceLastRequest = 0
        AppStoreReviewRequest.showedAppStoreReviewDate = Date()
        return true
    }
    
    private static var lastShowedRequestMoreThem14Days: Bool {
        if AppStoreReviewRequest.showedAppStoreReviewDate < Calendar.current.date(byAdding: .day, value: -14, to: Date())! {
            return true
        } else {
            return false
        }
    }
}
