//
//  EventPlanerWidgetProvider.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 10.05.23.
//

/*
import SwiftUI
import WidgetKit
import CoreData

struct EventWidgetData: TimelineEntry {
    var date: Date
    let lastProthesenTime: String
    let lastTimeInSec: Double
    let avgTimes: Double
    let wearingTimes: [ProthesenTimes]
}

struct EventPlanerWidgetProvider: TimelineProvider {
    let persistenceController = PersistenceController.shared
    
    typealias Entry = EventWidgetData
    
    func placeholder(in context: Context) -> EventWidgetData {
        let times = (try? getData(showDays: 7)) ?? []
        let lastTime = (try? getLastTime()) ?? "no Time"
        let lastTimeInSec = (try? getLastTimeInSec()) ?? 0
        
        let days = times.count
        let secs = times.map { $0.duration }.reduce(0,+)
        let avg = (Double(secs) / Double(days))
        
        return EventWidgetData(date: Date(), lastProthesenTime: lastTime, lastTimeInSec: lastTimeInSec, avgTimes: avg, wearingTimes: times)
    }

    func getSnapshot(in context: Context, completion: @escaping (EventWidgetData) -> ()) {
        let times = (try? getData(showDays: 7)) ?? []
        let lastTime = (try? getLastTime()) ?? "no Time"
        let lastTimeInSec = (try? getLastTimeInSec()) ?? 0
        
        let days = times.count
        let secs = times.map { $0.duration }.reduce(0,+)
        guard days != 0 else {
            return
        }
        let avg = (Double(secs) / Double(days))
        
        let entry = EventWidgetData(date: Date(), lastProthesenTime: lastTime, lastTimeInSec: lastTimeInSec, avgTimes: avg, wearingTimes: times)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [EventWidgetData] = []
        
        let times = (try? getData(showDays: 7)) ?? []
        let lastTime = (try? getLastTime()) ?? "no Time"
        let lastTimeInSec = (try? getLastTimeInSec()) ?? 0
        
        let days = times.count
        let secs = times.map { $0.duration }.reduce(0,+)
        guard days != 0 else {
            return
        }
        let avg = (Double(secs) / Double(days))
        
        entries.append(EventWidgetData(date: Date(), lastProthesenTime: lastTime, lastTimeInSec: lastTimeInSec, avgTimes: avg, wearingTimes: times ))
        
        let nextUpdate = Calendar.current.date(  byAdding: DateComponents(minute: 1), to: Date() )!
        let timeline = Timeline( entries: entries,  policy: .after(nextUpdate) )
        
        completion(timeline)
    }
    
}

// MARK: CoreData Extension
extension TimelineProvider {
   
}
*/
