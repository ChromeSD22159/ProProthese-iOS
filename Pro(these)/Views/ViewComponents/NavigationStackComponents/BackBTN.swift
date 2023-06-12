//
//  BackBTN.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 27.04.23.
//

import SwiftUI

struct BackBTN: View {
    var size: CGFloat
    var foreground: Color?
    var background: Color?
    
    var body: some View {
        ZStack{
            ZStack {
                Image(systemName: "chevron.left.circle")
                    .foregroundColor(foreground ?? .white)
                    .font(.system(size: size))
                
            }.background(
                GlassBackGround(width: size, height: size, color: background ?? .black)
                    .shadow(color: .black, radius: size, x: 2, y: 2)
            )
            
            
        }
    }
}
