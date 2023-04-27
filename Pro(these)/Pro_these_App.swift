

import SwiftUI
import HealthKit
import Combine
import Foundation

@main
struct Pro_theseApp: App {
    @Environment(\.scenePhase) var scenePhase
    
    let persistenceController = PersistenceController.shared
    let healthStorage = HealthStorage()
    let pushNotificationManager = PushNotificationManager()
    let stepCounterManager = StepCounterManager()
    let stopWatchManager = StopWatchManager()
    var healthStore: HealthStore?
    
    @AppStorage("Days") var fetchDays:Int = 7
    @State private var LaunchScreen = true
    init() {
        pushNotificationManager.registerForPushNotifications()
        healthStore = HealthStore()
    }
    
    
    var body: some Scene {
        WindowGroup {
            ZStack{
                
                ContentView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
                    .environmentObject(AppConfig())
                    .environmentObject(TabManager())
                    .environmentObject(healthStorage)
                    .environmentObject(stepCounterManager)
                    .environmentObject(pushNotificationManager)
                    .environmentObject(stopWatchManager)
                    .onChange(of: scenePhase) { newPhase in
                        if newPhase == .active {
                            loadData(days: healthStorage.fetchDays)
                            pushNotificationManager.removeNotificationsWhenAppLoads()
                        } else if newPhase == .inactive {
                            
                        } else if newPhase == .background {
                            print("APP changed to Background")
                            if !AppConfig().PushNotificationDisable {
                                pushNotificationManager.setUpNonPermanentNotifications()
                            }
                        }
                    }
                    .onChange(of: fetchDays){ new in
                        loadData(days: new)
                    }
                
             
                if LaunchScreen {
                    ZStack{
                        Image("LaunchImage")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipped()
                            .ignoresSafeArea()
                        
                        VStack{
                            HStack{
                                Image("prothesis")
                                    .imageScale(.large)
                                    .font(Font.system(size: 40, weight: .heavy))
                                    .foregroundColor(.white)
                                    .padding(.leading, 20)
                            }
                            .frame(alignment: .center)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .ignoresSafeArea()
                }

             
            }
            .onAppear{
                stopWatchManager.fetchTimesData()
                stepCounterManager
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                    withAnimation(.easeOut(duration: 2.0)) {
                        LaunchScreen = false
                    }
                })
            }
        }
    }
    
    func loadData(days: Int) {
        if let healthStore = healthStore {
            healthStore.requestAuthorization { success in
                if success {
                    
                    healthStore.getDistance { statisticsCollection in
                       let startDate =  Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -(days-1), to: Date())!)
                        
                        var arr = [Double]()
                        var distances = [Double]()
                        if let statisticsCollection = statisticsCollection {
                            
                            statisticsCollection.enumerateStatistics(from: startDate, to: Date()) { (statistics, stop) in
                                let count = statistics.sumQuantity()?.doubleValue(for: HKUnit.meter())
                                arr.append(count ?? 0)
                                distances.append(count ?? 0)
                            }
                            
                        }
                        
                        DispatchQueue.main.async {
                            healthStorage.showDistance = distances.last! // Update APPStorage for distance in HomeTabView
                            healthStorage.Distances = distances
                        }
                        
                    }
   
                    healthStore.calculateSteps { statisticsCollection in
                        if let statisticsCollection = statisticsCollection {
                            // update the UI
                            let startDateNew =  Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -(days-1), to: Date())!)
                            let endDateNew = Date()
                            var StepsData: [Step] = [Step]()
                            statisticsCollection.enumerateStatistics(from: startDateNew, to: endDateNew) { (statistics, stop) in
                                let count = statistics.sumQuantity()?.doubleValue(for: .count())
                                let step = Step(count: Int(count ?? 0), date: statistics.startDate, dist: nil)
                                StepsData.append(step)
                            }

                            
                            DispatchQueue.main.async {
                                healthStorage.showStep = StepsData.last?.count ?? 0 // Update APPStorage for Circle in HomeTabView
                                healthStorage.Steps = StepsData
                                healthStorage.StepCount = StepsData.count
                                healthStorage.showDate = StepsData.last?.date ?? Date()
                            }
                           
                            
                        }
                    }
                   
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        mergeArray()
                    })
                }
            }
        }
    }
    
    func mergeArray(){
        let distances = healthStorage.Distances
        var steps = healthStorage.Steps
        
        var newSteps: [Step] = [Step]()

        for (index, step) in steps.enumerated() {
            let newStep = Step(count: step.count, date: step.date, dist: distances[index])
            newSteps.append(newStep)
        }
        steps.removeAll(keepingCapacity: false)
        healthStorage.Steps = newSteps
    }
    
}

extension Publisher where Output: Sequence {
    public func mapArray<Input, Out>(_ transform: @escaping (Input) -> Out) -> Publishers.Map<Self, [Out]> where Output.Element == Input {
        map { $0.map { transform($0) } }
    }
}

