//
//  EventPreview.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 04.05.23.
//

import SwiftUI

struct EventPreview: View {
    @EnvironmentObject private var appConfig: AppConfig
    var item: Event
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: item.icon ?? "")
                .font(.title)
                .foregroundColor(.yellow)
            
            VStack(alignment: .leading, spacing: 5){
                HStack{
                    Text(item.titel ?? "Unbekannter Titel")
                        .foregroundColor(appConfig.fontColor)
                        .font(.callout)
                }
                
                HStack{
                    Text(item.date ?? Date(), style: .date)
                        .foregroundColor(appConfig.fontLight)
                        .font(.caption2)
                    Text(item.date ?? Date(), style: .time)
                        .foregroundColor(appConfig.fontLight)
                        .font(.caption2)
                    
                    Text("(\(item.contact?.name ?? "Unbekannter Kontakt"))")
                        .foregroundColor(appConfig.fontLight)
                        .font(.caption2)
                }
            }
            
            Spacer()
        }
        .padding(10)
    }
}
