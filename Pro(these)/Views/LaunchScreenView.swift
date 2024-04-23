//
//  LaunchScreenView.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 09.05.23.
//

import SwiftUI

struct LaunchScreenView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    
    var body: some View {
        ZStack{

            Image("LaunchImage_\(currentTheme.rawValue)V\(Int.random(in: 1...3))")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
                .ignoresSafeArea()
            
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .ignoresSafeArea()
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
