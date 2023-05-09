//
//  ProthesenWidgetBundle.swift
//  ProthesenWidget
//
//  Created by Frederik Kohler on 05.05.23.
//

import WidgetKit
import SwiftUI

@main
struct ProthesenWidgetBundle: WidgetBundle {
    var body: some Widget {
       // EventPlanerWidget()
        WearingWidget()
         
        //RecordWidgetLiveActivity()
        Prothesen_widgetLiveActivity()
    }
}



struct Prothesen_widgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: RecordTimerAttributes.self) { context in
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
            .activityBackgroundTint(Color("App-Blue"))
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
            
            GeometryReader { proxy in
                
            }

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
