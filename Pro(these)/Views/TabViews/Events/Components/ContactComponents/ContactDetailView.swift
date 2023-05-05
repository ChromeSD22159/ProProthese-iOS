//
//  ContactDetailView.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 04.05.23.
//

import SwiftUI

struct ContactDetailView: View {
    @EnvironmentObject var appConfig: AppConfig
    var contact: Contact
    var iconColor: Color
    var body: some View {
        ZStack {
            appConfig.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack{
                    HStack{
                        Text(contact.name ?? "Unbekannter Name")
                            .foregroundColor(appConfig.fontColor)
                    }
                    .padding(.top, 25)
                    
                    HStack(spacing: 25) {
                        ZStack{
                            Circle()
                                .strokeBorder(appConfig.fontColor, lineWidth: 1)
                                .frame(width: 50, height: 50)
                                .padding()
                            
                            Circle()
                                .fill(appConfig.fontColor.opacity(0.05))
                                .frame(width: 45, height: 45)
                                .padding()
                            
                            Image(systemName: "phone")
                                .foregroundColor(appConfig.fontColor)
                        }
                        
                        ZStack{
                            Circle()
                                .strokeBorder(appConfig.fontColor, lineWidth: 1)
                                .frame(width: 50, height: 50)
                                .padding()
                            
                            Circle()
                                .fill(appConfig.fontColor.opacity(0.05))
                                .frame(width: 45, height: 45)
                                .padding()
                            
                            Image(systemName: "mail")
                                .foregroundColor(appConfig.fontColor)
                        }
                        
                        ZStack{
                            Circle()
                                .strokeBorder(appConfig.fontColor, lineWidth: 1)
                                .frame(width: 50, height: 50)
                                .padding()
                            
                            Circle()
                                .fill(appConfig.fontColor.opacity(0.05))
                                .frame(width: 45, height: 45)
                                .padding()
                            
                            Image(systemName: "network")
                                .foregroundColor(appConfig.fontColor)
                        }
                    }
                    
                    ContactCardComponent(color: iconColor, contact: contact)
                        .padding(.top, 50)
                    
                }
            }
            .padding(.horizontal)
            .fullSizeTop()
        }
        .fullSizeTop()
    }
}
