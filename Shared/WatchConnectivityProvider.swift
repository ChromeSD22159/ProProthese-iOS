//
//  WatchConnectivityProvider.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 29.04.23.
//

import Foundation
import WatchConnectivity


class WatchConnectivityProvider: NSObject {
    
    static let shared = WatchConnectivityProvider()

    private let session: WCSession
    
    var textFieldValue: String = "String"
    
    init(session: WCSession = .default) {
        self.session = .default
       super.init()
       self.session.delegate = self
       self.connect()
    }

    func connect() {
        guard WCSession.isSupported() else {
            print("WCSession is not supported")
            return
        }
       
        session.activate()
    }

    func send(_ message: [String:Any]) -> Void {
        session.sendMessage(message, replyHandler: nil) { (error) in
            print("Error: ") // \(error.localizedDescription)
        }
    }
}

extension WatchConnectivityProvider: WCSessionDelegate {
    
    // Receiver
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
       //without reply handler
    }

    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
       //with reply handler
    }
    // end Receiver
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        debugPrint("WCSession activationDidCompleteWith activationState:\(activationState) error:\(String(describing: error))")
       // debugPrint("WCSession.isPaired: \(session.isPaired), WCSession.isWatchAppInstalled: \(session.isWatchAppInstalled)")
    }
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {
        debugPrint("sessionDidBecomeInactive: \(session)")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        debugPrint("sessionDidDeactivate: \(session)")
    }

    func sessionWatchStateDidChange(_ session: WCSession) {
        debugPrint("sessionWatchStateDidChange: \(session)")
    }
    #endif
}
