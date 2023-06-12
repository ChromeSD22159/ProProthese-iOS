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
            
            VStack(){
                HStack(alignment: .center) {
                    
                    Text(titel)
                        .padding(.leading)
                    
                    Spacer()
                    
                    ZStack{
                        Image(systemName: "xmark")
                            .font(.title2)
                            .padding()
                    }
                    .onTapGesture{
                        withAnimation(.easeInOut) {
                            eventManager.isAddEventSheet.toggle()
                        }
                    }
                }
                .padding()
               
                
                HStack {
                   Spacer()
                   Form {
                       VStack(spacing: 20) {
                           VStack(alignment: .leading){
                               TextField(
                                   "z.B. Stumpf-Kontrolle",
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
                           
                           Picker("Kontakt", selection: $eventManager.addEventContact) {
                               Text("Bitte wählen").tag(Optional<Contact>(nil))
                               ForEach(eventManager.contacts , id: \.id){ contact in
                                   Text(contact.name!).tag(Optional<Contact>(contact))
                                      
                               }
                           }
                           .pickerStyle(.menu)
                           .listRowBackground(Color.white.opacity(0.05))
                           .accentColor(.white)
                           
                           DatePicker(
                              "Beginn",
                              selection: $eventManager.addEventStarDate,
                              displayedComponents: [.date, .hourAndMinute]
                           )
                           .datePickerStyle(.compact)
                           .listRowBackground(Color.white.opacity(0.05))
                           .accentColor(.white)
                           .tint(.white)
                           
                           DatePicker(
                               "Ende",
                               selection: $eventManager.addEventEndDate,
                               displayedComponents: [.date, .hourAndMinute]
                           )
                           .datePickerStyle(.compact)
                           .listRowBackground(Color.white.opacity(0.05))
                           .accentColor(.white)
                           .tint(.white)
                       
                           
                           Toggle("Benachtigung zum Termin senden", isOn: $eventManager.sendEventNotofication)
                               .listRowBackground(Color.white.opacity(0.05))
                           
                           if eventManager.sendEventNotofication {
                               Picker("Benachrichtigen", selection: $eventManager.addEventAlarm) {
                                   
                                   ForEach(eventManager.alarms, id: \.text) { alarm in
                                       Text(alarm.text).tag(alarm.ekAlarm)
                                   }
                                   
                                  /* Text("10 Minuten vorher").tag(-600)
                                   Text("30 Minuten vorher").tag(-1800)
                                   Text("1 Stunde vorher").tag(-3600)
                                   Text("2 Stunde vorher").tag(-7200)
                                   Text("1 Tag vorher").tag(-86400)
                                   Text("2 Tag vorher").tag(-172800)
                                   Text("3 Tag vorher").tag(-259200)*/
                               }
                               .pickerStyle(.menu)
                               .listRowBackground(Color.white.opacity(0.05))
                               .accentColor(.white)
                           }
                                        
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
            .onChange(of: eventManager.addEventStarDate){ newDate in
                eventManager.addEventEndDate = Calendar.current.date(byAdding: .minute, value: 30, to: newDate)!
            }
            
        }
        .fullSizeTop()
    }
    
    func dismissKeyboard() {
        UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.endEditing(true) // 4
    }
}
