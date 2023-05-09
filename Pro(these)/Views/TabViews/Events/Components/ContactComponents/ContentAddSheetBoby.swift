//
//  ContentAddSheetBoby.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 04.05.23.
//

import SwiftUI

struct ContentAddSheetBoby: View {
    @EnvironmentObject var appConfig: AppConfig
    @EnvironmentObject var eventManager: EventManager
    var titel: String
    var body: some View {
        ZStack{
            appConfig.backgroundGradient
                .ignoresSafeArea()
            
            VStack(){
                Text(titel)
                    .padding(.top)
                
                Form {
                    Section {
                        HStack{
                            Text("Name:")
                            
                            TextField( text: $eventManager.addContactName, prompt: Text("Dr. Riera")) {
                                   Text("Name")
                               }
                            .disableAutocorrection(true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        HStack{
                            Text("Telefon:")
                            
                            Spacer()
                            
                            TextField( text: $eventManager.addContactPhone, prompt: Text("Telefon")) {
                                   Text("Telfon:")
                               }
                            .disableAutocorrection(true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack{
                            Text("E-Mail:")
                            
                            Spacer()
                            
                            TextField( text: $eventManager.addContactEmail, prompt: Text("E-Mail:")) {
                                Text("E-Mail:")
                            }
                            .disableAutocorrection(true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Picker("Icon", selection: $eventManager.addContactIcon) {
                            Text("bandage.fill").tag("bandage.fill")
                            Text("figure.roll").tag("figure.roll")
                            Text("figure.walk").tag("figure.walk")
                        }
                        
                        Picker("Titel", selection: $eventManager.addContactTitel) {
                            Text("Klinikum").tag("Klinikum")
                            Text("Fachklinik").tag("Fachklinik")
                            Text("Hausarzt").tag("Hausarzt")
                            Text("Orthopäde").tag("Orthopäde")
                            Text("Sanitätshaus").tag("Sanitätshaus")
                            Text("Physioterapeut").tag("Physioterapeut")
                            Text("Sonstiges").tag("other")
                        }
                    }
                    .padding(10)
                    .listRowBackground(Color.white.opacity(0.05))
                    .foregroundColor(appConfig.fontColor)
                    
                    Section {
                        HStack {
                            Button("Abbrechen") {}
                                .listRowBackground(Color.white.opacity(0.05))
                            Spacer()
                            Button("Speichern") {
                                eventManager.addContact()
                            }.listRowBackground(Color.white.opacity(0.05))
                        }
                        .padding(10)
                        .listRowBackground(Color.white.opacity(0.05))
                    }
                    .listRowBackground(Color.white.opacity(0.05))
                    .foregroundColor(appConfig.fontColor)
                }
                
                Spacer()
            }
            .padding(.vertical, 10)
            .scrollContentBackground(.hidden)
            .foregroundColor(.white)
            
        }
        .fullSizeTop()
    }
}
