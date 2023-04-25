//
//  ContentView.swift
//  Pro Prothese
//
//  Created by Frederik Kohler on 23.04.23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @EnvironmentObject private var tabManager: TabManager
    @EnvironmentObject private var healthStore: HealthStorage
    
  
    
    var body: some View {
        
        NavigationView {
            ZStack {
                AppConfig().backgroundGradient
                    .ignoresSafeArea()
                
                VStack(){
                    
                    switch tabManager.currentTab {
                    case .home: StepCounterView()
                    case .step: StepCounterView()
                    case .timer: StopWatchView()
                    case .more: NavigationStackView()
                    }
                    
                    TabStack()
                }
                .foregroundColor(AppConfig().foreground)
                
            }
        }
        /*
         List {
             ForEach(items) { item in
                 NavigationLink {
                     Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                 } label: {
                     Text(item.timestamp!, formatter: itemFormatter)
                 }
             }
             .onDelete(perform: deleteItems)
         }
         .toolbar {
             ToolbarItem(placement: .navigationBarTrailing) {
                 EditButton()
             }
             ToolbarItem {
                 Button(action: addItem) {
                     Label("Add Item", systemImage: "plus")
                 }
             }
         }
         Text("Select an item")
         */
      
    }

   
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
