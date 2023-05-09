//
//  StopWatchManager.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 25.04.23.
//

import SwiftUI
import CoreData
import ActivityKit
import Foundation

class StopWatchManager : ObservableObject {
    // Timer States
    @Published var wearingTimerMessage = "Not running"
    @Published var wearingTimerisRunning = false
    private var wearingTimerStartTime: Date?
    
    // Stored Timer States
    @Published var timesArray: [WearingTimes] = []

    var waeringTimes: [ProthesenTimes] {
        var GroupedAndSumArray:[ProthesenTimes] = []
        let dictionary = Dictionary(grouping: timesArray.reversed(), by: { Calendar.current.startOfDay(for: $0.timestamp ?? Date() ) })
        let _: [()] = dictionary.map { GroupedAndSumArray.append(ProthesenTimes(date: $0.key, duration: $0.value.map({ $0.duration }).reduce(0, +)) ) }
        // Ordnet das Array nach der Zeit
        return GroupedAndSumArray.sorted { itemA, itemB in
            return itemA.date > itemB.date
        }
        
    }
    
    var waeringTimesYesterday: String {
        let yesterday = timesArray.filter { Calendar.current.isDateInYesterday( $0.timestamp ?? Date()) }
        return convertSecondsToHrMinuteSec(seconds: yesterday.map { Int($0.duration) }.reduce(0, +))
    }
    
    var waeringTimesToday: String {
        let today = timesArray.filter { Calendar.current.isDateInToday( $0.timestamp ?? Date()) }
        return convertSecondsToHrMinuteSec(seconds: today.map { Int($0.duration) }.reduce(0, +) )
    }
    
    var waeringTimesTodayInSeconds: Double {
        let today = timesArray.filter { Calendar.current.isDateInToday( $0.timestamp ?? Date()) }
        return today.map { Double($0.duration) }.reduce(0, +)
    }
    
    var waeringTimesAvgTimes: Int {
        let days = waeringTimes.count
        let secs = waeringTimes.map { $0.duration }.reduce(0,+)
        
        guard days != 0 else {
            return 0
        }
        let avg = (Int(secs) / days)
        return avg
    }
  
    
    // Chart
    @Published var activeDateCicle: Date = Date()
    @Published var dragAmount = CGSize.zero
    @Published var devideSizeWidth: CGFloat = 0
    @Published var activeisActive = false
    var fetchDays:Int = 7
    
    init() {
        wearingTimerStartTime = storedStartTime()
        
       if wearingTimerStartTime != nil {
           restart(time: wearingTimerStartTime!)
       }
    }
    
