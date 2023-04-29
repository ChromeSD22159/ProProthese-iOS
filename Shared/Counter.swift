//
//  Counter.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 28.04.23.
//
import Combine
import WatchConnectivity

/*
final class Counter: ObservableObject {
    var session: WCSession
    let delegate: WCSessionDelegate
    let subject = PassthroughSubject<Int, Never>()
    
    @Published private(set) var count: Int = 0
    @Published private(set) var string: String = "0"
    
    init(session: WCSession = .default) {
        self.delegate = SessionDelegater(countSubject: subject)
        self.session = session
        self.session.delegate = self.delegate
        self.session.activate()
        
        subject
            .receive(on: DispatchQueue.main)
            .assign(to: &$count)
    }
        
    
    func send(key: String, value: String) {
        guard WCSession.default.activationState == .activated else {
          return
        }
        #if os(iOS)
        guard WCSession.default.isWatchAppInstalled else {
            return
        }
        #else
        guard WCSession.default.isCompanionAppInstalled else {
            return
        }
        #endif
        
        if (WCSession.default.isReachable) {
            WCSession.default.sendMessage([key : value], replyHandler: nil) { error in
                print("Cannot send message: \(String(describing: error))")
            }
         }
    }
    
    func increment() {
        count += 1
        string = ""
        session.sendMessage(["count": count], replyHandler: nil) { error in
            print(error.localizedDescription)
        }
    }
    
    func decrement() {
        count -= 1
        string = ""
        session.sendMessage(["count": count], replyHandler: nil) { error in
            print(error.localizedDescription)
        }
    }
}
*/
