//
//  EventAddSheetBoby.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 04.05.23.
//

import SwiftUI

struct EventAddSheetBoby: View {
    @EnvironmentObject var appConfig: AppConfig
    @EnvironmentObject var eventManager: EventManager

    var titel: String
    var body: some View {
        ZStack{
            appConfig.backgroundGradient
                .ignoresSafeArea()
            
            VStack(){
                Text(titel)
                HStack {
                   Spacer()
                   Form {
                       VStack(spacing: 10) {
                           VStack(alignment: .leading){
                               TextField(
                                   "Z.b. Stump-Kontrolle",
                                   text: $eventManager.addEventTitel
                               )
                               .padding(.vertical)
                               .padding(.top)
                               .disableAutocorrection(true)
                               
                               Text(eventManager.error)
                                   .font(.caption2)
                                   .foregroundColor(.red)
                                   .padding(.bottom)
                                   .multilineTextAlignment(.leading)
                           }
                           
                           Grid {
                               GridRow {
                                   GeometryReader { proxy in
                                       HStack {
                                           ForEach(eventManager.contacts , id: \.id){ contact in
                                               Text(contact.name!).tag(contact)
                                                   .padding(10)
                                                   .background(contact != eventManager.addEventContact ? .white.opacity(0) : .white.opacity(0.2))
                                                   .border( contact != eventManager.addEventContact ? .white.opacity(0.1) : .white.opacity(0.5) , width: 1)
                                                   .onTapGesture {
                                                       eventManager.addEventContact = contact
                                                       eventManager.addEventIcon = contact.icon!
                                               }
                                               .frame(width: proxy.size.width * 0.3)
                                           }
                                       }
                                   }
                                   .frame(maxWidth: .infinity)
                               }
                           }
                           
                           DatePicker(
                               "Datum",
                               selection: $eventManager.addEventDate,
                               displayedComponents: [.date]
                           )
                           .datePickerStyle(.graphical)
                           .listRowBackground(Color.white.opacity(0.05))
                           
                           DatePicker(
                               "Zeit",
                               selection: $eventManager.addEventDate,
                               displayedComponents: [.hourAndMinute]
                           )
                           .datePickerStyle(.graphical)
                           .listRowBackground(Color.white.opacity(0.05))
                           
                           Toggle("Benachtigung zum Termin senden", isOn: $eventManager.sendEventNotofication)
                               .listRowBackground(Color.white.opacity(0.05))
                                        
                           Text("Es wird eine Erinnerung zu dem Termin 24 Stunden vor dem Termin gesendet.")
                               .fixedSize(horizontal: false, vertical: true)
                               .font(.callout)
                               .foregroundColor(appConfig.fontLight)
                               .padding(.bottom)
                       }
                       .listRowBackground(Color.white.opacity(0.05))
                       
                       Section {
                           HStack {
                               Button("Abbrechen") {
                                   eventManager.isAddEventSheet = false
                               }
                               .padding()
                               
                               Spacer()
                               
                               Button("Speichern") {
                                   print("submit")
                                   eventManager.addEvent()
                               }
                               .padding()
                           }
                       }
                       .listRowBackground(Color.white.opacity(0.05))
                       .foregroundColor(appConfig.fontColor)
                   }
                   Spacer()
               }
                
                Spacer()
            }
            .padding(.vertical, 20)
            .scrollContentBackground(.hidden)
            .foregroundColor(.white)
            
        }
        .fullSizeTop()
    }
    
    func dismissKeyboard() {
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.endEditing(true) // 4
    }
}
