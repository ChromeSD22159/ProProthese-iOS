//
//  EventTaskHeader.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 04.05.23.
//

import SwiftUI

struct EventTaskHeader: View {
    @EnvironmentObject var appConfig: AppConfig
    var color: Color
    var item: Event
    var body: some View {
        HStack(spacing: 20) {
            Image(systemName: item.icon ?? "Unbekanntes Icon")
                .font(.title)
                .foregroundColor(color)

            VStack(alignment: .leading, spacing: 5){
                Text(item.titel ?? "Unbekanntes Titel")
                    .font(.callout)
                    .fontWeight(.medium)
                    
                HStack{
                    Text(item.startDate ?? Date(), style: .date)
                        .foregroundColor(appConfig.fontLight)
                        .font(.caption2)
                    Text(item.startDate ?? Date(), style: .time)
                        .foregroundColor(appConfig.fontLight)
                        .font(.caption2)
                }
            }
            
            Spacer()
        }
    }
}
