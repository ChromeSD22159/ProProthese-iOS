//
//  ProFeature.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 26.09.23.
//

import SwiftUI


struct ProFeature {
    var id = UUID()
    var icon: String? = nil
    var iconColor: Color? = nil
    var name: LocalizedStringKey
    var basic: Bool
    var premium: Bool? = false
    var trail: Bool? = true
    var iconImage: String = "seal"
    
    var featureIcon: some View {
        
        guard let icon = self.icon else {
            return AnyView(Image(systemName: "checkmark.seal.fill").foregroundColor(self.iconColor ?? .white))
        }
        
        return AnyView(Image(systemName: icon == "" ? "checkmark.seal.fill" : icon).foregroundColor(self.iconColor ?? .white))

    }
    
    var imageIconTrail: String {
        return self.trail ?? true ? "checkmark.seal" : "xmark.seal"
    }
    
    var imageIconBasic: String {
        return self.basic ? "checkmark.seal" : "xmark.seal"
    }
    
     var imageIconPremium: String {
        return "checkmark.seal"
    }
    
    var iconColorTrail: Color {
        return self.trail ?? true ? .green : .red
    }
    
    var iconColorBasic: Color {
        return self.basic ? .green : .red 
    }
    
    var iconColorPremium: Color {
        return .green
    }
}
