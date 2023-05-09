//
//  EventDetailView.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 04.05.23.
//

import SwiftUI

struct EventDetailView: View {
    @EnvironmentObject var eventManager: EventManager
    @EnvironmentObject var appConfig: AppConfig
    var iconColor: Color
    var item: Event
    var body: some View {
        ZStack {
            appConfig.backgroundGradient
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack{
                    HStack{
                        Text(item.titel ?? "Unbekannter Titel")
                            .foregroundColor(appConfig.fontColor)
                    }
                    .padding(.top, 25)
                    
                    EventCardComponent(color: iconColor, item: item)
                        .padding(.top, 50)
                    
                }
            }
            .padding(.horizontal)
            .fullSizeTop()
        }
        .fullSizeTop()
    }
}
