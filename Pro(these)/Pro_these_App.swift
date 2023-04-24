//
//  Pro_these_App.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 24.04.23.
//

import SwiftUI

@main
struct Pro_these_App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
