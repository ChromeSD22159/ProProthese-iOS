//
//  Provider.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 05.05.23.
//

import SwiftUI
import WidgetKit
import CoreData

struct WidgetData: TimelineEntry {
    var date: Date
    let lastProthesenTime: String
    let wearingTimes: [ProthesenTimes]
}

struct Provider: TimelineProvider {
    let persistenceController = PersistenceController.shared
    
    typealias Entry = WidgetData
    
    func placeholder(in context: Context) -> WidgetData {
        let times = (try? getData(showDays: 7)) ?? []
        let lastTime = (try? getLastTime()) ?? "no Time"
      
        return WidgetData(date: Date(), lastProthesenTime: lastTime, wearingTimes: times)
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetData) -> ()) {
        let times = (try? getData(showDays: 7)) ?? []
        let lastTime = (try? getLastTime()) ?? "no Time"
        let entry = WidgetData(date: Date(), lastProthesenTime: lastTime, wearingTimes: times)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [WidgetData] = []
        
        let times = (try? getData(showDays: 7)) ?? []
        let lastTime = (try? getLastTime()) ?? "no Time"
        
        entries.append(WidgetData(date: Date(), lastProthesenTime: lastTime, wearingTimes: times ))
        
        let nextUpdate = Calendar.current.date(  byAdding: DateComponents(minute: 1), to: Date() )!
        let timeline = Timeline( entries: entries,  policy: .after(nextUpdate) )
        

        //let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
}


extension TimelineProvider {
    func fetchTimesData() throws -> [WearingTimes] {
        let context = PersistenceController.shared.container.viewContext
        let WearingTimes = WearingTimes.fetchRequest()
        let result = try context.fetch(WearingTimes)
        return result
    }
    
    func convertDates(_ arr: [WearingTimes], showDays: Int) throws -> [ProthesenTimes] {
        // Groupiert alle Zeiten zu dein Datum und Summiert die Zeiten
        var GroupedAndSumArray:[ProthesenTimes] = []
        let dictionary = Dictionary(grouping: arr.reversed(), by: { Calendar.current.startOfDay(for: $0.timestamp ?? Date() ) })
        let _: [()] = dictionary.map { GroupedAndSumArray.append(ProthesenTimes(date: $0.key, duration: $0.value.map({ $0.duration }).reduce(0, +)) ) }
        // Ordnet das Array nach der Zeit
        let sorted = GroupedAndSumArray.sorted { itemA, itemB in
            return itemA.date > itemB.date
        }
        
        var EntryDurationArray:[ProthesenTimes] = []
        var countDownDay = 6
        while countDownDay >= 0 {
            let day = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -countDownDay, to: Date())!)
            EntryDurationArray.append( ProthesenTimes(date: day, duration: 0) )
            countDownDay -= 1
        } // CREAT ARRAY with Entry durations
        
        return sorted
    }

    func getData(showDays: Int) throws -> [ProthesenTimes] {
        let timesArray = try fetchTimesData()
        
        return try convertDates(timesArray, showDays: showDays)
    }
    
    func getLastTime() throws -> String {
        let defaultTime:Int32 = 1
        let timesArray = try fetchTimesData()
        let convertedTimes = try convertDates(timesArray, showDays: 7)
        print(convertedTimes)
        let converted = convertSecondsToHrMinuteSec(seconds: Int(convertedTimes.map{ $0.duration }.first ?? defaultTime))
        return converted
    }
    
    func convertSecondsToHrMinuteSec(seconds:Int) -> String{
       let formatter = DateComponentsFormatter()
       formatter.allowedUnits = [.hour, .minute, .second]
      //formatter.unitsStyle = .full
      formatter.unitsStyle = .abbreviated
      
       let formattedString = formatter.string(from:TimeInterval(seconds))!
       return formattedString
      }
}
