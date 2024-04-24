//
//  GoogleBannerView.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 23.04.24.
//

import SwiftUI
import GoogleMobileAds

struct AdBannerView: UIViewRepresentable {

    func makeUIView(context: Context) -> GADBannerView {
        let banner = GADBannerView(adSize: GADAdSizeBanner)
        
        // Hier musst du deinen AdMob AdUnitID setzen
        banner.adUnitID = "ca-app-pub-5150691613384490/1993131842"
        banner.rootViewController = UIApplication.shared.windows.first?.rootViewController
        banner.load(GADRequest())
        
        banner.delegate = context.coordinator
        
        return banner
    }
    
    func updateUIView(_ uiView: GADBannerView, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, GADBannerViewDelegate {
        var parent: AdBannerView
        
        init(_ parent: AdBannerView) {
            self.parent = parent
        }
        
        func bannerView(_ bannerView: GADBannerView, didFailToReceiveAdWithError error: Error) {
            print("Ad failed to load with error: \(error.localizedDescription)")
        }
        
        func bannerViewDidReceiveAd(_ bannerView: GADBannerView) {
            print("Ad successfully loaded")
        }
    }
}
