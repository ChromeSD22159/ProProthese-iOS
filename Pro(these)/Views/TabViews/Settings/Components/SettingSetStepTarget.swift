//
//  SettingSetStepTarget.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 27.04.23.
//

import SwiftUI

struct SettingSetStepsTarget: View {

    @StateObject var appConfig = AppConfig()
    
    @EnvironmentObject var themeManager: ThemeManager
    
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    
    @Binding var target: Int
    
    var targets: (min: Int, max: Int, steps: Int) {
        return (min: 1500, max: 49500, steps: 500)
    }
    
    var body: some View {
        
        HStack(alignment: .center, spacing: 6) {
            Button("-", action: { target = target.reduceSteps })
                .frame(width: 20, height: 20)
                .padding(6)
                .foregroundColor(currentTheme.text)
                .background(currentTheme.text.opacity(0.1))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(currentTheme.text, lineWidth: 1)
                )
            
            Spacer()
            
            VStack{
                Text("\(target)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(currentTheme.text)
                
                Label("Daily Steps Goal", image: "figure.prothese")
                    .font(.body)
                    .fontWeight(.regular)
                    .foregroundColor(currentTheme.textGray)
            }
            
            Spacer()
            
            Button("+", action: { target = target.maximizeSteps })
                .frame(width: 20, height: 20)
                .padding(6)
                .foregroundColor(currentTheme.text)
                .background(currentTheme.text.opacity(0.1))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(currentTheme.text, lineWidth: 1)
                )
            
        }
        .padding(.all, 12)
        .frame(maxWidth: .infinity)
        .background(currentTheme.primary.opacity(0.5))
        .cornerRadius(10)
    }
    
    func reduceSteps(input: Int) {
        if appConfig.targetSteps >= targets.min {
            let newT = input - targets.steps
            appConfig.targetSteps = newT
        }
    }

    func maximizeSteps(input: Int) {
        if appConfig.targetSteps <= targets.max {
            let newT = input + targets.steps
            appConfig.targetSteps = newT
        }
    }
}

struct SettingSetFloorTarget: View {

    @StateObject var appConfig = AppConfig()
    
    @EnvironmentObject var themeManager: ThemeManager
    
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    
    var targets: (min: Int, max: Int, steps: Int) {
        (min: 5, max: 50, steps: 5)
    }
    
    @Binding var target: Int

    var body: some View {
        
        HStack(alignment: .center, spacing: 6) {
            Button("-", action: { reduceSteps(input: target) })
                .frame(width: 20, height: 20)
                .padding(6)
                .foregroundColor(currentTheme.text)
                .background(currentTheme.text.opacity(0.1))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(currentTheme.text, lineWidth: 1)
                )
            
            Spacer()
            
            VStack{
                Text("\(target)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(currentTheme.text)
                
                Label( "Daily stair goal", image: "figure.prothese")
                    .font(.body)
                    .fontWeight(.regular)
                    .foregroundColor(currentTheme.textGray)
            }
            
            Spacer()
            
            Button("+", action: { maximizeSteps(input: target)  })
                .frame(width: 20, height: 20)
                .padding(6)
                .foregroundColor(currentTheme.text)
                .background(currentTheme.text.opacity(0.1))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(currentTheme.text, lineWidth: 1)
                )
            
        }
        .padding(.all, 12)
        .frame(maxWidth: .infinity)
        .background(currentTheme.primary.opacity(0.5))
        .cornerRadius(10)
    }
    
    func reduceSteps(input: Int) {
        if appConfig.targetFloors >= targets.min {
            let newT = input - targets.steps
            appConfig.targetFloors = newT
        }
    }

    func maximizeSteps(input: Int) {
        if appConfig.targetFloors <= targets.max {
            let newT = input + targets.steps
            appConfig.targetFloors = newT
        }
    }
}
