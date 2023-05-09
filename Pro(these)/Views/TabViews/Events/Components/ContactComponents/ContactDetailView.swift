//
//  ContactDetailView.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 04.05.23.
//

import SwiftUI

struct ContactDetailView: View {
    @EnvironmentObject var appConfig: AppConfig
    @EnvironmentObject var eventManager: EventManager
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var pushNotificationManager: PushNotificationManager
    @StateObject var contactManager = ContactManager()
    @State var SelectedContact: Contact?
    @FocusState private var focusedContactPerson: ContactPerson?
    
    var contact: Contact
    var iconColor: Color
    var body: some View {
        ZStack {
            appConfig.backgroundGradient
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack{
                    // MARK: - Page Header
                    HStack{
                        Text(contact.name ?? "Unbekannter Name")
                            .foregroundColor(appConfig.fontColor)
                    }
                    .padding(.top, 25)
                    
                    
                    // MARK: - Contact Circles
                    HStack(spacing: 25) {
                        ZStack{
                            Circle()
                                .strokeBorder(appConfig.fontColor, lineWidth: 1)
                                .frame(width: 50, height: 50)
                                .padding()
                            
                            Circle()
                                .fill(appConfig.fontColor.opacity(0.05))
                                .frame(width: 45, height: 45)
                                .padding()
                            
                            Image(systemName: "phone")
                                .foregroundColor(appConfig.fontColor)
                        }
                        
                        ZStack{
                            Circle()
                                .strokeBorder(appConfig.fontColor, lineWidth: 1)
                                .frame(width: 50, height: 50)
                                .padding()
                            
                            Circle()
                                .fill(appConfig.fontColor.opacity(0.05))
                                .frame(width: 45, height: 45)
                                .padding()
                            
                            Image(systemName: "mail")
                                .foregroundColor(appConfig.fontColor)
                        }
                        
                        ZStack{
                            Circle()
                                .strokeBorder(appConfig.fontColor, lineWidth: 1)
                                .frame(width: 50, height: 50)
                                .padding()
                            
                            Circle()
                                .fill(appConfig.fontColor.opacity(0.05))
                                .frame(width: 45, height: 45)
                                .padding()
                            
                            Image(systemName: "network")
                                .foregroundColor(appConfig.fontColor)
                        }
                    }
                    
                    // MARK: - Foreach ContactPerson
                    VStack{
                        HStack(spacing: 10){
                            Text("Ansprachspartner")
                                .font(.callout)
                            
                            Spacer()
                            
                            Button {
                                contactManager.isShowAddContactPersonSheet.toggle()
                                SelectedContact = contact
                            } label: {
                                HStack {
                                    Image(systemName: "person.badge.plus")
                                        .font(.title)
                                }
                            }
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal)
                        
                        if (contact.contactPersons?.allObjects as? [ContactPerson] ?? []).count == 0 {
                            HStack(spacing: 10){
                                Text("Kein Ansprechpartner vorhanden.")
                                Spacer()
                            }
                            .padding(20)
                            .background(Color.white.opacity(0.05))
                            .cornerRadius(20)
                        } else {
                            ForEach(contact.contactPersons?.allObjects as? [ContactPerson] ?? [] , id: \.self) { person in //
                                
                                HStack(spacing: 10){
                                    Image(systemName: "person")
                                        .font(.title2)
                                        .padding(.trailing)
                                    
                                    ContactPersonRow(person: person, focusedTask: $focusedContactPerson)
                                }
                                .padding(20)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(20)
                            }
                        }
                       
                    }
                    .padding(.top, 50)
                    
                    // MARK: - Foreach Recurring Events
                    VStack{
                        VStack{
                            HStack(spacing: 20){
                                Text("Wiederholende Benachrichtigungen")
                                    .font(.callout)
                                Spacer()
                                
                                Button {
                                    contactManager.isShowAddContactRhymusSheet.toggle()
                                    SelectedContact = contact
                                } label: {
                                    HStack {
                                        Image(systemName: "goforward.plus")
                                            .font(.title)
                                    }
                                }
                                .foregroundColor(appConfig.fontColor)
                                
                                if AppConfig().debug {
                                    Button {
                                        pushNotificationManager.removeAllPendingNotificationRequests()
                                    } label: {
                                        Image(systemName: "bell.slash.circle")
                                            .font(.title)
                                    }
                                }
                            }
                          
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            
                            if (contact.recurringEvents?.allObjects as? [RecurringEvents] ?? []).count == 0 {
                                HStack(spacing: 10){
                                    Text("Keine Benachrichtigungen vorhanden.")
                                    Spacer()
                                }
                                .padding(20)
                                .background(Color.white.opacity(0.05))
                                .cornerRadius(20)
                            } else {
                                ForEach(contact.recurringEvents?.allObjects as? [RecurringEvents] ?? [] , id: \.self) { reEvent in //
                                    HStack(alignment: .center) {
                                        Image(systemName: "goforward")
                                            .font(.title2)
                                            .padding(.trailing)
                                        
                                        VStack(alignment: .leading) {
                                            HStack() {
                                                Text(reEvent.name ?? "undefine name")
                                                Spacer()
                                                
                                            }
                                            HStack {
                                                Text(reEvent.date ?? Date(), style: .date)
                                                Text(reEvent.date ?? Date(), style: .time)
                                                Spacer()
                                                Text(contactManager.printRhymus(reEvent.rhymus))
                                                Spacer()
                                            }
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                        }
                                        Spacer()
                                        Confirm(message: "'\( reEvent.name ?? "" )' löschen?", buttonText: "", buttonIcon: "trash", content: {
                                            Button("Löschen") {
                                                eventManager.deleteRecurringEvents(reEvent)
                                            }
                                        })
                                        .font(.title2)
                                        .foregroundColor(.white)
                                    }
                                    .padding(20)
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(20)
                                }
                            }
                            
                        }
                    }
                    .padding(.top, 50)
                    
                    ContactCardComponent(color: iconColor, contact: contact)
                        .padding(.top, 50)
                    
                }
            }
            .padding(.horizontal)
            .fullSizeTop()
            .sheet(isPresented: $contactManager.isShowAddContactPersonSheet, content: {
                AddContactPersonSheet()
            })
            .sheet(isPresented: $contactManager.isShowAddContactRhymusSheet, content: {
                AddContactRecurringEvents()
                    .presentationDragIndicator(.visible)
            })
        }
        .fullSizeTop()
    }
    
    // MARK: - AddContactPersonSheet
    @ViewBuilder
    func AddContactPersonSheet() -> some View {
        ZStack{
            appConfig.backgroundGradient
                .ignoresSafeArea()
            
            VStack(){
                Text("Ansprechspartner hinzufügen")
                    .padding(.top)
                
                Form {
                    Section {
                        Picker("Anrede", selection: $contactManager.title) {
                            Text("Herr").tag("Herr")
                            Text("Frau").tag("Frau")
                        }
                        
                        HStack{
                            Text("Vorname:")
                            
                            TextField( text: $contactManager.firstname, prompt: Text("Max")) {
                                   Text("Vorname")
                               }
                            .disableAutocorrection(true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        
                        HStack{
                            Text("Nachname:")
                            
                            Spacer()
                            
                            TextField( text: $contactManager.lastname, prompt: Text("Musterman")) {
                                   Text("Nachname")
                               }
                            .disableAutocorrection(true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack{
                            Text("Telefon:")
                            
                            Spacer()
                            
                            TextField( text: $contactManager.phone, prompt: Text("Telefon Nr.")) {
                                Text("07751 / 1234")
                            }
                            .disableAutocorrection(true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack{
                            Text("Mobil:")
                            
                            Spacer()
                            
                            TextField( text: $contactManager.mobil, prompt: Text("Mobil Nr.")) {
                                Text("0174 / 123 456")
                            }
                            .disableAutocorrection(true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        HStack{
                            Text("E-Mail:")
                            
                            Spacer()
                            
                            TextField( text: $contactManager.email, prompt: Text("E-Mail:")) {
                                Text("info@email.de")
                            }
                            .disableAutocorrection(true)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
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
                                let newContactPerson = ContactPerson(context: PersistenceController.shared.container.viewContext)
                                newContactPerson.title = contactManager.title
                                newContactPerson.firstname = contactManager.firstname
                                newContactPerson.lastname = contactManager.lastname
                                newContactPerson.phone = contactManager.phone
                                newContactPerson.mobil = contactManager.mobil
                                newContactPerson.mail = contactManager.email
                                
                                contact.addToContactPersons(newContactPerson)
                                withAnimation{
                                    eventManager.sortAllEvents()
                                   // focusedTask = newTask
                                }
                                do {
                                    try PersistenceController.shared.container.viewContext.save()
                                    contactManager.isShowAddContactPersonSheet = false
                                    contactManager.title = ""
                                    contactManager.firstname = ""
                                    contactManager.lastname = ""
                                    contactManager.phone = ""
                                    contactManager.mobil = ""
                                    contactManager.email = ""
                                } catch {
                                    let nsError = error as NSError
                                    fatalError("Add Task error: \(nsError), \(nsError.userInfo)")
                                }
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
    
    // MARK: - AddContactRecurringEvents
    @ViewBuilder
    func AddContactRecurringEvents() -> some View {
        ZStack{
            appConfig.backgroundGradient
                .ignoresSafeArea()
            
            VStack(){
                Text("Wiederholende Erreignisse hinzufügen")
                    .padding(.top)
                
                Form {
                    Section {
                        
                        
                        VStack(alignment: .leading){
                            HStack{
                                Text("Name:")
                                TextField( text: $contactManager.RecurringEventName, prompt: Text("Name")) {
                                       Text("Name")
                                   }
                                .disableAutocorrection(true)
                               
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Text("Bitte Name angeben!")
                                .foregroundColor(.red)
                                .font(.caption)
                                .opacity( contactManager.RecurringEventName == "" ? 1 : 0)
                        }
                        
                        VStack(alignment: .leading){
                            Picker("Rhytmus", selection: $contactManager.RecurringEventRhytmus) {
                                Text("Interval wählen").tag(0)
                                Text("1Minute").tag(60.0)
                                Text("5Minute").tag(300.0)
                                Text("Wöchentlich").tag(604800.0)
                                Text("Monatlich").tag(1209600.0)
                                Text("Quatal").tag(2630000.0)
                                Text("Halbjährlich").tag(7890000.0)
                            }
                            
                            Text("Bitte Interval angeben!")
                                .foregroundColor(.red)
                                .font(.caption)
                                .opacity( contactManager.RecurringEventRhytmus == 0 ? 1 : 0)
                        }
                    }
                    .padding(10)
                    .listRowBackground(Color.white.opacity(0.05))
                    .foregroundColor(appConfig.fontColor)
                    
                    Section {
                        HStack {
                            Button("Abbrechen") {}
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.white.opacity(0.1))
                                .cornerRadius(10)
                                
                            Spacer()
                            
                            Button("Speichern") {
                                guard contactManager.RecurringEventName != "" else {
                                    contactManager.errors.append("Bitte gebe eine RecurringEventName ein!")
                                    return print( "Bitte gebe eine RecurringEventName ein!")
                                }
                                guard contactManager.RecurringEventRhytmus != 0.0 else {
                                    contactManager.errors.append("Bitte gebe eine RecurringEventRhytmus ein!")
                                    return print( "Bitte gebe eine RecurringEventRhytmus ein!")
                                }
                                let ident = contactManager.generateIdentifier()
                                let newRecurringEvents = RecurringEvents(context: PersistenceController.shared.container.viewContext)
                                    newRecurringEvents.identifier = ident
                                    newRecurringEvents.name = contactManager.RecurringEventName
                                    newRecurringEvents.rhymus = contactManager.RecurringEventRhytmus
                                    newRecurringEvents.date = Date()
                                    contact.addToRecurringEvents(newRecurringEvents)
                                
                                if contactManager.RecurringEventRhytmus != 0 {
                                    let id:String = ident
                                    let titel:String = "Pro Prothese - Reminder"
                                    let body:String = "Erinnerung: \(newRecurringEvents.name ?? "Unknown Name")"
                                    let rhytmus:Double = newRecurringEvents.rhymus
                                    pushNotificationManager.PushNotificationRepeater(identifier: id, title: titel, body: body, interval: rhytmus)
                                }

                                do {
                                    try PersistenceController.shared.container.viewContext.save()
                                    contactManager.isShowAddContactRhymusSheet = false
                                    contactManager.RecurringEventName = ""
                                    contactManager.RecurringEventRhytmus = 0
                                    contactManager.errors.removeAll(keepingCapacity: true)
                                    
                                } catch {
                                    let nsError = error as NSError
                                    fatalError("Add Task error: \(nsError), \(nsError.userInfo)")
                                }
                            }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(withAnimation{
                                    contactManager.RecurringEventSubmit ? Color.white.opacity(0.05) : Color.white.opacity(0.1)
                                })
                                .cornerRadius(10)
                                .disabled(contactManager.RecurringEventSubmit)
                        }
                       
                    }
                    .listRowBackground(Color.white.opacity(0.025))
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
