//
//  AuroraBackground.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 10.10.23.
//

import SwiftUI

struct AuroraBackground<Content:View>: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    
    var content: () -> Content
    
    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }
    
    var body: some View {
        ZStack(content: {
            currentTheme.gradientBackground(nil).ignoresSafeArea()
            
            FloatingClouds(speed: 1.0, opacity: 0.5, currentTheme: currentTheme)
                .opacity(0.4)
            
            content()
        })
    }
}
