//
//  SettingManager.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 28.11.23.
//

import SwiftUI
import Alamofire

enum SettingManager {
    
    static func fetchSettings(completion: @escaping (Bool) -> Void) async {
          do {
              // Simulate fetching data asynchronously
              let settingsData = try await fetchData()
              
              // Process the settings data
              
              // Assuming the processing is successful, call the completion handler with true
              completion(settingsData)
          } catch {
              // Handle errors, and call the completion handler with false
              print("Error fetching settings: \(error)")
              completion(false)
          }
    }
    
    private static func fetchData() async throws -> Bool {
        let url = "https://api.frederikkohler.de/api/pro-prothese-setting?populate=settings.items"
        
        var bool: Bool?
        
        AF.request(url).responseDecodable(of: SettingsAPIResponse.self) { response in
            switch response.result {
                case .success(let response):
               
                    if response.data.attributes.settings.isEmpty {
                        print("SETTINGS SERVICE ERROR")
                    } else {
                        
                        let settings = response.data.attributes
                        
                        settings.settings.map({ setting in
                            setting.items.map({ item in
                                
                                if item.title.lowercased().contains("admob") {
                                    guard AppConfig.shared.appState == .prod else {
                                        AppConfig.shared.googleAppOpenAd = GoogleAds.dev
                                        AppConfig.shared.googleInterstitialAds = GoogleAds.dev
                                        print("[SettingsManager]: appState is not in Prod")
                                        return
                                    }
                                    
                                    if item.state {
                                        AppConfig.shared.googleAppOpenAd = GoogleAds.prod
                                        AppConfig.shared.googleInterstitialAds = GoogleAds.prod
                                    } else {
                                        AppConfig.shared.googleAppOpenAd = GoogleAds.dev
                                        AppConfig.shared.googleInterstitialAds = GoogleAds.dev
                                    }
                                    
                                }
                                
                                if item.title.lowercased().contains("change") {
                                    AppConfig.shared.showChangeLog = item.state
                                }
                                
                            })
                        })
                        
                        bool = true
                    }
                case .failure(let error):
                    bool = false
                    print("Fehler bei der Anfrage: \(error)")
            }
        }
        
        return bool ?? false

   }
}









struct SettingsAPIResponse: Codable {
    let data: SettingsData
    let meta: Meta
    
    enum CodingKeys: String, CodingKey {
        case data, meta
    }
}

struct SettingsData: Codable {
    let id: Int
    let attributes: SettingsAttributes
    
    enum CodingKeys: String, CodingKey {
        case id, attributes
    }
}

struct SettingsAttributes: Codable {
    let createdAt: String
    let updatedAt: String
    let locale: String
    let settings: [Setting]
    
    enum CodingKeys: String, CodingKey {
        case createdAt, updatedAt, locale, settings
    }
}

struct Setting: Codable {
    let id: Int
    let __component: String  // Keep __component
    let title: String
    let items: [SettingItem]
    
    enum CodingKeys: String, CodingKey {
        case id, __component, title, items
    }
    
    var component: String {
        return __component
    }
}

struct SettingItem: Codable {
    let id: Int
    let desc: String
    let title: String
    let state: Bool
    
    enum CodingKeys: String, CodingKey {
        case id, desc, title, state
    }
}

struct Meta: Codable {
    // Add Meta properties if needed
}
