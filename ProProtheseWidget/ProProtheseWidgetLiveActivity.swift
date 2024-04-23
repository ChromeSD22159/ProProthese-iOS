//
//  ProProtheseWidgetLiveActivity.swift
//  ProProtheseWidget
//
//  Created by Frederik Kohler on 13.06.23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct ProProtheseWidgetAttributes: ActivityAttributes {
    
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var isRunning: Bool
        var date: Date
        var endTime: Int?
        var prothese: String
    }

    // Fixed non-changing properties about your activity go here!
   
}

struct ProProtheseWidgetLiveActivity: Widget {
    
    private var currentTheme: Theme {
        return ThemeManager().currentTheme()
    }
    
    @ObservedObject var appConfig = AppConfig()
    
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ProProtheseWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            
            LockScreen(time: context.state.endTime ?? 0, date: context.state.date, prothese: context.state.prothese)
            

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                
                DynamicIslandExpandedRegion(.bottom) {
                    HStack {
                        Spacer()
                        Image("prothese.below")
                            .font(.title.bold())
                            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                            .foregroundStyle(currentTheme.text, currentTheme.hightlightColor)
                        
                        Text(appConfig.recorderTimer, style: .timer)
                            .font(.title.bold())
                            .foregroundColor(currentTheme.hightlightColor)
                            .monospacedDigit()
                        Spacer()
                        
                        Text( LocalizedStringKey(context.state.prothese) )
                            .multilineTextAlignment(.center)
                            .monospacedDigit()
                            .foregroundColor(currentTheme.text)
                            .font(.body.bold())
                    }
                    .frame(maxWidth: .infinity)
                }
            } compactLeading: {
                HStack {
                    /*
                     Image("prothese.below")
                          .font(.caption2.bold())
                          .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                          .foregroundStyle(currentTheme.text, currentTheme.hightlightColor)
                     */
                    Text(appConfig.recorderTimer, style: .timer)
                        .font(.caption2.bold())
                        .foregroundColor(currentTheme.hightlightColor)
                        .monospacedDigit()
                    
                    Spacer()
                }
                .padding(.horizontal)
            } compactTrailing: {
               Text( LocalizedStringKey(context.state.prothese) )
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(currentTheme.hightlightColor)
                    .monospacedDigit()
                    .padding(.horizontal)
            } minimal: {
                
                ViewThatFits(in: .horizontal) {
                    Image("prothese.below")
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        .foregroundStyle(currentTheme.text, currentTheme.hightlightColor)

                    Text(context.state.date, style: .relative)
                        .multilineTextAlignment(.center)
                        .monospacedDigit()
                        .font(.caption2)
                }
                .frame(maxWidth: .infinity)
                
              
            }
            .widgetURL(URL(string: "ProProthese://stopWatch" ))

        }
    }
}

struct LockScreen: View {
    private var currentTheme: Theme {
        return ThemeManager().currentTheme()
    }
    
    @ObservedObject var appConfig = AppConfig()
    
    var time: Int
    
    var date: Date
    
    var prothese: String
    
    @State var currentDate = Date.now
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ViewThatFits {
            HStack(alignment: .center, spacing: 0) {
                HStack() {
                    Image("prothese.below")
                        .font(.largeTitle.bold())
                        .scaleEffect(1.5)
                        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(currentTheme.text, currentTheme.hightlightColor)
                }
                
                VStack(alignment: .trailing, spacing: 6) {
                    HStack {
                        Spacer()
                        
                        Text(date, style: .relative)
                            .font(.title2.bold())
                            .foregroundColor(currentTheme.hightlightColor)
                            .monospacedDigit()
                            .multilineTextAlignment(.trailing)
                        
                    }
                    
                    Text(LocalizedStringKey(prothese))
                        .font(.body.bold())
                        .foregroundColor(currentTheme.text)
                }
            }
            .padding(.vertical)
            .padding(.horizontal, 50)
            .padding()
        }
        .background( currentTheme.gradientBackground(nil))
    }
}
