//
//  WatchConnectivityProvider.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 29.04.23.
//

import Foundation
import WatchConnectivity
import ClockKit

class WatchConnectivityProvider : NSObject, WCSessionDelegate {
    
    private var session: WCSession = .default
    var dataReceived: ((String, Any) -> Void)?
    
    init(session: WCSession = .default) {
        self.session = session

        super.init()

        self.session.delegate = self
        self.connect()
    }
    
    func connect(){
        guard WCSession.isSupported() else {
            print("WCSession is not supported")
            return
        }
        
        session.activate()
    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) { }

    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) { }

    func sessionDidDeactivate(_ session: WCSession) { }
    #endif

    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        guard dataReceived != nil else {
            print("Received data, but 'dataReceived' handler is not provided")
            return
        }
        
        DispatchQueue.main.async {
            if let dataReceived = self.dataReceived {
                for pair in message {
                    dataReceived(pair.key, pair.value)
                }
            }
        }
    }

    func sendMessage(_ key: String, _ message: String, _ errorHandler: ((Error) -> Void)?) {
        if session.isReachable {
            session.sendMessage([key : message], replyHandler: nil) { (error) in
                print(error.localizedDescription)
                if let errorHandler = errorHandler {
                    errorHandler(error)
                }
            }
        }
    }
}
/*
class WatchConnectivityProvider: NSObject, WCSessionDelegate {
    
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
*/
