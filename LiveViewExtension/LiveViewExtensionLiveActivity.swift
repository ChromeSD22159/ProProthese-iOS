//
//  Prothesen_widgetLiveActivity.swift
//  Prothesen_widget
//
//  Created by Frederik Kohler on 14.04.23.
//
import ActivityKit
import WidgetKit
import SwiftUI
import Foundation

// https://developer.apple.com/documentation/activitykit/displaying-live-data-with-live-activities
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

struct Prothesen_widgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: Prothesen_widgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack(spacing: 10) {
                HStack{
                    //Image(systemName: "prothesis")
                    Image("prothesis")
                        .imageScale(.large)
                        .font(Font.system(size: 30, weight: .heavy))
                        .foregroundColor(.white)
                    
                    Text("Prothesen App")
                        .foregroundColor(.white)
                        .font(.body)
                        .padding(.leading, 15)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack(spacing: 20){
                    if context.state.isRunning {
                        Image(systemName: "record.circle")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                        
                        Text(context.state.timeStamp, style: .timer)
                            .foregroundColor(.white)
                            .font(.headline)
                    } else {
                        Image(systemName: "stopwatch")
                            .foregroundColor(.white)
                            .font(.callout)
                        
                        HStack {
                            Text("Letzter Record: ")
                                .foregroundColor(.white)
                                .font(.callout)
                            
                            Text(context.state.endTime)
                                .foregroundColor(.white)
                                .font(.callout)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 5)
                
                HStack(spacing: 0){
                    Text("Status: \(context.state.state) \(context.state.isRunning ? "seit " : "am ")")
                        .foregroundColor(.white)
                        .font(.caption2)
                    
                    Text(context.state.timeStamp, style: .time)
                        .font(.caption2)
                        .foregroundColor(.white)
                    Spacer()
                }
                .frame(alignment: .leading)
            }
            .padding(.all, 20)
            .activityBackgroundTint(Color("WidgetBackground"))
            .background(
                HStack(alignment: .top){
                    Image("Image")
                      .resizable()
                      .opacity(0.2)
                      .aspectRatio(contentMode: .fit)
                    Spacer()
                    
                    Image("Image")
                      .resizable()
                      .opacity(0.2)
                      .aspectRatio(contentMode: .fill)
                      .rotationEffect(Angle(degrees: -180))
                }
            )
            .activitySystemActionForegroundColor(Color.white)

        } dynamicIsland: { context in
            DynamicIsland {
                //ISland Expanded
                DynamicIslandExpandedRegion(.leading) {
                    HStack{
                        Image("prothesis")
                            .imageScale(.large)
                            .font(Font.system(size: 40, weight: .heavy))
                            .foregroundColor(.white)
                            .padding(.leading, 20)
                        
                        Text("Prothese")
                            .font(.headline)
                            .padding(.leading, 10)
                    }
                }
                DynamicIslandExpandedRegion(.trailing) {
//                    HStack{
//                        Image(systemName: "record.circle")
//                            .foregroundColor(.red)
//                            .padding()
//                    }
                }
                DynamicIslandExpandedRegion(.bottom) {
                    HStack(){
                        Spacer()
                        Image(systemName: "record.circle")
                            .foregroundColor(.red)
                            .padding()
                        
                        Text(context.state.timeStamp, style: .timer)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                }
            } compactLeading: {
                Image("prothesis")
                    .imageScale(.large)
                    .font(Font.system(size: 25, weight: .regular))
                    .foregroundColor(.white)
                    .padding(.leading, 5)
                
            } compactTrailing: {
                Image(systemName: "record.circle")
                    .foregroundColor(.red)
                    .font(Font.system(size: 25, weight: .regular))
                    .padding(5)
            } minimal: {
                Image(systemName: "record.circle")
                    .foregroundColor(.red)
                    .padding()
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}



struct Prothesen_widgetLiveActivity_Previews: PreviewProvider {
    static let record = true
    //record ? "Zeichnet auf" : "Aufgezeichnet"
    static let attributes = Prothesen_widgetAttributes()
    static let contentState = Prothesen_widgetAttributes.ProthesenTimerStatus(isRunning: false, timeStamp: Date.now, state: "Zeichnet auf", endTime: "" )

    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}

