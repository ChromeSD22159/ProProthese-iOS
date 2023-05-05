//
//  Events.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 01.05.23.
//

import SwiftUI
import CoreData
import Charts

struct Events: View {
    @EnvironmentObject var appConfig: AppConfig
    @EnvironmentObject var eventManager: EventManager
    @EnvironmentObject var tabManager: TabManager
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FocusState var focusedTask: EventTasks?
    
    var body: some View {
        VStack{
            
            Header(name: sayHallo(name: appConfig.username), subline: "Deine Termine und Notizen im Überlicht")
                .padding(.bottom, 20)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .center, spacing: 10) {
                    ForEach(Array(eventManager.contacts.enumerated()), id: \.1) { (index, contact) in
                        GeometryReader { geo in
                            NavigateTo({
                                ImageView(image: "Illustration", name: contact.name ?? "Unbekannter Name", titel:  contact.titel ?? "Unbekannter Titel" )
                                    .rotation3DEffect(.degrees(-geo.frame(in: .global).minX) / 20, axis: (x: 0, y: 1, z: 0))
                                    .frame(width: 200, height: 250)
                                    .shadow(color: .black.opacity(0.5), radius: 10, x: 5, y: 5)
                                    .offset(y: -18)
                            }, {
                                ContactDetailView(contact: contact, iconColor: .yellow)
                            })
                        }
                        .padding(.vertical, 40)
                        .frame(width: 200, height: 290)
                    }
                    
                    AddContact()
                        .frame(width: 200, height: 250)
                        .shadow(color: .black.opacity(0.5), radius: 10, x: 5, y: 5)
                       
                        
                }
                .padding(10)
            }
            .listRowBackground(Color.white.opacity(0.001))
            
            List {

                EventSection(titel: "Diese Woche", data: eventManager.eventsNextWeek)
                    .listRowInsets(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))
                
                EventSection(titel: "Diesen Monat", data: eventManager.eventsnextmonth)
                    .listRowInsets(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))
                
                if appConfig.showPastEvents {
                    EventSection(titel: "Vergangene Woche", data: eventManager.eventsPast)
                        .listRowInsets(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))
                }
            }
            .scrollContentBackground(.hidden)
            .foregroundColor(.white)
            .refreshable {
                eventManager.fetchContacts()
            }
        }
        .foregroundColor(appConfig.fontColor)
        .fullSizeTop()
        .sheet(isPresented: $eventManager.isAddContactSheet, content: {
            ContentAddSheetBoby(titel: "Kontakt hinzufügen")
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        })
        .sheet(isPresented: $eventManager.isAddEventSheet, content: {
            EventAddSheetBoby(titel: "Termin hinzufügen")
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
            
        })
        .onAppear{
            eventManager.fetchContacts()
        }
    }
}

// MARK: Event ViewItems
extension Events {
    @ViewBuilder
    func Header(name: String, subline: String) -> some View {
        HStack(){
            VStack(spacing: 2) {
                Text(name)
                    .font(.title2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text(subline)
                    .font(.callout)
                    .foregroundColor(appConfig.fontLight)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            Spacer()
            VStack(){
                Image(systemName: "gearshape")
                    .foregroundColor(appConfig.fontColor)
                    .onTapGesture {
                        tabManager.isSettingSheet.toggle()
                    }
            }
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
    }

    func sayHallo(name: String) -> String {
        return "Hallo, \(name)!"
    }

}


struct AddContact: View {
    @EnvironmentObject var appConfig: AppConfig
    @EnvironmentObject var eventManager: EventManager
    var body: some View {
        VStack(spacing: 10){
            Image(systemName: "plus")
                .multilineTextAlignment(.center)
            Text("Kontakt \n hinzufügen")
                .multilineTextAlignment(.center)
        }
        .foregroundColor(appConfig.foreground)
        .frame(width: 180, height: 245)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(appConfig.foreground, lineWidth: 2)
        )
        .onTapGesture {
            eventManager.isAddContactSheet.toggle()
        }
    }
}
struct ImageView: View {
    var image: String
    var name: String
    var titel: String
    var body: some View {
        
        VStack(alignment: .center) {
            Image(image)
                .resizable()
                .scaledToFit()
            
            VStack{
                Text(name)
                Text(titel)
                    .font(.callout)
                    .foregroundColor(.gray)
            }
            .padding()
        }
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }
}
