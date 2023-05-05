//
//  EventSection.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 04.05.23.
//

import SwiftUI

struct EventSection: View {
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var eventManager: EventManager
    @EnvironmentObject var appConfig: AppConfig
    @State private var count = 0
    var titel: String
    
    var data: [Event]
    
    var body: some View {
        Section(content: {
            ForEach(data){ item in
                NavigateTo({
                    EventPreview(item: item)
                }, {
                    EventDetailView( iconColor: .yellow, item: item)
                })
            }
        }, header: {
            HStack{
                Text("\(titel) (\(count))")
                    .font(.caption2)
                    .fontWeight(.medium)
                
                Spacer()
                   
                Button(action: { eventManager.isAddEventSheet.toggle() }, label: {
                    Label("Termin hinzufügen", systemImage: "plus")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .padding(.trailing, 20)
                })
            }
        })
        .tint(appConfig.fontColor)
        .listRowBackground(Color.white.opacity(0.05))
        .onAppear{
            count = data.count
        }
        .onChange(of: data, perform: { newData in
            count = newData.count
        })
    }
}

