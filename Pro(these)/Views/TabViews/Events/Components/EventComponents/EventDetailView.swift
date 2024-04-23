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
    @EnvironmentObject var themeManager: ThemeManager
    
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    
    var iconColor: Color
    
    var item: Event
    
    var isCalendar: Bool? = nil
    
    var body: some View {
        ZStack {
            currentTheme.gradientBackground(nil)
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack{
                    HStack{
                        Text(item.titel ?? "Unbekannter Titel")
                            .foregroundColor(currentTheme.text)
                    }
                    .padding(.top, 25)
                    
                    
                    contactPhoneMailButton()
                    
                    
                    EventCardComponent(color: iconColor, item: item)
                        .padding(.top, isCalendar ?? false ? 0:25)
                    
                }
            }
            .padding(.horizontal)
            .fullSizeTop()
        }
        .fullSizeTop()
    }
    
    @ViewBuilder func contactPhoneMailButton() -> some View {
        HStack {
            Spacer()
            if let phoneNumber = item.contact?.phone {
                let _ = print(phoneNumber)
                
                Button(action: {
                    if phoneNumber != "" {
                        if let phoneURL = URL(string: "tel://\(phoneNumber)") {
                            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
                        }
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(.clear)
                            .frame(width: 50)
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(phoneNumber != "" ? currentTheme.hightlightColor : .gray.opacity(0.3), lineWidth: 1)
                            )
                        
                        Label("Call", systemImage: "phone.fill")
                            .labelStyle(IconOnlyLabelStyle())
                            .foregroundColor(phoneNumber != "" ? currentTheme.text : .gray.opacity(0.3))
                    }
                }
                .disabled(phoneNumber == "")
                
               
            } else {
                ZStack {
                    Circle()
                        .fill(.clear)
                        .frame(width: 50)
                        .overlay(
                            Capsule(style: .continuous)
                                .stroke(currentTheme.hightlightColor, lineWidth: 1)
                        )
                    
                    Label("No Phone", systemImage: "phone.fill")
                        .labelStyle(IconOnlyLabelStyle())
                }
            }
            Spacer(minLength: 25)
            if let email = item.contact?.mail {
                Button(action: {
                    // Implement logic to send an email
                    EmailController.shared.sendEmail(subject: "", body: "Erstellt aus der \"Pro Prothesen App.\"", to: email)
                }) {
                    ZStack {
                        Circle()
                            .fill(.clear)
                            .frame(width: 50)
                            .overlay(
                                Capsule(style: .continuous)
                                    .stroke(email != "" ? currentTheme.hightlightColor : .gray.opacity(0.3), lineWidth: 1)
                            )
                        
                        Label("Send Email", systemImage: "envelope.fill")
                            .labelStyle(IconOnlyLabelStyle())
                            .foregroundColor(email != "" ? currentTheme.text : .gray.opacity(0.3))
                    }
                }
                .disabled(email == "")
            } else {
                ZStack {
                    Circle()
                        .fill(.clear)
                        .frame(width: 50)
                        .overlay(
                            Capsule(style: .continuous)
                                .stroke(currentTheme.hightlightColor, lineWidth: 1)
                        )
                    
                    Label("No Email", systemImage: "envelope.fill")
                        .labelStyle(IconOnlyLabelStyle())
                }
            }
            Spacer()
        }
        .padding(.top, 25)
    }
}

struct EventDetailView_Previews: PreviewProvider {
    
    static var testFeeling: Event? {
        let newEvent = Event(context: PersistenceController.shared.container.viewContext)
        newEvent.titel = "Standrort Gespräch"
        newEvent.endDate = Date()
        newEvent.startDate = Date()
        
        return newEvent
    }
    
    static var previews: some View {
        ZStack {
            Theme.blue.gradientBackground(nil).ignoresSafeArea()
            
            EventDetailView(iconColor: .white, item: testFeeling!)
                .environmentObject(AppConfig())
                .environmentObject(TabManager())
                .environmentObject(HealthStorage())
                .environmentObject(PushNotificationManager())
                .environmentObject(EventManager())
                .environmentObject(MoodCalendar())
                .environmentObject(WorkoutStatisticViewModel())
                .environmentObject(PainViewModel())
                .environmentObject(StateManager())
                .environmentObject(EntitlementManager())
                .defaultAppStorage(UserDefaults(suiteName: "group.FK.Pro-these-")!)
                .colorScheme(.dark)
        }
    }
}
