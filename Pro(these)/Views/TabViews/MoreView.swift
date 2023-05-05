//
//  NavigationStackView.swift
//  Pro Prothese
//
//  Created by Frederik Kohler on 23.04.23.
//

import SwiftUI

struct MoreView: View {
    @EnvironmentObject var app: AppConfig
    @EnvironmentObject private var tabManager: TabManager
    
    var body: some View {
        ZStack {
           
            AppConfig().backgroundGradient
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    
                    Spacer()
                    
                    ForEach(MoreViewList.items, id: \.id) { items in
                        NavigateTo( {
                            Link(buttonText: items.titel, foregroundColor: items.foregroundColor)
                        }, {
                            DetailView(title: items.titel, backgroundColor: items.backgroundGradient, foregroundColor: items.foregroundColor)
                        })
                    }
                    
                    // SETTINGS
                    NavigateToWithStack( {
                        Link(buttonText: "Einstellungen", foregroundColor: AppConfig().foreground)
                    }, {
                        VStack(alignment: .leading, spacing: 20){
                            // MARK: Personal Settings
                            
                            Picker("Startseite", selection: tabManager.$startTab) {
                                Text("Step").tag(Tab.step)
                                Text("StopWatch").tag(Tab.timer)
                                Text("Map").tag(Tab.map)
                                Text("Event").tag(Tab.event)
                                //Text("Mehr").tag(Tab.more)
                            }
                            
                            Picker("Startseite", selection: tabManager.$startTab) {
                                ForEach(Tab.allCases) { tab in
                                    Text(tab.rawValue.capitalized)
                                }
                            }
                            
                            NavigateTo( {
                                StackLink(icon: "figure.walk", buttonText: "Persönliche Einstellungen", foregroundColor: AppConfig().foreground)
                            }, {
                                PersonalDeteilsView(titel: "Persönliche Einstellungen")
                            })
                            
                            // MARK: Mapped Settings
                            ForEach(Settings.items, id: \.id) { setting in
                                NavigateTo( {
                                    StackLink(icon: "figure.walk", buttonText: setting.titel, foregroundColor: AppConfig().foreground)
                                }, {
                                    SettingsDeteilsView(titel: setting.titel, Options: setting.options)
                                })
                            }
                            
                            
                            
                            Spacer()
                        }
                        .padding(.top, 100)
                    })
                
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
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