    func fetchTimesData() {
        let requesttimestamps = NSFetchRequest<WearingTimes>(entityName: "WearingTimes")
        let sort = NSSortDescriptor(key: "timestamp", ascending: false)
        
        let startDate = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -7, to: Date())!)
        let endDate = Calendar.current.date(byAdding: .day, value: 0, to: Date())!
        let predicate = NSPredicate(format: "timestamp >= %@ AND timestamp < %@", argumentArray: [startDate, endDate] )
        
        requesttimestamps.sortDescriptors = [sort]
        requesttimestamps.predicate = predicate
        do {
            timesArray = try PersistenceController.shared.container.viewContext.fetch(requesttimestamps)
        }catch {
          print("DEBUG: Some error occured while fetching Times")
        }
    }

    func deleteItems(offsets: IndexSet) {
       withAnimation {
           offsets.map { self.timesArray[$0] }.forEach(PersistenceController.shared.container.viewContext.delete)

           do {
               try PersistenceController.shared.container.viewContext.save()
           } catch {
               // Replace this implementation with code to handle the error appropriately.
               // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
               let nsError = error as NSError
               fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
           }
       }
    }
      
    func convertSecondsToHrMinuteSec(seconds:Int) -> String{
       let formatter = DateComponentsFormatter()
       formatter.allowedUnits = [.hour, .minute, .second]
      //formatter.unitsStyle = .full
      formatter.unitsStyle = .abbreviated
      
       let formattedString = formatter.string(from:TimeInterval(seconds))!
       return formattedString
      }
  
    func getDuration(data: Date) -> Int32 {
        let elapsed = Date().timeIntervalSince(data)
        let duration = Int(elapsed)
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .abbreviated
        formatter.allowedUnits = [ .second]
        return Int32(duration)
    }
    
    func restart(time: Date){
        wearingTimerStartTime = time
        wearingTimerisRunning = true
        wearingTimerMessage = "Is running"
        //LiveActivityStart()
 }
    
    func wearingTimerStart(){
        if wearingTimerStartTime == nil {
            wearingTimerStartTime = Date.now
            wearingTimerisRunning = true
            wearingTimerMessage = "Is running"
            if wearingTimerStartTime != nil {
                UserDefaults.standard.set(Date.now, forKey: "startTime")
            }
        }
    }
    
    func wearingTimerStop(){
        wearingTimerStartTime = nil
        wearingTimerisRunning = false
        wearingTimerMessage = "Not running"
        let DateData = UserDefaults.standard.object(forKey: "startTime") as? Date ?? nil
        if DateData != nil {
            
            let endTime = getDuration(data: DateData!)
            addWearingTime(time: DateData!, duration: endTime)
        }
        
        UserDefaults.standard.set(nil, forKey: "startTime")
    }
    
    func addWearingTime(time: Date, duration: Int32) {
        let newTime = WearingTimes(context: PersistenceController.shared.container.viewContext)
        newTime.timestamp = time
        newTime.duration = duration
        timesArray.append(newTime)
        do {
            try PersistenceController.shared.container.viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    func addDummyTimes(times: Int) {
        let date = Calendar.current.date(byAdding: .day, value: -times, to: Date())
        let duration = Int32.random(in: 1000..<15480)
        addWearingTime(time: date!, duration: duration)
    }

    func storedStartTime() -> Date? {
        UserDefaults.standard.object(forKey: "startTime") as? Date
    }

    func chartCalcItemSize() -> CGFloat {
        let days = AppConfig().fetchDays
        let itemSize = (devideSizeWidth / 7)
        return itemSize * CGFloat(days)
    }
    
    func chartMaxValue(margin: Int) -> ClosedRange<Int> {
        let maXsecs = waeringTimes.map { $0.duration }.max()
        let withMargin = Int(maXsecs ?? 65000) + margin
        return 0...withMargin
    }
}

struct ProthesenTimes: Identifiable {
    var id: Date { date }
    var date: Date
    var duration: Int32
}

/*
 
 // Live Activity old
// @State var activity: Activity<Prothesen_widgetAttributes>? = nil
 
 // Live Activity new
 //@State var activityTimeTracking: Activity<TimeTrackingAttributes>? = nil
 
 func LiveActivityStart(){
     if ActivityAuthorizationInfo().areActivitiesEnabled {
         print(ActivityAuthorizationInfo().areActivitiesEnabled)
         if #available(iOS 16.2, *) {
             let attributes = TimeTrackingAttributes()
             guard let startTime else { return }
             let state = TimeTrackingAttributes.ContentState(isRunning: true, timeStamp: startTime, state: "Zeichnet auf", endTime: "")
             
             do {
                 let res = try? Activity<TimeTrackingAttributes>.request(attributes: attributes, content: ActivityContent(state: state, staleDate: Date()), pushType: nil)
                 print("Requested Live Activity \(String(describing: res?.id)).")
               } catch (let error) {
                   print("Error requesting pizza delivery Live Activity \(error.localizedDescription).")
               }
             
           
         } else {
             let attributes = Prothesen_widgetAttributes()
             let state = Prothesen_widgetAttributes.ProthesenTimerStatus(isRunning: true, timeStamp: Date.now, state: "Zeichnet auf", endTime: "" )
             let res = try? Activity<Prothesen_widgetAttributes>.request(attributes: attributes, contentState: state, pushType: nil)
             print("Requested a LiveRecordTimer - Live Activity (till 16.1) \(String(describing: res?.id)).")
         }
     }
     
 }

 func liveActivityStop(isRunning: Bool, endTime: String){
        if #available(iOS 16.2, *) { // Run code in iOS 16.2 or later.
            guard let startTime else { return }
            let state = TimeTrackingAttributes.ContentState(isRunning: isRunning, timeStamp: startTime, state: "Beendet", endTime: endTime)

            Task {
                await activityTimeTracking?.end(ActivityContent(state: state, staleDate: Date()), dismissalPolicy: .immediate)
                self.startTime = nil
               
            }
        } else { // Fall back to earlier iOS APIs.
            let finalDeliveryStatus = Prothesen_widgetAttributes.ContentState(isRunning: isRunning, timeStamp: Date.now, state: "Beendet", endTime: endTime)
            let finalContent = ActivityContent(state: finalDeliveryStatus, staleDate: nil)
            
            Task {
                for activity in Activity<Prothesen_widgetAttributes>.activities {
                    await activity.end(finalContent, dismissalPolicy: .default)
                    print("Ending the Live Activity: \(activity.id)")
                    self.startTime = nil
                }
            }
        }
   }
 */
