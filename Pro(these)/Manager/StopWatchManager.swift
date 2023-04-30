//
//  StopWatchManager.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 25.04.23.
//

import SwiftUI
import CoreData
import ActivityKit
import LiveViewExtensionExtension

class StopWatchManager : ObservableObject {
    @Published var message = "Not running"
    @Published var isRunning = false
    private var startTime: Date?
    private var endDate: String = ""
    
    @Published var timesArray: [WearingTimes] = []
    
    @Published var mergedTimesArray:[ProthesenTimes] = []
    
    @Published var totalProtheseTimeToday: String = ""
    @Published var totalProtheseTimeYesterday: String = ""
   
    // Live Activity old
    @State var activity: Activity<Prothesen_widgetAttributes>? = nil
    
    // Live Activity new
    @State var activityTimeTracking: Activity<TimeTrackingAttributes>? = nil
    
    
    // Chart
    @Published var activeDateCicle: Date = Date()
    @Published var dragAmount = CGSize.zero
    @Published var devideSizeWidth: CGFloat = 0
    @Published var activeisActive = false
    var fetchDays:Int = 7
    
    init() {
       startTime = fetchStartTime()
        
       if startTime != nil {
           restart(time: startTime!)
       }
    }
    
    func fetchTimesData() {
        let requesttimestamps = NSFetchRequest<WearingTimes>(entityName: "WearingTimes")
        let sort = NSSortDescriptor(key: "timestamp", ascending: false)
        requesttimestamps.sortDescriptors = [sort]
        do {
            timesArray = try PersistenceController.shared.container.viewContext.fetch(requesttimestamps)
            sumTime( try PersistenceController.shared.container.viewContext.fetch(requesttimestamps) )
            convertDates(try PersistenceController.shared.container.viewContext.fetch(requesttimestamps))
        }catch {
          print("DEBUG: Some error occured while fetching Times")
        }
    }
    
    func refetchTimesData() {
        let requesttimestamps = NSFetchRequest<WearingTimes>(entityName: "WearingTimes")
        let sort = NSSortDescriptor(key: "timestamp", ascending: false)
        requesttimestamps.sortDescriptors = [sort]
        timesArray.removeAll(keepingCapacity: true)
        do {
            timesArray = try PersistenceController.shared.container.viewContext.fetch(requesttimestamps)
            sumTime(timesArray)
            convertDates(timesArray)
        }catch {
          print("DEBUG: Some error occured while fetching Times")
        }
    }

    func sumTime(_ arr: [WearingTimes]) -> Void {
       var TodayArray = [Int]()
       var YesterdayArray = [Int]()
       
       for time in arr {
           
           let int = Int(time.duration )
       
           if Calendar.current.isDateInToday( time.timestamp! ) {
               TodayArray.append(int )
           }
           if Calendar.current.isDateInYesterday( time.timestamp! ) {
               YesterdayArray.append(int )
               
           }
       }
       totalProtheseTimeYesterday = convertSecondsToHrMinuteSec(seconds: YesterdayArray.reduce(0, +) )
       totalProtheseTimeToday = convertSecondsToHrMinuteSec(seconds: TodayArray.reduce(0, +) )
    }
    
    func avgTimes() -> Int {
        let days = mergedTimesArray.count
        let secs = mergedTimesArray.map { $0.duration }.reduce(0,+)
        let avg = (Int(secs) / days)
        return avg
    }
    
    func maxValue(margin: Int) -> ClosedRange<Int> {
        let maXsecs = mergedTimesArray.map { $0.duration }.max()
        let withMargin = Int(maXsecs ?? 65000) + margin
        return 0...withMargin
    }

    func deleteItems(offsets: IndexSet) {
       withAnimation {
           offsets.map { self.timesArray[$0] }.forEach(PersistenceController.shared.container.viewContext.delete)

           do {
               try PersistenceController.shared.container.viewContext.save()
               convertDates(timesArray)
           } catch {
               // Replace this implementation with code to handle the error appropriately.
               // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
               let nsError = error as NSError
               fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
           }
       }
    }
    
