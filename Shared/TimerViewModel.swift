//
//  TimerViewModel.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 29.04.23.
//

import Foundation
import WatchConnectivity


final class TimerViewModel: NSObject, ObservableObject {
    
    //private var watchConnectivityProvider = WatchConnectivityProvider.shared
    
    var syncService = WatchConnectivityProvider()
    
    @Published var textFieldValue: String = "String"
    
    func sendDataToPhone() {
        if (WCSession.default.isReachable) {
            
            syncService.sendMessage("textFieldValue", textFieldValue, { error in })
  
        }
    }
}

