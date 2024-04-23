//
//  TextBadge.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 23.09.23.
//

import SwiftUI

struct TextBadge: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    
    var padding: CGFloat? = nil
    
    var text: LocalizedStringKey
    
    var font: Font? = nil
    
    var body: some View {
        Text(text)
            .font(font ?? .caption2.bold())
            .foregroundColor(currentTheme.hightlightColor)
            .padding(padding ?? 5)
            .textCase(.uppercase)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(currentTheme.primary)
                    
            )
            .padding(.bottom, 1)
    }
}

#Preview {
    TextBadge(text: "")
}