    func IntToDate(int: Int) -> Date {
          // convert Int to TimeInterval (typealias for Double)
          let timeInterval = TimeInterval(int)

          // create NSDate from Double (NSTimeInterval)
          let myNSDate = Date(timeIntervalSince1970: timeInterval)
          
          return myNSDate
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
          //formatter.allowedUnits = [ .day, .hour, .minute, .second]
          formatter.allowedUnits = [ .second]
          //formatter.string(from: duration)
        return Int32(duration)
    }
    
    func restart(time: Date){
         startTime = time
         isRunning = true
         message = "Is running"
        //LiveActivityStart()
     }
    
    func start(){
        if startTime == nil {
            startTime = Date.now
            isRunning = true
            message = "Is running"
            if startTime != nil {
                UserDefaults.standard.set(Date.now, forKey: "startTime")
            }
            if AppConfig().showLiveActivity == true {
                self.LiveActivityStart()
            }
        }
    }
    
    func stop(){
        startTime = nil
        isRunning = false
        message = "Not running"
        let DateData = UserDefaults.standard.object(forKey: "startTime") as? Date ?? nil
        var EndTimeString:String = ""
        if DateData != nil {
            
        var endTime = getDuration(data: DateData!)
        addTime(time: DateData!, duration: endTime)
        refetchTimesData()
        
        if AppConfig().showLiveActivity == true {
            self.liveActivityStop(isRunning: isRunning, endTime: EndTimeString)
        }
            
        }
        
        UserDefaults.standard.set(nil, forKey: "startTime")
    }
    
    func addTime(time: Date, duration: Int32) {
        let newTime = WearingTimes(context: PersistenceController.shared.container.viewContext)
        newTime.timestamp = time
        newTime.duration = duration
        do {
            try PersistenceController.shared.container.viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    func fetchStartTime() -> Date? {
        UserDefaults.standard.object(forKey: "startTime") as? Date
    }
    
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

    
    func calcChartItemSize() -> CGFloat {
        let days = AppConfig().fetchDays
        let itemSize = (devideSizeWidth / 7)
        return itemSize * CGFloat(days)
    }
    
    func convertDates(_ arr: [WearingTimes]) {
        let start = arr.reversed()
        var newArray:[ProthesenTimes] = [
//            ProthesenTimes(date: Calendar.current.date(byAdding: .day, value: -16, to: Date())!, duration: 0),
//            ProthesenTimes(date: Calendar.current.date(byAdding: .day, value: -15, to: Date())!, duration: 0),
//            ProthesenTimes(date: Calendar.current.date(byAdding: .day, value: -14, to: Date())!, duration: 0),
//            ProthesenTimes(date: Calendar.current.date(byAdding: .day, value: -13, to: Date())!, duration: 0),
//            ProthesenTimes(date: Calendar.current.date(byAdding: .day, value: -12, to: Date())!, duration: 0),
//            ProthesenTimes(date: Calendar.current.date(byAdding: .day, value: -11, to: Date())!, duration: 0),
//            ProthesenTimes(date: Calendar.current.date(byAdding: .day, value: -10, to: Date())!, duration: 0),
        ]

        
        // Groupiert alle Zeiten zu dein Datum und Summiert die Zeiten
        var GroupedAndSumArray:[ProthesenTimes] = []
        let dictionary = Dictionary(grouping: arr.reversed(), by: { Calendar.current.startOfDay(for: $0.timestamp!) })
        let _: [()] = dictionary.map { GroupedAndSumArray.append(ProthesenTimes(date: $0.key, duration: $0.value.map({ $0.duration }).reduce(0, +)) ) }
        // Ordnet das Array nach der Zeit
        let sorted = GroupedAndSumArray.sorted { itemA, itemB in
            return itemA.date > itemB.date
        }
        //
        mergedTimesArray = sorted
        
        
        
        var EntryDurationArray:[ProthesenTimes] = []
        var countDownDay = 6
        while countDownDay >= 0 {
            let day = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -countDownDay, to: Date())!)
            EntryDurationArray.append( ProthesenTimes(date: day, duration: 0) )
            countDownDay -= 1
        } // CREAT ARRAY with Entry durations
        
    }
    
}

struct ProthesenTimes: Identifiable {
    var id: Date { date }
    var date: Date
    var duration: Int32
}

