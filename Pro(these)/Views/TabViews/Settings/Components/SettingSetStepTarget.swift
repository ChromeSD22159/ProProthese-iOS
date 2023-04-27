//
//  SettingSetStepTarget.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 27.04.23.
//

import SwiftUI

struct SettingSetStepTarget: View {

    @StateObject var appConfig = AppConfig()
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 6) {
            Button("-", action: { reduceSteps(input: appConfig.targetSteps) })
                .frame(width: 20, height: 20)
                .padding()
                .foregroundColor(.white)
                .background(.white.opacity(0.1))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.white, lineWidth: 2)
                )
            
            Spacer()
            
            VStack{
                Text("\(appConfig.targetSteps)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                Label("Zielvorgabe der Täglichen Schritte", image: "prothesis")
                    .font(.body)
                    .fontWeight(.regular)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Button("+", action: { maximizeSteps(input: appConfig.targetSteps) })
                .frame(width: 20, height: 20)
                .padding()
                .foregroundColor(.white)
                .background(.white.opacity(0.1))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.white, lineWidth: 2)
                )
            
        }
        .padding(.all, 15.0)
        .frame(maxWidth: .infinity)
        .background(AppConfig().background.opacity(0.5))
        .cornerRadius(10)
    }
    
    func reduceSteps(input: Int) {
        let newT = input - 500
        appConfig.targetSteps = newT
    }
    
    func maximizeSteps(input: Int) {
        let newT = input + 500
        appConfig.targetSteps = newT
    }
}
