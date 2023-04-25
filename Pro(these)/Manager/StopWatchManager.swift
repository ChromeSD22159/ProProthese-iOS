//
//  StopWatchManager.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 25.04.23.
//

import SwiftUI
import CoreData
import ActivityKit

class StopWatchManager : ObservableObject {
    @Published var message = "Not running"
    @Published var isRunning = false
    private var startTime: Date?
    private var endDate: String = ""
    
    @Published var timesArray: [WearingTimes] = []
    
    @Published var totalProtheseTimeToday: String = ""
    @Published var totalProtheseTimeYesterday: String = ""
   
    // Live Activity
    @State var activity: Activity<Prothesen_widgetAttributes>? = nil
    
    init() {
       startTime = fetchStartTime()
       
       if startTime != nil {
           restart(time: startTime!)
       }
    }
    
    func fetchTimesData() {
        let requesttimestamps = NSFetchRequest<WearingTimes>(entityName: "WearingTimes")
        
        do {
            timesArray = try PersistenceController.shared.container.viewContext.fetch(requesttimestamps)
            sumTime(timesArray)
        }catch {
          print("DEBUG: Some error occured while fetching Times")
        }
    }
    
    func refetchTimesData() {
        let requesttimestamps = NSFetchRequest<WearingTimes>(entityName: "WearingTimes")
        timesArray.removeAll(keepingCapacity: true)
        do {
            timesArray = try PersistenceController.shared.container.viewContext.fetch(requesttimestamps)
            sumTime(timesArray)
        }catch {
          print("DEBUG: Some error occured while fetching Times")
        }
    }

    func sumTime(_ arr: [WearingTimes]) -> Void {
       var TodayArray = [Int]()
       var YesterdayArray = [Int]()
       
       for time in arr {
           
           let int = Int(time.duration ?? "")
       
           if Calendar.current.isDateInToday( time.timestamp! ) {
               TodayArray.append(int ?? 0)
           }
           if Calendar.current.isDateInYesterday( time.timestamp! ) {
               YesterdayArray.append(int ?? 0)
               
           }
       }
       totalProtheseTimeYesterday = convertSecondsToHrMinuteSec(seconds: YesterdayArray.reduce(0, +) )
       totalProtheseTimeToday = convertSecondsToHrMinuteSec(seconds: TodayArray.reduce(0, +) )
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
  
    func getDuration(data: Date) -> String {
          let duration = Date().timeIntervalSince(data)
          let formatter = DateComponentsFormatter()
          formatter.unitsStyle = .abbreviated
          //formatter.allowedUnits = [ .day, .hour, .minute, .second]
          formatter.allowedUnits = [ .second]
          
          return formatter.string(from: duration)!
    }
    
    func restart(time: Date){
         startTime = time
         isRunning = true
         message = "Is running"
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
            EndTimeString = endTime
            endTime = endTime.replacingOccurrences(of: "s", with: "")
            endTime = endTime.replacingOccurrences(of: ".", with: "")
            print(DateData!)
            print(endTime)
            addTime(time: DateData!, duration: endTime)
            refetchTimesData()
            
            if AppConfig().showLiveActivity == true {
                self.liveActivityStop(isRunning: isRunning, endTime: EndTimeString)
            }
            
        }
        
        UserDefaults.standard.set(nil, forKey: "startTime")
    }
    
    func addTime(time: Date, duration: String) {
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
    

 //   Prothesen_widgetAttributes.ContentState
 //   ActivityContent<Prothesen_widgetAttributes.ContentState>
    
    // Mark: old LIVE ACTIVITY
    func LiveActivityStart(name: String){
          if ActivityAuthorizationInfo().areActivitiesEnabled {
              do {
                  if #available(iOS 16.2, *) {
                      let attributes = Prothesen_widgetAttributes()
                      let state = Prothesen_widgetAttributes.ProthesenTimerStatus(isRunning: true, timeStamp: Date.now, state: "Zeichnet auf", endTime: "" )
                       activity = try? Activity<Prothesen_widgetAttributes>.request(attributes: attributes, contentState: state, pushType: nil)
                      print("Requested a LiveRecordTimer - Live Activity \(String(describing: activity?.id)).")
                  }
              }
          }
      }
    
    // Mark: new LIVE ACTIVITY
    func LiveActivityStart() {
        if ActivityAuthorizationInfo().areActivitiesEnabled {
            let Attributes = Prothesen_widgetAttributes()
            let ContentState = Prothesen_widgetAttributes.ProthesenTimerStatus(isRunning: true, timeStamp: Date.now, state: "Zeichnet auf", endTime: "" )
            do {
               let timerActivity = try Activity<Prothesen_widgetAttributes>.request(
                   attributes: Attributes,
                   contentState: ContentState,
                   pushType: nil)
                
               print("Requested a Timer Live Activity \(timerActivity.id)")
            } catch (let error) {
               print("Error requesting Timer Live Activity \(error.localizedDescription)")
            }
        }
    }
      
      func liveActivityStop(isRunning: Bool, endTime: String){
          
          let finalDeliveryStatus = Prothesen_widgetAttributes.ContentState(isRunning: isRunning, timeStamp: Date.now, state: "Beendet", endTime: endTime)
          
          if #available(iOS 16.2, *) {
              let finalContent = ActivityContent(state: finalDeliveryStatus, staleDate: nil)
              Task {
                  for activity in Activity<Prothesen_widgetAttributes>.activities {
                      await activity.end(finalContent, dismissalPolicy: .default)
                      print("Ending the Live Activity: \(activity.id)")
                  }
              }
          }
      }
}



struct Prothesen_widgetAttributes: ActivityAttributes {
    public typealias ProthesenTimerStatus = ContentState
    
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var isRunning: Bool
        var timeStamp: Date
        var state: String
        var endTime: String
    }

    // Fixed non-changing properties about your activity go here!
 
}
