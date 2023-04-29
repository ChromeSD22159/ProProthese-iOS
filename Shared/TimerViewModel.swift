//
//  TimerViewModel.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 29.04.23.
//

import Foundation
import WatchConnectivity

final class TimerViewModel: NSObject, ObservableObject {
    
    private var watchConnectivityProvider = WatchConnectivityProvider.shared
    
    @Published var textFieldValue: String = "String"
    
    func sendDataToPhone() {
        if (WCSession.default.isReachable) {
            //watchConnectivityProvider.send(["textFieldValue": textFieldValue])
            WCSession.default.sendMessage(["textFieldValue": textFieldValue], replyHandler: { dictionary in
                print(">WC> reply recieved: \(dictionary.first!.value)")
            }, errorHandler: { error in
                print(">WC> Error on sending Msg: \(error.localizedDescription)")
            })
        }
    }
}
