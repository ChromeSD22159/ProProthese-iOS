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
                
                CircleAnimation(delay: 1, duration: 2)
                    .opacity(0.2)
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
      
    }

   
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        //ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
        Text("")
    }
}
