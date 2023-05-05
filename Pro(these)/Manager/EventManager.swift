//
//  EventViewManager.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 02.05.23.
//

import SwiftUI
import CoreData

class EventManager: ObservableObject {
    let viewContext = PersistenceController.shared.container.viewContext
    
    @Published var contacts: [Contact] = []
    @Published var events: [Event] = []
    
    @Published var eventsNextWeek: [Event] = []
    @Published var eventsnextmonth: [Event] = []
    @Published var eventsPast: [Event] = []
    
    // sheets
    @Published var isAddContactSheet: Bool = false
    @Published var isAddEventSheet: Bool = false
    @Published var isAddTasktSheet: Bool = false

    
    @Published var addEventIcon = "bandage.fill"
    @Published var addEventDate = Date()
    @Published var addEventContact: Contact?
    @Published var addEventTitel = ""
    @Published var sendEventNotofication = true
    
    /// Contact
    @Published var addContactName = ""
    @Published var addContactPhone = ""
    @Published var addContactEmail = ""
    @Published var addContactEventTitel = ""
    @Published var addContactIcon: String = "bandage.fill"
    @Published var addContactTitel: String = "Klinikum"
    
    @Published var isthisWeekExpand = true
    @Published var isthisMonthExpand = true
    @Published var isPastExpand = false
    @Published var isContactExpand = true
    
    @Published var error = ""
    
    func addContact(){
        //name: String, icon: String, titel: String, phone: String, mail: String
        let newContact = Contact(context: PersistenceController.shared.container.viewContext)
        newContact.name = addContactName
        newContact.phone = addContactPhone
        newContact.mail = addContactEmail
        newContact.icon = addContactIcon
        newContact.titel = addContactTitel
        contacts.append(newContact)
        do {
            try PersistenceController.shared.container.viewContext.save()
            self.isAddContactSheet = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.addContactIcon = ""
                self.addContactIcon = ""
                self.addContactName = ""
                self.addContactPhone = ""
                self.addContactEmail = ""
            }
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
      
    }
    
    func addEvent(){
        guard addEventTitel != "" else {
            return error = "Bitte gebe eine Terminbeschreibung ein!"
        }
        guard addEventContact != nil else {
            return error = "Bitte gebe einen Kontakt an!"
        }
        let newEvent = Event(context: viewContext)
        newEvent.eventID = UUID().uuidString
        newEvent.titel = addEventTitel
        newEvent.icon = addEventIcon
        newEvent.date = addEventDate
        newEvent.tasks = nil
        newEvent.contact = addEventContact
        events.append(newEvent)

        do {
            try PersistenceController.shared.container.viewContext.save()
            if let unwrapped = addEventContact?.name! {
                guard !sendEventNotofication else {
                    let bodyText = "Du hast am \(convertDateToNotoficationString(addEventDate))Uhr einen Termin bei \(String(describing: unwrapped)) ✌️. Komm vorbei und sehe dir deine Notizen an. 😉"
                    
                    PushNotificationManager().PushNotificationByAddEvent(
                        identifier: newEvent.eventID!,
                        title: AppConfig().AppName,
                        body: bodyText,
                        triggerDate: addEventDate,
                        repeater: false)
                    
                    return
                }
            }
            
            self.addEventTitel = ""
            self.addEventIcon = "bandage.fill"
            self.addEventDate = Date()
            self.error = ""
            fetchContacts()
            self.isAddEventSheet = false
            
           
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func fetchContacts() {
        let fetchContacts = NSFetchRequest<Contact>(entityName: "Contact")
        fetchContacts.sortDescriptors = [NSSortDescriptor(key: "name", ascending: false)]
        
        let fetchEvents = NSFetchRequest<Event>(entityName: "Event")
        fetchEvents.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]

        do {
            contacts = try PersistenceController.shared.container.viewContext.fetch(fetchContacts)
            events = try PersistenceController.shared.container.viewContext.fetch(fetchEvents)
            print(events.count)
            sortAllEvents()
        }catch {
          print("DEBUG: Some error occured while fetching Times")
        }
    }
    
    func sortAllEvents() {
        contacts = contacts
        eventsPast = events.filter{ $0.date ?? Date() < Date.now }
        eventsNextWeek = events.filter { $0.date ?? Date() > Date.now && $0.date ?? Date() < Date.now.sevenDaysOut }
        eventsnextmonth = events.filter { $0.date ?? Date() > Date.now.sevenDaysOut && $0.date ?? Date() < Date.now.thirtyDaysOut }
    }

    func deleteContact(_ contact: Contact) {
        withAnimation {
            viewContext.delete(contact)
            do {
                try viewContext.save()
                fetchContacts()
                sortAllEvents()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }

        }
    }
    
    func deleteEvent(_ event: Event) {
        withAnimation {
            viewContext.delete(event)
            
            if event.eventID != nil {
                print("Notofication with \(String(describing: event.eventID)) deleted")
                PushNotificationManager().removeNotification(identifier: event.eventID!)
            }
            
            do {//events.filter { $0.id == event.id }.forEach(PersistenceController.shared.container.viewContext.delete)
                try viewContext.save()
                sortAllEvents()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func deleteTask(_ task: EventTasks) {
        withAnimation{
            viewContext.delete(task)
              do {
                  try viewContext.save()
                  sortAllEvents()
              } catch {
                  let nsError = error as NSError
                  fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
              }
        }
    }

    func convertDateToNotoficationString(_ d: Date) -> String {
        let dFormatter = DateFormatter()
        dFormatter.locale = Locale(identifier: "de_DE")
        dFormatter.dateFormat = "dd.MMM.yyyy"
        let newDate = dFormatter.date(from: dFormatter.string(from: d))!
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "de_DE")
        formatter.dateFormat =  "HH:mm"
        let newTime = formatter.date(from: formatter.string(from: d))!
        
        print("\(dFormatter.string(from: newDate)) um \(formatter.string(from: newTime))")
        return "\(dFormatter.string(from: newDate)) um \(formatter.string(from: newTime))"
    }
}


// Convenience methods for dates.
extension Date {
    var sevenDaysOut: Date {
        Calendar.autoupdatingCurrent.date(byAdding: .day, value: 7, to: self) ?? self
    }
    
    var thirtyDaysOut: Date {
        Calendar.autoupdatingCurrent.date(byAdding: .day, value: 30, to: self) ?? self
    }
}



/* Add Notification
 if let unwrapped = addEventContact?.name! {
     guard !sendEventNotofication else {
         let date = Calendar.current.date(byAdding: .day, value: -1, to: addEventDate)
         let bodyText = "Termin Erinnerung: \(convertDateToNotoficationString(addEventDate)), bei \(String(describing: unwrapped))"
         
         PushNotificationManager().PushNotificationByAddEvent(
             identifier: newEvent.eventID!,
             title: AppConfig().AppName,
             body: bodyText,
             triggerDate: date!,
             repeater: false)
         
         return
     }
 }
 */
