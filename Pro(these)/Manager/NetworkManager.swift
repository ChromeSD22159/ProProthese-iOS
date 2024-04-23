//
//  NetworkManager.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 13.10.23.
//

import SwiftUI
import Foundation
import Network

class NetworkMonitor: ObservableObject {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    var isConnected = false

    init() {
        networkMonitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
        networkMonitor.start(queue: workerQueue)
    }
    
    func measureDownloadSpeed(urlString: String ,completion: @escaping (Double?) -> Void) {
        guard isConnected else { return }
        
        guard urlString != "" || !urlString.isEmpty else { return completion(0.0) }
        
        let url = URL(string: urlString)!

        let startTime = CFAbsoluteTimeGetCurrent()
        let downloadTask = URLSession.shared.downloadTask(with: url) { _, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200 else {
                completion(nil)
                return
            }

            let endTime = CFAbsoluteTimeGetCurrent()
            let elapsed = endTime - startTime
            let fileSize = Double(response.expectedContentLength) / 1024.0 / 1024.0 // in MB
            let speed = fileSize / elapsed // MB/s

            completion(speed)
        }

        downloadTask.resume()
    }
}

enum NetworkConnectionType: LocalizedStringKey {
    case wifi = "Internet connection via WiFi"
    case cellular = "Internet connection via mobile network"
    case none = "No Internet connection"
}
