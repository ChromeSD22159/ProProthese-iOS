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
                            eventManager.isAddContactSheet.toggle()
                        }
                    }
                }
                .padding()
                
                
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
                        
                        Picker("Titel", selection: $eventManager.addContactTitel) {
                            ForEach(eventManager.contactTypes, id: \.type) { contact in
                                Text(contact.type).tag("\(contact.type)")
                            }
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
