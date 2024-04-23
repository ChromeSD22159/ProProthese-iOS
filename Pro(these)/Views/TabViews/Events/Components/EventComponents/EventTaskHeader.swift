//
//  EventTaskHeader.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 04.05.23.
//

import SwiftUI
import MessageUI

struct EventTaskHeader: View {
    @EnvironmentObject var appConfig: AppConfig
    @EnvironmentObject var eventManager: EventManager
    @EnvironmentObject var themeManager: ThemeManager
    
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    
    var color: Color
    
    var item: Event
    
    var contactPerson: ContactPerson? {
        item.contactPerson as ContactPerson? ?? nil
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            Image(systemName: item.icon ?? "questionmark.square.dashed")
                .font(.title)
                .foregroundColor(color)

            VStack(alignment: .leading, spacing: 5){
                Text(item.titel ?? "Unknown Titel")
                    .font(.callout)
                    .fontWeight(.medium)
                    
                HStack{
                    Text(item.startDate ?? Date(), style: .date)
                        .foregroundColor(currentTheme.textGray)
                        .font(.caption2)
                    Text(item.startDate ?? Date(), style: .time)
                        .foregroundColor(currentTheme.textGray)
                        .font(.caption2)
                }
            }
            
            Spacer()
            
            if contactPerson != nil {
                Menu {
                    
                    if let firstname = contactPerson?.firstname, let lastname = contactPerson?.lastname, let contact = contactPerson?.contact?.name {
                        Text("\(firstname) \(lastname) **(\(contact))**")
                            .foregroundColor(currentTheme.textGray)
                            .font(.system(size: 6, weight: .bold))
                    }
                    
                    if let phone = contactPerson?.phone {
                        Button(action: {
                            if let phoneURL = URL(string: "tel://\(phone)") {
                               UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
                            }
                        }) {
                            Label("Phone", systemImage: "phone.fill")
                        }
                    }
                    
                    if let mobil = contactPerson?.mobil {
                        Button(action: {
                            if let phoneURL = URL(string: "tel://\(mobil)") {
                               UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
                            }
                        }) {
                            Label("Mobil", systemImage: "phone.fill")
                        }
                    }
                    
                    if let mail = contactPerson?.mail {
                        Button(action: {
                            EmailController.shared.sendEmail(subject: "", body: "Erstellt aus der \"Pro Prothesen App.\"", to: mail)
                        }) {
                            Label("Write e-mail", systemImage: "envelope.fill")
                        }
                    }
                    
                  

                }
                label: {
                    Image(systemName: "person.text.rectangle")
                }
                .foregroundColor(currentTheme.text)
            }
            
        }
    }
}

