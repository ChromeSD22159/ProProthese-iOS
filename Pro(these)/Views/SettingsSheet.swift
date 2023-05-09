//
//  SettingsSheet.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 05.05.23.
//

import SwiftUI

struct SettingsSheet: View {
    @EnvironmentObject var appConfig: AppConfig
    @EnvironmentObject var tabManager: TabManager
    var body: some View {
        NavigationView {
            ZStack {
                appConfig.backgroundGradient
                    .ignoresSafeArea()
            
                VStack{
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 20) {
                            
                            Spacer()

                            VStack(alignment: .leading, spacing: 20){
                                // MARK: - Personal Settings
    
                                NavigateTo( {
                                    StackLink(icon: "figure.walk", buttonText: "Persönliche Einstellungen", foregroundColor: AppConfig().foreground)
                                }, {
                                    PersonalDeteilsView(titel: "Persönliche Einstellungen")
                                })
                                
                                // MARK: - Mapped Settings
                                ForEach(Settings.items, id: \.id) { setting in
                                    NavigateTo( {
                                        StackLink(icon: "figure.walk", buttonText: setting.titel, foregroundColor: AppConfig().foreground)
                                    }, {
                                        SettingsDeteilsView(titel: setting.titel, Options: setting.options)
                                    })
                                }
                                
                                
                                
                                Spacer()
                            }
                            .padding(.top, 25)
                        
                            Spacer()
                        }
                    }
                }
            }
        }
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
    }
    
    @ViewBuilder
    func DetailView(title: String, backgroundColor: LinearGradient, foregroundColor: Color) -> some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20){
                    HStack{
                        Text(title)
                            .foregroundColor(.white)
                    }
                    
                }
                .padding(.top, 80)
            }
            .ignoresSafeArea()
            .padding(.horizontal)
        }
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
            .background(AppConfig().backgroundLabel)
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
    
    @ViewBuilder
    func StackLink(icon: String, buttonText: String, foregroundColor: Color) -> some View {
        HStack {
            HStack(spacing: 10){
                VStack(){
                    Image(systemName: icon)
                        .frame(width: 20, height: 20)
                        .foregroundColor(.white)
                }
                .padding(10)
                .background(.white.opacity(0.1))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.white, lineWidth: 2)
                        
                )
                
                Text(buttonText)
                    
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(foregroundColor)
            .background(AppConfig().backgroundLabel)
            .overlay(
                   RoundedRectangle(cornerRadius: 10)
                   .stroke(lineWidth: 2)
                   .stroke(.white.opacity(0.05))
           )
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
    }
}

struct SettingsSheet_Previews: PreviewProvider {
    static var previews: some View {
        SettingsSheet()
    }
}
