//
//  ContactSection.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 04.05.23.
//

import SwiftUI

struct ContactSection: View {
    @EnvironmentObject var eventManager: EventManager
    @EnvironmentObject var appConfig: AppConfig
    var titel: String
    var body: some View {
        Section(content: {
            if !eventManager.contacts.isEmpty {
                ForEach(eventManager.contacts){ contact in
                    NavigateTo({
                        ContactPreview(icon: contact.icon ?? "", color: .yellow, name: contact.name ?? "Unbekannter Name" , titel: contact.titel ?? "Unbekannter Titel")
                    }, {
                        ContactDetailView(contact: contact, iconColor: .yellow)
                    })
                }
            } else {
                HStack(alignment: .center){
                    Spacer()
                    Text("Kein Kontakt vorhanden!")
                        .font(.caption2)
                    Spacer()
                }
            }
        }, header: {
            HStack{
                Text(titel)
                    .font(.caption2)
                    .fontWeight(.medium)
                
                Spacer()
                
                Button(action: { eventManager.isAddContactSheet.toggle() }, label: {
                    Label("Kontakt hinzufügen", systemImage: "plus")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .padding(.trailing, 20)
                })
            }
            
        })
        .tint(appConfig.fontColor)
        .listRowBackground(Color.white.opacity(0.05))
    }
}

