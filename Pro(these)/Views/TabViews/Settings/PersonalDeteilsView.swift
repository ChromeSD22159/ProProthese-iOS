//
//  PersonalDeteilsView.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 27.04.23.
//

import SwiftUI
import WidgetKit

struct PersonalDeteilsView: View {
    var titel: LocalizedStringKey
    @EnvironmentObject var themeManager: ThemeManager

    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    
    @StateObject var appConfig = AppConfig()
    
    @EnvironmentObject var entitlementManager: EntitlementManager
    
    @Binding var username: String
    
    @Binding var amputationDate: Date
    
    @Binding var prosthesisDate: Date

    @Binding var targetSteps: Int
    
    @Binding var targetFloors: Int
    
    var body: some View {
        ZStack {
            currentTheme.gradientBackground(nil)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 10){
                    HStack{
                        Text(titel)
                            .foregroundColor(currentTheme.text)
                    }
                    .padding(.bottom)
                    
                    SettingName(image: "person.fill", info: "Change the display name.", color: currentTheme.primary, username: $username)

                    SettingDate(image: "person.fill", info: LocalizedStringKey("Amputation day."), color: currentTheme.primary, date: $amputationDate)
                        .zIndex(2)
                    
                    SettingDate(image: "person.fill", info: LocalizedStringKey("First day with prosthesis."), color: currentTheme.primary, date: $prosthesisDate)
                        .zIndex(1)
                    
                    SettingSetStepsTarget(target: AppConfig.shared.$targetSteps)
                    
                    SettingSetFloorTarget(target: AppConfig.shared.$targetFloors)

                    // In-App-ABO
                    
                    VStack(alignment: .leading){
                        Toggle("Haptic Feedback", isOn: appConfig.$hapticFeedback).disabled(appConfig.hasUnlockedPro)
                           .disabled(!entitlementManager.hasPro)
                        Toggle("Hide information", isOn: appConfig.$hideInfomations)
                           .disabled(!entitlementManager.hasPro)
                    }
                    .frame(maxWidth: .infinity ,alignment: .leading)
                    .padding(.all, 15.0)
                    .frame(maxWidth: .infinity)
                    .background(currentTheme.primary.opacity(0.5))
                    .cornerRadius(10)
                    
                    Spacer()
                    
                    copyright(isAuthenticating: .constant(false), showDebugField: .constant(false), password: .constant(""))
                  
                }
                .padding(.top, 80)
            }
            .ignoresSafeArea()
            .padding(.horizontal)
        }
        .onAppear {
            username = appConfig.username
            amputationDate = appConfig.amputationDate
            prosthesisDate = appConfig.prosthesisDate
        }
        .onChange(of: appConfig.hasUnlockedPro, perform: { value in
            WidgetCenter.shared.reloadAllTimelines()
            print(value)
        })
    }
    
    @ViewBuilder
    func Link(buttonText: String, foregroundColor: Color) -> some View {
        HStack {
            HStack{
                Text(buttonText)
                    .foregroundColor(foregroundColor)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(currentTheme.labelBackground(nil))
            .overlay(
                   RoundedRectangle(cornerRadius: 10)
                   .stroke(lineWidth: 2)
                   .stroke(foregroundColor)
           )
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 50)
    }
}
