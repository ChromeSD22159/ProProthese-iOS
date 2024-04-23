//
//  ContactDetailView.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 04.05.23.
//

import Foundation
import SwiftUI
import EventKit
import Contacts

struct ContactDetailView: View {
    @EnvironmentObject var appConfig: AppConfig
    @EnvironmentObject var eventManager: EventManager
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var pushNotificationManager: PushNotificationManager
    @StateObject var contactManager = ContactManager()
    @State var SelectedContact: Contact?
    @FocusState private var focusedContactPerson: ContactPerson?
    @EnvironmentObject var themeManager: ThemeManager
    
    @EnvironmentObject var adSheet: GoogleInterstitialAd
    
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    var contact: Contact
    var iconColor: Color
    var body: some View {
        ZStack {
            currentTheme.gradientBackground(nil)
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack{
                    // MARK: - Page Header
                    HStack{
                        Spacer()
                        
                        Text(contact.name ?? "Unknown Name")
                            .foregroundColor(currentTheme.text)
                        
                        Spacer()
                        
                        NavigateTo({
                            Image(systemName: "pencil")
                                .foregroundColor(currentTheme.text)
                                .font(.title3)
                        }, {
                            AuroraBackground(content: {
                                ContentAddSheetBoby(isAddContactSheet: $eventManager.isAddContactSheet, titel:  "New contact", contact: contact)
                            })
                        }, from: .event)
                        .onSubmit {
                            eventManager.editContact = contact
                            eventManager.isAddContactSheet.toggle()
                        }
                        
                    }
                    .padding(.top, 25)
                    .padding(.horizontal)
                    
                    // MARK: - Foreach ContactPerson
                    VStack{
                        HStack(spacing: 10){
                            Text("Contact Person")
                                .font(.callout)
                            
                            Spacer()
                            
                            NavigateTo({
                                HStack {
                                    Image(systemName: "person.badge.plus")
                                        .font(.body)
                                }
                            }, {
                                AuroraBackground(content: {
                                    AddContactPersonDetail(titel: "Add Contact person!")
                                })
                            }, from: .event)
                        }
                        .foregroundColor(currentTheme.text)
                        .padding(.horizontal)
                        
                        if (contact.contactPersons?.allObjects as? [ContactPerson] ?? []).count == 0 {
                            HStack(spacing: 10){
                                Text("No contact available.")
                                Spacer()
                            }
                            .padding(20)
                            .background(currentTheme.text.opacity(0.05))
                            .cornerRadius(20)
                        } else {
                            ForEach(contact.contactPersons?.allObjects as? [ContactPerson] ?? [] , id: \.self) { person in //
                                
                                HStack(spacing: 10){
                                    Image(systemName: "person")
                                        .font(.body)
                                        .padding(.trailing)
                                    
                                    ContactPersonRow(person: person, focusedTask: $focusedContactPerson)
                                }
                                .padding(20)
                                .background(currentTheme.text.opacity(0.05))
                                .cornerRadius(20)
                            }
                        }
                       
                    }
                    .padding(.top, 50)
                    .padding(.horizontal)
                    
                    // MARK: - Foreach Recurring Events
                    VStack{
                        VStack{
                            HStack(spacing: 20){
                                Text("Repeating notifications")
                                    .font(.callout)
                                Spacer()
                                
                                Button {
                                    contactManager.isShowAddContactRhymusSheet.toggle()
                                    SelectedContact = contact
                                } label: {
                                    HStack {
                                        Image(systemName: "goforward.plus")
                                            .font(.body)
                                    }
                                }
                                .foregroundColor(currentTheme.text)
                                
                                if AppConfig().debug {
                                    Button {
                                        pushNotificationManager.removeAllPendingNotificationRequests()
                                    } label: {
                                        Image(systemName: "bell.slash.circle")
                                            .font(.body)
                                    }
                                }
                            }
                            .foregroundColor(currentTheme.text)
                            .padding(.horizontal)
                            
                            if (contact.recurringEvents?.allObjects as? [RecurringEvents] ?? []).count == 0 {
                                HStack(spacing: 10){
                                    Text("No notifications available.")
                                    Spacer()
                                }
                                .padding(20)
                                .background(currentTheme.text.opacity(0.05))
                                .cornerRadius(20)
                            } else {
                                ForEach(contact.recurringEvents?.allObjects as? [RecurringEvents] ?? [] , id: \.self) { reEvent in //
                                    HStack(alignment: .center) {
                                        Image(systemName: "goforward")
                                            .font(.title2)
                                            .padding(.trailing)
                                        
                                        VStack(alignment: .leading, spacing: 6) {
                                            HStack() {
                                                Text(reEvent.name ?? "undefine name")
                                                    .font(.body)
                                                
                                                Spacer()
                                                
                                            }
                                            
                                            HStack {
                                                Text(reEvent.date ?? Date(), style: .date)
                                                Text(reEvent.date ?? Date(), style: .time)
                                                Text(contactManager.printRhymus(reEvent.rhymus))
                                                Spacer()
                                            }
                                            .font(.caption2)
                                            .foregroundColor(.gray)
                                        }
                                        .font(.title2)
                                        .foregroundColor(currentTheme.text)
                                        
                                        Spacer()
                                        
                                        Confirm(message: "delete '\( reEvent.name ?? "" )'?", buttonText: "", buttonIcon: "trash", content: {
                                            Button("Delete") {
                                               // eventManager.deleteRecurringEvents(reEvent)
                                                eventManager.deleteRecurringAllEvents(reEvent)
                                            }
                                            .foregroundColor(currentTheme.text)
                                        })
                                        .foregroundColor(currentTheme.text)
                                    }
                                    .padding(20)
                                    .background(currentTheme.text.opacity(0.05))
                                    .cornerRadius(20)
                                    
                                }
                            }
                            
                        }
                    }
                    .padding(.top, 50)
                    .padding(.horizontal)
                    
                    VStack{
                        VStack{
                            HStack(spacing: 20){
                                Text("Events")
                                    .font(.callout)
                                
                                Spacer()
                                
                                // FIXME: ADD EVENT
                                Button(action: {
                                    eventManager.isAddEventSheet.toggle()
                                    eventManager.addEventContact = contact
                                }, label: {
                                    Image(systemName: "plus")
                                })
                                .blurredOverlaySheet(.init(Material.ultraThinMaterial), show: $eventManager.isAddEventSheet, onDismiss: {
                                    // Show InterstitialSheet if not Pro
                                    adSheet.showAd()
                                }, content: {
                                    ZStack(content: {
                                        currentTheme.gradientBackground(nil).ignoresSafeArea()
                                        
                                        FloatingClouds(speed: 1.0, opacity: 0.5, currentTheme: currentTheme)
                                            .opacity(0.5)
                                        
                                        EventAddSheetBoby(titel: "Create an appointment")
                                            .presentationDetents([.large])
                                            .presentationDragIndicator(.visible)
                                    })
                                })
                            }
                            .foregroundColor(currentTheme.text)
                            .padding(.horizontal)
                            .padding(.horizontal)
                            
                            ContactCardComponent(color: iconColor, contact: contact)
                        }
                    }
                    .padding(.top, 50)
                    
                }
            }
            .fullSizeTop()
            // ADDRecurringEvents
            .blurredOverlaySheet(.init(Material.ultraThinMaterial), show: $contactManager.isShowAddContactRhymusSheet, onDismiss: {
                // Show InterstitialSheet if not Pro
                adSheet.showAd()
            }, content: {
                AuroraBackground(content: {
                    AddContactRecurringEvents()
                })
            })
        }
        .fullSizeTop()
    }
    
    @ViewBuilder func AddContactPersonDetail(titel: LocalizedStringKey) -> some View {
        
        ScrollView(showsIndicators: false) {
            VStack(spacing: 10){
                HStack{
                    Text(titel)
                        .foregroundColor(currentTheme.text)
                }
                .padding(.bottom)
                
                Section {
                    HStack {
                        Picker("Salutation", selection: $contactManager.title) {
                            Text("---").tag("---")
                            Text("Mister").tag("Herr")
                            Text("Woman").tag("Frau")
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .foregroundColor(currentTheme.text)
                        .tint(currentTheme.text)
                        .cornerRadius(10)
                        
                        Spacer()
                        
                        Button(action: {
                            eventManager.loadContact.toggle()
                        }, label: {
                            Label(eventManager.selectedContact == nil ? "Import Contact" : "\(eventManager.selectedContact?.givenName ?? "") \(eventManager.selectedContact?.familyName ?? "")", systemImage: "person.crop.rectangle.badge.plus")
                        })
                        .padding()
                        .background(.ultraThinMaterial)
                        .foregroundColor(currentTheme.text)
                        .cornerRadius(10)
                    }
                    
                    HStack{
                        Text("First name:")
                        
                        TextField( text: $contactManager.firstname, prompt: Text("Max")) {
                               Text("First name")
                           }
                        .disableAutocorrection(true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.ultraThinMaterial)
                    .foregroundColor(currentTheme.text)
                    .cornerRadius(10)
                    
                    HStack{
                        Text("Last name:")
                        
                        Spacer()
                        
                        TextField( text: $contactManager.lastname, prompt: Text("Musterman")) {
                               Text("Last name")
                           }
                        .disableAutocorrection(true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.ultraThinMaterial)
                    .foregroundColor(currentTheme.text)
                    .cornerRadius(10)
                    
                    HStack{
                        Text("Phone:")
                        
                        /*
                         Picker("", selection: $contactManager.countryPhonePrefix) {
                             ForEach(contactManager.counntrys, id: \.identifier) { c in
                                 Text("\(c.identifier) (\(c.prefix))").tag("\(c.identifier)")
                             }
                         }.tint(currentTheme.text)
                         */
                        
                        HStack {
                            TextField( text: $contactManager.phone, prompt: Text("Phone Nr.")) {
                                Text("040 / 1234")
                            }
                            .disableAutocorrection(true)
                            
                            Button(action: {
                                copyToClipboard(text: contactManager.phone)
                            }) {
                                Image(systemName: "doc.on.clipboard")
                            }
                            
                            Button(action: {
                                guard isClipboard() else { return }
                                
                                guard let new = pasteFromClipboard() else { return  }
                                
                                contactManager.phone = new
                            }) {
                                Image(systemName: "list.clipboard")
                                    .foregroundColor(isClipboard() ? currentTheme.text : currentTheme.textGray)
                            }
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.ultraThinMaterial)
                    .foregroundColor(currentTheme.text)
                    .cornerRadius(10)
                    
                    HStack{
                        Text("Mobilphone:")
                        
                        /*
                         Picker("", selection: $contactManager.countryMobilPrefix) {
                             ForEach(contactManager.counntrys, id: \.identifier) { c in
                                 Text("\(c.identifier) (\(c.prefix))").tag("\(c.identifier)")
                             }
                         }.tint(currentTheme.text)
                         */
                        
                        HStack {
                            TextField( text: $contactManager.mobil, prompt: Text("Mobilphone Nr.")) {
                                Text("0174 / 123 456")
                            }
                            .disableAutocorrection(true)
                            
                            Button(action: {
                                copyToClipboard(text: contactManager.mobil)
                            }) {
                                Image(systemName: "doc.on.clipboard")
                            }
                            
                            Button(action: {
                                guard isClipboard() else { return }
                                
                                guard let new = pasteFromClipboard() else { return }
                                
                                contactManager.mobil = new
                            }) {
                                Image(systemName: "list.clipboard")
                                    .foregroundColor(isClipboard() ? currentTheme.text : currentTheme.textGray)
                            }
                        }
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.ultraThinMaterial)
                    .foregroundColor(currentTheme.text)
                    .cornerRadius(10)
                    
                    HStack{
                        Text("E-Mail:")
                        
                        Spacer()
                        
                        TextField( text: $contactManager.email, prompt: Text("E-Mail:")) {
                            Text("info@email.de")
                        }
                        .disableAutocorrection(true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.ultraThinMaterial)
                    .foregroundColor(currentTheme.text)
                    .cornerRadius(10)
                }

                HStack {
                    Button("Cancel") {
                        
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .textCase(.uppercase)
                    .background(currentTheme.text.opacity(0.05))
                    .foregroundColor(currentTheme.text)
                    .opacity(0)
                    .cornerRadius(10)
                    
                    Button("Save") {
                        contactManager.contactPersonErrors.removeAll(keepingCapacity: true)
                        
                        let newContactPerson = ContactPerson(context: PersistenceController.shared.container.viewContext)
                        newContactPerson.title = contactManager.title
                        newContactPerson.firstname = contactManager.firstname
                        newContactPerson.lastname = contactManager.lastname
                        newContactPerson.phone = contactManager.phone
                        newContactPerson.mobil = contactManager.mobil
                        newContactPerson.mail = contactManager.email
                        
                        if ValidateForm(newContactPerson: newContactPerson) {
                           
                            contact.addToContactPersons(newContactPerson)
                            withAnimation{
                                eventManager.sortAllEvents()
                               // focusedTask = newTask
                            }
                            do {
                                try PersistenceController.shared.container.viewContext.save()
                                contactManager.resetStates()
                            } catch {
                                let nsError = error as NSError
                                fatalError("Add Task error: \(nsError), \(nsError.userInfo)")
                            }
                            
                        } else {
                            print("not Valid")
                        }

                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .textCase(.uppercase)
                    .background(currentTheme.text.opacity(0.05))
                    .foregroundColor(currentTheme.text)
                    .cornerRadius(10)
                }
                .foregroundColor(currentTheme.text)
                .onAppear{
                    //contactManager.countryPhonePrefix = Locale.current.language.region!.identifier
                    //contactManager.countryMobilPrefix = Locale.current.language.region!.identifier
                }
                .onChange(of: contactManager.phone, perform: { newPhone in
                    //let _ = convertPhoneNumberWithPrefix(number: newPhone, type: "phone")
                    //print(p)
                })
                .onChange(of: contactManager.countryPhonePrefix, perform: { newPhone in
                    //let _ =  convertPhoneNumberWithPrefix(number: contactManager.phone, type: "phone")
                    //print(p)
                })
                .onChange(of: contactManager.mobil, perform: { newPhone in
                    //let _ =  convertPhoneNumberWithPrefix(number: newPhone, type: "mobil")
                   // print(p)
                })
                .onChange(of: contactManager.countryMobilPrefix, perform: { newPhone in
                    //let _ =  convertPhoneNumberWithPrefix(number: contactManager.mobil, type: "mobil")
                   // print(p)
                })
                .onChange(of: eventManager.selectedContact, perform: { newContact in
                    
                    if let firstname = newContact?.givenName {
                        contactManager.firstname = firstname
                    }
                    
                    if let familyName = newContact?.familyName {
                        contactManager.lastname = familyName
                    }
                    
                    if let phoneNumbers = extractMobileNumbers(phoneNumbers: newContact?.phoneNumbers ?? nil, get: .mobil)  {
                        contactManager.mobil = phoneNumbers
                    }
                    
                    if let phoneNumbers = extractMobileNumbers(phoneNumbers: newContact?.phoneNumbers ?? nil, get: .phone)  {
                        contactManager.phone = phoneNumbers
                    }
                    
                    if let emailAddresses = newContact?.emailAddresses {
                        contactManager.email = convertCNLabeledValueArrayToString(labeledValues: emailAddresses)
                    }
                })
                .onDisappear(perform: {
                    eventManager.selectedContact = nil
                })
                if contactManager.contactPersonErrors.count > 0 {
                    PrintErrors()
                }
                
                Spacer()
              
            }
            .sheetModifier(isSheet: $eventManager.loadContact, sheetContent: {
                ContactPickerView(isPresented: $eventManager.loadContact, selectedContact: $eventManager.selectedContact).ignoresSafeArea()
            }, dismissContent: {})
            .padding(.top, 80)
            .onAppear {
                adSheet.requestInterstitialAds()
            }
        }
        .ignoresSafeArea()
        .padding(.horizontal)
    }
    
    // MARK: - AddContactRecurringEvents
    @ViewBuilder func AddContactRecurringEvents() -> some View {
        VStack(){
            
            SheetHeader(title: "Add repeating events", action: {
                contactManager.isShowAddContactRhymusSheet.toggle()
            })
            
            Form {
                VStack {
                    VStack(alignment: .leading){
                        HStack{
                            Text("Name:")
                            TextField( text: $contactManager.RecurringEventName, prompt: Text("Name")) {
                                   Text("Name")
                               }
                            .disableAutocorrection(true)
                           
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("Please enter a name!")
                            .foregroundColor(.red)
                            .font(.caption)
                            .opacity( contactManager.RecurringEventName == "" ? 1 : 0)
                    }
                    
                    VStack(alignment: .leading){
                        HStack{
                            Picker("Rhythm", selection: $contactManager.RecurringEventRhytmus) {
                                Text("Weekly").tag(604800.0).font(.caption2)
                                Text("Monthly").tag(1209600.0).font(.caption2)
                                Text("Quarterly").tag(2630000.0).font(.caption2)
                                Text("Half-yearly").tag(7890000.0).font(.caption2)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        HStack{
                            Text("Date:")
                            
                            Spacer()
                            
                            Button {
                                withAnimation {
                                    contactManager.showDatePicker.toggle()
                                }
                            } label: {
                                HStack(spacing: 20){
                                    Image(systemName: "calendar.badge.plus")
                                        .font(.title3)
                                    Text(contactManager.addRecurringEventDate, style: .date)
                                }
                                .padding()
                            }
                            .background(
                                HStack{
                                    DatePicker("", selection: $contactManager.addRecurringEventDate, displayedComponents: .date)
                                        .datePickerStyle(.wheel)
                                        .frame(width: 300, height: 100)
                                        .clipped()
                                        .background(Color.gray.cornerRadius(10))
                                }
                                .offset(x: -50, y: 90)
                                .opacity(contactManager.showDatePicker ? 1 : 0 )
                                .frame(maxWidth: .infinity)
                            )
                            
                        }
                        .onTapGesture {
                            contactManager.showDatePicker = true
                        }
                        
                        HStack{
                            Text("Zeit:")
                            
                            Spacer()
                            
                            Button {
                                withAnimation {
                                    contactManager.showTimePicker.toggle()
                                }
                            } label: {
                                HStack(spacing: 20){
                                    Image(systemName: "calendar.badge.plus")
                                        .font(.title3)
                                    Text(contactManager.addRecurringEventDate, style: .time)
                                }
                                .padding()
                            }
                            .background(
                                HStack{
                                    DatePicker("", selection: $contactManager.addRecurringEventDate, displayedComponents: .hourAndMinute)
                                        .datePickerStyle(.wheel)
                                        .frame(width: 200, height: 100)
                                        .clipped()
                                        .background(Color.gray.cornerRadius(10))
                                        
                                }
                                .offset(x: -25, y: 90)
                                .opacity(contactManager.showTimePicker ? 1 : 0 )
                                .frame(maxWidth: .infinity)
                            )
                            
                        }
                        .onTapGesture {
                            contactManager.showTimePicker = true
                        }
                    }
                    .padding(.bottom, 250)
                }
                .padding(10)
                .listRowBackground(currentTheme.text.opacity(0.05))
                .foregroundColor(currentTheme.text)
                
                Section {
                    HStack {
                        Button("Cancel") {
                            contactManager.isShowAddContactRhymusSheet.toggle()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        //.background(currentTheme.text.opacity(0.1))
                        .cornerRadius(10)
                            
                        Spacer()
                        
                        Button("Save") {
                            guard contactManager.RecurringEventName != "" else {
                                contactManager.errors.append("Please enter a RecurringEventName!")
                                return print( "Please enter a RecurringEventName!")
                            }
                            guard contactManager.RecurringEventRhytmus != 0.0 else {
                                contactManager.errors.append("Please enter a RecurringEventRhytmus!")
                                return print( "Please enter a RecurringEventRhytmus!")
                            }
                            let ident = contactManager.generateIdentifier()
                            let newRecurringEvents = RecurringEvents(context: PersistenceController.shared.container.viewContext)
                                newRecurringEvents.identifier = ident
                                newRecurringEvents.name = contactManager.RecurringEventName
                                newRecurringEvents.rhymus = contactManager.RecurringEventRhytmus
                            newRecurringEvents.date = contactManager.addRecurringEventDate
                                contact.addToRecurringEvents(newRecurringEvents)
                            
                            if contactManager.RecurringEventRhytmus != 0 {
                                let id:String = ident
                                let titel:String = "Pro Prothese - Reminder"
                                let body:String = "Reminder: \(newRecurringEvents.name ?? "Unknown Name")"
                                let rhytmus:Double = newRecurringEvents.rhymus
                                pushNotificationManager.PushNotificationRepeater(identifier: id, title: titel, body: body, interval: rhytmus)
                            }

                            do {
                                
                                
                                // Save Event in Device Calendar
                                FK_EventProvider.shared.insertRecurringEvent(store: EKEventStore(), event: newRecurringEvents, completionHandler: { res in
                                    //newEvent.eventID = res
                                    print(res)
                                    //events.append(newEvent)
                                })
                                
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
                        .cornerRadius(10)
                        .disabled(contactManager.RecurringEventSubmit)
                    }
                   
                }
                .listRowBackground(currentTheme.text.opacity(0.025))
                .foregroundColor(currentTheme.text)
            }
            
            Spacer()
        }
        .padding(.vertical, 10)
        .scrollContentBackground(.hidden)
        .foregroundColor(currentTheme.text)
        .onAppear{
            contactManager.addRecurringEventDate = Date()
            contactManager.showDatePicker = false
            contactManager.showTimePicker = false
            adSheet.requestInterstitialAds()
        }
        .onChange(of: contactManager.addRecurringEventDate) { newValue in
           withAnimation {
               contactManager.showDatePicker = false
               contactManager.showTimePicker = false
           }
        }// DatePicker
        .fullSizeTop()
        
    }
    
    @ViewBuilder func PrintErrors() -> some View {
        VStack(spacing: 6){
            ForEach(contactManager.contactPersonErrors, id: \.type) { error in
                HStack{
                    Text(error.error)
                        .font(.caption2)
                        .foregroundColor(.red)
                    
                    Spacer()
                }
            }
        }
        .listRowBackground(currentTheme.text.opacity(0.05))
        .padding()
    }

    func convertCNLabeledValueArrayToString(labeledValues: [CNLabeledValue<NSString>]) -> String {
        var resultString = ""

        for labeledValue in labeledValues {
            let _ = CNLabeledValue<NSString>.localizedString(forLabel: labeledValue.label ?? "")
            let value = labeledValue.value as String
            resultString.append("\(value)\n")
        }

        return resultString
    }
    
    func extractMobileNumbers(phoneNumbers: [CNLabeledValue<CNPhoneNumber>]?, get: PhoneType) -> String? {
        var num: String?
        if let numbers = phoneNumbers {
            for phoneNumber in numbers {
                if get == .mobil {
                    if let label = phoneNumber.label, label == CNLabelPhoneNumberMobile {
                        num = phoneNumber.value.stringValue
                    }
                }
                if get == .phone {
                    if let label = phoneNumber.label, label.contains("ork") {
                        num = phoneNumber.value.stringValue
                    }
                }
                
                if get == .work {
                    if let label = phoneNumber.label, label.contains("ork") {
                        num = phoneNumber.value.stringValue
                    }
                }
            }
        }

        return num
    }

    func isValidEmail(value :String) -> Bool {
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: value)
        return result
    }

    /*
     func convertPhoneNumberWithPrefix(number: String, type: String) -> String {
          if number.prefix(1) == "+" {

              if type == "phone" {
                  let predix = (contactManager.counntrys.first(where: { $0.identifier == contactManager.countryPhonePrefix })?.prefix)!
                  
                  contactManager.countryPhonePrefix = contactManager.counntrys.first(where: { $0.prefix == number.prefix(3) } )?.identifier ?? "DE"
                  
                  return predix + number.dropFirst(3)
                  
              } else if type == "mobil" {
                  let predix = (contactManager.counntrys.first(where: { $0.identifier == contactManager.countryMobilPrefix })?.prefix)!
                  
                  contactManager.countryMobilPrefix = contactManager.counntrys.first(where: { $0.prefix == number.prefix(3) } )?.identifier ?? "DE"
                  
                  return predix + number.dropFirst(3)
              } else {
                  return ""
              }
             
              
         } else if number.prefix(2) == "00" {

             if type == "phone" {
                 
                 let predix = (contactManager.counntrys.first(where: { $0.identifier == contactManager.countryPhonePrefix })?.prefix)!
                 
                 let findNr = number.prefix(4).dropFirst(2)
                 
                 contactManager.countryPhonePrefix = contactManager.counntrys.first(where: { $0.prefix == "+\(findNr)" } )?.identifier ?? "DE"
                 
                 var striptedNumber = number.dropFirst(4)
                 
                 if striptedNumber.prefix(1) == "0" {
                     striptedNumber = striptedNumber.dropFirst()
                 }

                 return predix + striptedNumber
                 
             } else if type == "mobil" {
                 
                 let predix = (contactManager.counntrys.first(where: { $0.identifier == contactManager.countryMobilPrefix })?.prefix)!
                 
                 let findNr = number.prefix(4).dropFirst(2)
                 
                 contactManager.countryMobilPrefix = contactManager.counntrys.first(where: { $0.prefix == "+\(findNr)" } )?.identifier ?? "DE"
                 
                 var striptedNumber = number.dropFirst(4)
                 
                 if striptedNumber.prefix(1) == "0" {
                     striptedNumber = striptedNumber.dropFirst()
                 }

                 return predix + striptedNumber
             } else {
                 return ""
             }

         } else if number.prefix(1) == "0" {
             
             if type == "phone" {
                 contactManager.countryPhonePrefix = contactManager.countryPhonePrefix
                 return (contactManager.counntrys.first(where: { $0.identifier == contactManager.countryPhonePrefix })?.prefix)! + number.dropFirst()
             } else if type == "mobil" {
                 contactManager.countryMobilPrefix = contactManager.countryMobilPrefix
                 return (contactManager.counntrys.first(where: { $0.identifier == contactManager.countryMobilPrefix })?.prefix)! + number.dropFirst()
             } else {
                 return ""
             }

         } else {
             return ""
         }
         
     }
     */

    func ValidateForm(newContactPerson : ContactPerson) -> Bool {
        if newContactPerson.title == "---" { contactManager.contactPersonErrors.append((type: "title", error: "Please choose a salutation")) }

        if newContactPerson.firstname!.count < 3 { contactManager.contactPersonErrors.append((type: "firstname", error: "First name should have at least 3 letters.")) }
        
        if newContactPerson.lastname!.count < 3 { contactManager.contactPersonErrors.append((type: "lastname", error: "Last name should have at least 3 letters.")) }
        
        if newContactPerson.phone!.count < 5 { contactManager.contactPersonErrors.append((type: "phone", error: "The phone number is not correct.")) }
        
        if newContactPerson.mobil!.count > 0 && newContactPerson.mobil!.count < 5 { contactManager.contactPersonErrors.append((type: "mobil", error: "The mobile number is not correct.")) }
        
        if isValidEmail(value: newContactPerson.mail!) != true { contactManager.contactPersonErrors.append((type: "mail", error: "The email is not correct.")) }
        
        return contactManager.contactPersonErrors.count == 0 ? true : false
    }
    
    func validatePhoneNumber(_ phoneNumber: String) -> Bool {
        let phoneRegex = "^\\d{10}$" // Regex for a 10-digit phone number
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phoneNumber)
    }
}

enum PhoneType {
    case mobil, phone, work
}

extension String {
    func isValidPhoneNumber() -> Bool {
        let regEx = "^\\+(?:[0-9]?){6,14}[0-9]$"

        let phoneCheck = NSPredicate(format: "SELF MATCHES[c] %@", regEx)
        return phoneCheck.evaluate(with: self)
    }
}
