//
//  RecordWidgetLiveActivity.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 09.05.23.
//

import SwiftUI
import ActivityKit
import WidgetKit


/*
struct RecordWidgetLiveActivity: Widget {
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: RecordTimerAttributes.self) { context in
            LockScreenView(context: context)
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    dynamicIslandExpandedLeadingView(context: context)
                 }
                 
                 DynamicIslandExpandedRegion(.trailing) {
                     dynamicIslandExpandedTrailingView(context: context)
                 }
                 
                 DynamicIslandExpandedRegion(.center) {
                     dynamicIslandExpandedCenterView(context: context)
                 }
                 
                DynamicIslandExpandedRegion(.bottom) {
                    dynamicIslandExpandedBottomView(context: context)
                }
                
              } compactLeading: {
                  compactLeadingView(context: context)
              } compactTrailing: {
                  compactTrailingView(context: context)
              } minimal: {
                  minimalView(context: context)
              }
              .keylineTint(.cyan)
        }
    }
    
    
    //MARK: Expanded Views
    func dynamicIslandExpandedLeadingView(context: ActivityViewContext<RecordTimerAttributes>) -> some View {
        VStack {
            Label {
                Text("\(context.attributes.numberOfPizzas)")
                    .font(.title2)
            } icon: {
                Image("grocery")
                    .foregroundColor(.green)
            }
            Text("items")
                .font(.title2)
        }
    }
    
    func dynamicIslandExpandedTrailingView(context: ActivityViewContext<RecordTimerAttributes>) -> some View {
        Label {
            Text(context.state.deliveryTimer, style: .timer)
                .multilineTextAlignment(.trailing)
                .frame(width: 50)
                .monospacedDigit()
        } icon: {
            Image(systemName: "timer")
                .foregroundColor(.green)
        }
        .font(.title2)
    }
    
    func dynamicIslandExpandedBottomView(context: ActivityViewContext<RecordTimerAttributes>) -> some View {
        let url = URL(string: "LiveActivities://?CourierNumber=87987")
        return Link(destination: url!) {
            Label("Call courier", systemImage: "phone")
        }.foregroundColor(.green)
    }
    
    func dynamicIslandExpandedCenterView(context: ActivityViewContext<RecordTimerAttributes>) -> some View {
        Text("\(context.state.driverName) is on the way!")
            .lineLimit(1)
            .font(.caption)
    }
    
    
    //MARK: Compact Views
    func compactLeadingView(context: ActivityViewContext<RecordTimerAttributes>) -> some View {
        VStack {
            Label {
                Text("\(context.attributes.numberOfPizzas) items")
            } icon: {
                Image("grocery")
                    .foregroundColor(.green)
            }
            .font(.caption2)
        }
    }
    
    func compactTrailingView(context: ActivityViewContext<RecordTimerAttributes>) -> some View {
        Text(context.state.deliveryTimer, style: .timer)
            .multilineTextAlignment(.center)
            .frame(width: 40)
            .font(.caption2)
    }
    
    func minimalView(context: ActivityViewContext<RecordTimerAttributes>) -> some View {
        VStack(alignment: .center) {
            Image(systemName: "timer")
            Text(context.state.deliveryTimer, style: .timer)
                .multilineTextAlignment(.center)
                .monospacedDigit()
                .font(.caption2)
        }
    }
}

struct LockScreenView: View {
    var context: ActivityViewContext<RecordTimerAttributes>
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .center) {
                    Text(context.state.driverName + " is on the way!").font(.headline)
                    Text("You ordered \(context.attributes.numberOfPizzas ) grocery items.")
                        .font(.subheadline)
                    BottomLineView(time: context.state.deliveryTimer)
                }
            }
        }.padding(15)
    }
}

struct BottomLineView: View {
    var time: Date
    var body: some View {
        HStack {
            Divider().frame(width: 50,
                            height: 10)
            .overlay(.gray).cornerRadius(5)
            Image("delivery")
            VStack {
                RoundedRectangle(cornerRadius: 5)
                    .stroke(style: StrokeStyle(lineWidth: 1,
                                               dash: [4]))
                    .frame(height: 10)
                    .overlay(Text(time, style: .timer).font(.system(size: 8)).multilineTextAlignment(.center))
            }
            Image("home-address")
        }
    }
}
 */


/*
 NavigationView {
             Form {
                 Section {
                     Text("Create an activity to start a live activity")
                     Button(action: {
                         createActivity()
                         listAllDeliveries()
                     }) {
                         Text("Create Activity").font(.headline)
                     }.tint(.green)
                     Button(action: {
                         listAllDeliveries()
                     }) {
                         Text("List All Activities").font(.headline)
                     }.tint(.green)
                     Button(action: {
                         endAllActivity()
                         listAllDeliveries()
                     }) {
                         Text("End All Activites").font(.headline)
                     }.tint(.green)
                 }
                 Section {
                     if !activities.isEmpty {
                         Text("Live Activities")
                     }
                     activitiesView()
                 }
             }
             .navigationTitle("Welcome!")
             .fontWeight(.ultraLight)
         }
 */
