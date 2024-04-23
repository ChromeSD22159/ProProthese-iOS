//
//  ContentAddSheetBoby.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 04.05.23.
//

import SwiftUI
import ContactsUI
import Contacts

struct ContentAddSheetBoby: View {
    @EnvironmentObject var appConfig: AppConfig
    @EnvironmentObject var eventManager: EventManager
    @EnvironmentObject var contactManager: ContactManager
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var tabManager: TabManager
    @EnvironmentObject var adSheet: GoogleInterstitialAd
    @Environment(\.presentationMode) var presentationMode
    
    private let persistenceController = PersistenceController.shared
    
    @Binding var isAddContactSheet:Bool
    
    @FetchRequest(
        sortDescriptors: []
    ) var allContacts: FetchedResults<Contact>
    
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }

    
    @State var addContactName = ""
    @State var addContactPhone = ""
    @State var addContactEmail = ""
    @State var addContactTitel = "Others"
    @State var addEventIcon = ""
    @State var ShakeState: Bool = false
    @State var ishasProFeatureSheet = false
    @FocusState var ContactInFocus
    
    var titel: String
    
    var contact: Contact? = nil
    
    var body: some View {
        ZStack{
            if let co = contact {
                editContact(co)
                    .opacity(ShakeState ? 0 : 1)
            } else {
                createContact()
                    .opacity(ShakeState ? 0 : 1)
            }
            
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(currentTheme.text)
                .opacity(ShakeState ? 1 : 0)
                .modifier(Shake(animatableData: CGFloat(ShakeState ? 1 : 0 )))
        }
        .sheetModifier(isSheet: $eventManager.loadContact, sheetContent: {
            ContactPickerView(isPresented: $eventManager.loadContact, selectedContact: $eventManager.selectedContact).ignoresSafeArea()
        }, dismissContent: {})
        .sheetModifier(showAds: false, isSheet: $ishasProFeatureSheet, sheetContent: {
            ShopSheet(isSheet: $ishasProFeatureSheet)
        }, dismissContent: {})
        .fullSizeTop()
        .onAppear {
            adSheet.requestInterstitialAds()
            print("View appeared: \(self)")
        }
        .onChange(of: eventManager.selectedContact, perform: { newContact in
            
            if let departmentName = newContact?.departmentName {
                addContactName = departmentName
            }
            
            if let organizationName = newContact?.organizationName {
                addContactName = organizationName
            }
            
            if let phoneNumbers = extractMobileNumbers(phoneNumbers: newContact?.phoneNumbers ?? nil, get: .mobil)  {
                addContactPhone = phoneNumbers
            }
            
            if let phoneNumbers = extractMobileNumbers(phoneNumbers: newContact?.phoneNumbers ?? nil, get: .phone)  {
                addContactPhone = phoneNumbers
            }
            
            if let emailAddresses = newContact?.emailAddresses {
                addContactEmail = convertCNLabeledValueArrayToString(labeledValues: emailAddresses)
            }
        })
        .onDisappear(perform: {
            self.addContactName = ""
            self.addContactPhone = ""
            self.addContactEmail = ""
            self.addContactTitel = "Others"
            self.addEventIcon = ""
            
            eventManager.selectedContact = nil
        })
    }
    
    @ViewBuilder func editContact(_ contact: Contact) -> some View {
        
        ScrollView(showsIndicators: false) {
            VStack(spacing: 10){
                HStack{
                    Text("Edit Contact")
                        .foregroundColor(currentTheme.text)
                }
                .padding(.top)
                
                Spacer(minLength: 20)
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        DispatchQueue.main.async(execute: {
                            eventManager.loadContact.toggle()
                        })
                    }, label: {
                        Label(eventManager.selectedContact == nil ? "Import Contact" : "\(eventManager.selectedContact?.givenName ?? "") \(eventManager.selectedContact?.familyName ?? "")", systemImage: "person.crop.rectangle.badge.plus")
                    })
                    .padding()
                    .background(.ultraThinMaterial)
                    .foregroundColor(currentTheme.text)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                VStack {
                    HStack{
                        Text("Name:")
                        
                        TextField( text: $addContactName, prompt: Text("Name")) {
                               Text("Name")
                           }
                       // .focused($ContactInFocus, equals: .name)
                        .disableAutocorrection(true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .foregroundColor(currentTheme.text)
                    .cornerRadius(10)
                    
                    
                    HStack{
                        Text("Phone:")
                        
                        TextField( text: $addContactPhone, prompt: Text("Phone")) {
                               Text("Phone:")
                        }
                        .keyboardType(.numberPad)
                        //.focused($ContactInFocus, equals: .phone)
                        .disableAutocorrection(true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .foregroundColor(currentTheme.text)
                    .cornerRadius(10)
                
                    
                    HStack{
                        Text("E-Mail:")
                        
                        TextField( text: $addContactEmail, prompt: Text("E-Mail:")) {
                            Text("E-Mail:")
                        }
                       // .focused($ContactInFocus, equals: .mail)
                        .disableAutocorrection(true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .foregroundColor(currentTheme.text)
                    .cornerRadius(10)
                    
                    
                    HStack{
                        Text("Description")
                        
                        Spacer()
                        
                        Picker("Titel", selection: $addContactTitel) {
                            ForEach(eventManager.contactTypes, id: \.type) { contact in
                                Text(contact.name).tag("\(contact.type)")
                            }
                        }.tint(currentTheme.text)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .foregroundColor(currentTheme.text)
                    .cornerRadius(10)
                }
                .padding(.horizontal, 10)
                .foregroundColor(currentTheme.text)
                
                
                HStack {
                    Button("Cancel") {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .textCase(.uppercase)
                    .background(currentTheme.text.opacity(0.05))
                    .foregroundColor(currentTheme.text)
                    .cornerRadius(10)
                    .opacity(0)
                    
                    Button("Save") {

                        contact.name = self.addContactName
                        contact.phone = self.addContactPhone
                        contact.mail = self.addContactEmail
                        contact.titel = self.addContactTitel
                        contact.icon = self.addEventIcon
                        
                        do {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                                self.ShakeState = true
                            })
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                self.ShakeState = false
                                self.presentationMode.wrappedValue.dismiss()
                            })
                            
                            try? persistenceController.container.viewContext.save()
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .textCase(.uppercase)
                    .background(currentTheme.text.opacity(0.05))
                    .foregroundColor(currentTheme.text)
                    .cornerRadius(10)
                }
                .padding(.horizontal)

                Button(action: {
                    DispatchQueue.main.async {
                        ishasProFeatureSheet = true
                    }
                }, label: {
                    GetProCard()
                })
                .show(allContacts.count > 2 && !AppConfig.shared.hasPro)
                
                // In-App-ABO
                InfomationField( // In-App-ABO
                    backgroundStyle: .ultraThinMaterial,
                    text: "The contact details refer to the general contact information such as \"Headquarters\". You can add additional contacts later.",
                    foreground: currentTheme.text,
                    visibility: AppConfig.shared.hasUnlockedPro ? appConfig.hideInfomations : true
                )
                .padding(.horizontal)
            }
            .padding(.vertical, 10)
            .scrollContentBackground(.hidden)
            .foregroundColor(currentTheme.text)
            .onAppear {
                self.addContactName = contact.name ?? ""
                self.addContactPhone = contact.phone ?? ""
                self.addContactEmail = contact.mail ?? ""
                self.addContactTitel = contact.titel ?? "Others"
                self.addEventIcon = contact.icon ?? ""
            }
        }
     
    }
    
    @ViewBuilder func createContact() -> some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 10){
                HStack{
                    Text("New Contact")
                        .foregroundColor(currentTheme.text)
                }
                .padding(.top)
                
                Spacer(minLength: 20)
                
                HStack {
                    Spacer()
                    
                    Button(action: {
                        DispatchQueue.main.async(execute: {
                            eventManager.loadContact.toggle()
                        })
                    }, label: {
                        Label(eventManager.selectedContact == nil ? "Import Contact" : "\(eventManager.selectedContact?.givenName ?? "") \(eventManager.selectedContact?.familyName ?? "")", systemImage: "person.crop.rectangle.badge.plus")
                    })
                    .padding()
                    .background(.ultraThinMaterial)
                    .foregroundColor(currentTheme.text)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                VStack {
                    HStack{
                        Text("Name:")
                        
                        TextField( text: $addContactName, prompt: Text("Name")) {
                               Text("Name")
                           }
                        //.focused($ContactInFocus, equals: .name)
                        .disableAutocorrection(true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .foregroundColor(currentTheme.text)
                    .cornerRadius(10)
                    
                    
                    HStack{
                        Text("Phone:")
                        
                        TextField( text: $addContactPhone, prompt: Text("Phone")) {
                           Text("Phone:")
                        }
                        .keyboardType(.numberPad)
                        .disableAutocorrection(true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .foregroundColor(currentTheme.text)
                    .cornerRadius(10)
                
                    
                    HStack{
                        Text("E-Mail:")
                        
                        TextField( text: $addContactEmail, prompt: Text("E-Mail:")) {
                            Text("E-Mail:")
                        }
                       // .focused($ContactInFocus, equals: .mail)
                        .disableAutocorrection(true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .foregroundColor(currentTheme.text)
                    .cornerRadius(10)
                    
                    
                    HStack{
                        Text("Description")
                        
                        Spacer()
                        
                        Picker("Titel", selection: $addContactTitel) {
                            ForEach(eventManager.contactTypes, id: \.type) { contact in
                                Text(contact.name).tag("\(contact.type)")
                            }
                        }.tint(currentTheme.text)
                    }
                    .padding()
                    .background(.ultraThinMaterial)
                    .foregroundColor(currentTheme.text)
                    .cornerRadius(10)
                }
                .padding(.horizontal, 10)
                .foregroundColor(currentTheme.text)
                
                HStack {
                    Button("Cancel") {
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .textCase(.uppercase)
                    .background(.ultraThinMaterial)
                    .foregroundColor(currentTheme.text)
                    .cornerRadius(10)
                    .opacity(0)
                    
                    Button(action: {
                        guard allContacts.count < 2 && AppConfig.shared.hasPro else { return ishasProFeatureSheet.toggle() }
                        guard self.addContactName != "" else { return }
                        
                        let new = Contact(context: persistenceController.container.viewContext)
                        new.name = self.addContactName
                        new.phone = self.addContactPhone
                        new.mail = self.addContactEmail
                        new.titel = self.addContactTitel
                        new.icon = self.addEventIcon
                        
                        do {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                                self.ShakeState = true
                            })
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                self.ShakeState = false
                                self.presentationMode.wrappedValue.dismiss()
                            })
                            
                            try? persistenceController.container.viewContext.save()
                        }
                    }, label: {
                        HStack {
                            Text("Save")
                                .foregroundColor(currentTheme.text)
                                .textCase(.uppercase)
                            
                            TextBadge(text: "pro")
                        }
                    })
                    .padding()
                    .frame(maxWidth: .infinity)
                    .textCase(.uppercase)
                    .background(.ultraThinMaterial)
                    .foregroundColor(currentTheme.text)
                    .cornerRadius(10)
                }
                .padding(.horizontal)

                
                Button(action: {
                    DispatchQueue.main.async {
                        ishasProFeatureSheet = true
                    }
                }, label: {
                    GetProCard()
                })
                .show(allContacts.count > 2 && !AppConfig.shared.hasPro)
                
                // In-App-ABO
                InfomationField( // In-App-ABO
                    backgroundStyle: .ultraThinMaterial,
                    text: "The contact details refer to the general contact information such as \"Headquarters\". You can add additional contacts later.",
                    foreground: currentTheme.text,
                    visibility: AppConfig.shared.hasUnlockedPro ? appConfig.hideInfomations : true
                )
                .padding(.horizontal)
            }
            .padding(.vertical, 10)
            .scrollContentBackground(.hidden)
            .foregroundColor(currentTheme.text)
        }
    }
    
    @ViewBuilder func GetProCard() -> some View {
        HStack(alignment: .center, spacing: 20) {
            Image(systemName: "sparkles")
                .font(.largeTitle)
            
            VStack {
                HStack {
                    Text("Add even more contacts")
                        .font(.headline.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                }
                
                HStack {
                    Text("In the free version of our app you can add and manage up to three contacts.")
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
        }
        .foregroundColor(currentTheme == Theme.orange ? currentTheme.text : currentTheme.primary)
        .padding(.vertical, 6)
        .padding(.horizontal)
        .background(currentTheme.hightlightColor.gradient)
        .cornerRadius(10)
        .padding(.horizontal, 20)
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
}
