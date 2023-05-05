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
    let wearingTimes: [ProthesenTimes]
}

struct Provider: TimelineProvider {
    let persistenceController = PersistenceController.shared
    
    typealias Entry = WidgetData
    
    func placeholder(in context: Context) -> WidgetData {
        let item = (try? getData()) ?? []
        return WidgetData(date: Date(), wearingTimes: item)
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetData) -> ()) {
        let item = (try? getData()) ?? []
        let entry = WidgetData(date: Date(), wearingTimes: item)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [WidgetData] = []
        
        entries.append(WidgetData(date: Date(), wearingTimes: (try? getData()) ?? [] ))
        
        let nextUpdate = Calendar.current.date(  byAdding: DateComponents(minute: 5), to: Date() )!
        
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
    
    func convertDates(_ arr: [WearingTimes]) throws -> [ProthesenTimes] {
        // Groupiert alle Zeiten zu dein Datum und Summiert die Zeiten
        var GroupedAndSumArray:[ProthesenTimes] = []
        let dictionary = Dictionary(grouping: arr.reversed(), by: { Calendar.current.startOfDay(for: $0.timestamp ?? Date() ) })
        let _: [()] = dictionary.map { GroupedAndSumArray.append(ProthesenTimes(date: $0.key, duration: $0.value.map({ $0.duration }).reduce(0, +)) ) }
        // Ordnet das Array nach der Zeit
        let sorted = GroupedAndSumArray.sorted { itemA, itemB in
            return itemA.date > itemB.date
        }
        //
        
        var EntryDurationArray:[ProthesenTimes] = []
        var countDownDay = 6
        while countDownDay >= 0 {
            let day = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -countDownDay, to: Date())!)
            EntryDurationArray.append( ProthesenTimes(date: day, duration: 0) )
            countDownDay -= 1
        } // CREAT ARRAY with Entry durations
        
        return sorted
    }

    func getData() throws -> [ProthesenTimes] {
        let timesArray = try fetchTimesData()
        return try convertDates(timesArray)
    }
}
