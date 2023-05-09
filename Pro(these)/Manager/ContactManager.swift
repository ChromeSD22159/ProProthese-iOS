//
//  SwiftUIView.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 08.05.23.
//

import SwiftUI

class ContactManager: ObservableObject {
    @StateObject var eventManager = EventManager()
    let viewContext = PersistenceController.shared.container.viewContext
    
    @Published var armed = true
    @Published var errors: [String] = []
    
    @Published var isShowAddContactPersonSheet = false
    @Published var title = ""
    @Published var firstname = ""
    @Published var lastname = ""
    @Published var phone = ""
    @Published var mobil = ""
    @Published var email = ""
    
    @Published var isShowAddContactRhymusSheet = false
    @Published var RecurringEventName = ""
    @Published var RecurringEventRhytmus:Double = 0.0
    
    var RecurringEventSubmit: Bool {
        if RecurringEventName != "" && RecurringEventRhytmus != 0 {
            return false
        } else {
            return true
        }
    }
    
    func printRhymus(_ double:Double) -> String {
        switch double {
            case 0 : return "0"
            case 60 : return "jede Minute"
            case 300 : return "alle 5 Minute"
            case 604800.0 : return "Wöchentlich"
            case 1209600.0 : return "Monatlich"
            case 2630000.0 : return "Quatal"
            case 7890000.0 : return "Halbjährlich"
            default: return "0"
        }
    }
    
    func generateIdentifier() -> String {
        let randomString = UUID().uuidString //0548CD07-7E2B-412B-AD69-5B2364644433
        return randomString.replacingOccurrences(of: "-", with: "")
    }
   
}
