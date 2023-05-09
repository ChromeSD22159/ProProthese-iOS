//
//  EventPlanerWidget.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 10.05.23.
//
/*
import SwiftUI
import WidgetKit
import Charts

struct EventPlanerWidgetEntry: View {
    @Environment(\.widgetFamily) var widgetFamily
    
    var data: EventWidgetData

    var body: some View {
            switch widgetFamily {
            case .systemSmall: EventPlanerSmallWidget(data: data).widgetURL(URL(string: "ProProthese://timer")!)
            case .systemMedium: EventPlanerMediumWidget(data: data).widgetURL(URL(string: "ProProthese://timer")!)
            case .systemLarge: EventPlanerLargeWidget(data: data).widgetURL(URL(string: "ProProthese://timer")!)
            default: Text("Default")
       }
    }
}

struct EventPlanerSmallWidget: View {
    var data: EventWidgetData
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        ZStack{
            AppConfig().backgroundGradient
            bg(widgetFamily: widgetFamily)
            VStack(alignment: .center){
                VStack(alignment: .center){
                    HStack(spacing: 10) {
                        Spacer()
                        Image("prothesis")
                            .font(.largeTitle)
                        VStack(alignment: .leading){
                            Text("Tragezeit heute!")
                                .foregroundColor(.gray)
                                .font(.caption2)
                        }
                        Spacer()
                    }
                }
                .frame(maxHeight: .infinity)
            }
            .padding(10)
        }
    }
}

struct EventPlanerMediumWidget: View {
    var data: EventWidgetData
    @Environment(\.widgetFamily) var widgetFamily
    @State private var phase = 0.0
    var body: some View {
        GeometryReader { proxy in
            ZStack{
                AppConfig().backgroundGradient
                bg(widgetFamily: widgetFamily)
                VStack(alignment: .center, spacing: 15){
                    HStack(spacing: 10){
                        Image("prothesis")
                            .font(.largeTitle)
                        
                        VStack(alignment: .leading){
                             Text("Prothesenzeit heute")
                                .foregroundColor(.gray)
                                .font(.caption2)
                        }
                        Spacer ()
                    }
                    .padding(.horizontal, 20)
                    .frame(width: proxy.size.width)
                }
                .frame(width: proxy.size.width, height: proxy.size.height)
            }
            .frame(width: proxy.size.width , height: proxy.size.height)
        }
    }
}

struct EventPlanerLargeWidget: View {
    var data: EventWidgetData
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct EventPlanerChart: View {
    var data: EventWidgetData
    var body: some View {
        GeometryReader { proxy in
            Chart() {
                ForEach(Array(data.wearingTimes.enumerated()), id: \.offset) { index, time in
                        RuleMark(y: .value("Durchschnitt", data.avgTimes ))
                            .foregroundStyle(.yellow)
                            .lineStyle(StrokeStyle(lineWidth: 0.1, dash: [8]))
                    
                        AreaMark(
                            x: .value("Dates", time.date),
                            y: .value("Steps", time.duration)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(
                            .linearGradient(
                                colors: [
                                    Color(red: 167/255, green: 178/255, blue: 210/255).opacity(0),
                                    Color(red: 167/255, green: 178/255, blue: 210/255).opacity(0.2),
                                    Color(red: 167/255, green: 178/255, blue: 210/255).opacity(0.6)
                                ],
                                startPoint: .bottom,
                                endPoint: .top)
                        )
                        
                        LineMark(
                            x: .value("Dates", time.date),
                            y: .value("Steps", time.duration)
                        )
                        .interpolationMethod(.catmullRom)
                        .symbol {
                            ZStack{
                                Circle()
                                    .fill(.white)
                                    .frame(width: 10)
                                    .shadow(radius: 2)
                            }
                        }
                        .foregroundStyle(
                            .linearGradient(
                                colors: [
                                    Color(red: 167/255, green: 178/255, blue: 210/255).opacity(0.5),
                                    Color(red: 167/255, green: 178/255, blue: 210/255)
                                ],
                                startPoint: .bottom,
                                endPoint: .top)
                        )
                        .lineStyle(.init(lineWidth: 5))
                    }

            }
            .chartXAxis {
                AxisMarks(position: .bottom , values: .stride(by: .day, count: 1)) { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.3))
                    AxisTick(centered: true, stroke: StrokeStyle(lineWidth: 0.3, dash: [1, 2]))
                    AxisValueLabel(format: .dateTime.weekday(.short))
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading, values: .automatic) { value in
                    AxisGridLine(centered: true, stroke: StrokeStyle(lineWidth: 0.3, dash: [2, 5]))
               }
            }
            .chartXScale(
               range: .plotDimension(startPadding: 10, endPadding: 10)
            )
            .chartYScale(
               range: .plotDimension(startPadding: 10, endPadding: 10)
            )
            //.chartYAxis(.hidden)
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        
        /*
         Chart() {

             ForEach(Array(data.wearingTimes.enumerated()), id: \.offset) { index, time in
                     AreaMark(
                         x: .value("Dates", time.date),
                         y: .value("Steps", time.duration)
                     )
                     .interpolationMethod(.catmullRom)
                     .foregroundStyle(
                         .linearGradient(
                             colors: [
                                 Color(red: 167/255, green: 178/255, blue: 210/255).opacity(0),
                                 Color(red: 167/255, green: 178/255, blue: 210/255).opacity(0.2),
                                 Color(red: 167/255, green: 178/255, blue: 210/255).opacity(0.6)
                             ],
                             startPoint: .bottom,
                             endPoint: .top)
                     )
                     
                     LineMark(
                         x: .value("Dates", time.date),
                         y: .value("Steps", time.duration)
                     )
                     .interpolationMethod(.catmullRom)
                     .symbol {
                         ZStack{
                             Circle()
                                 .fill(.white)
                                 .frame(width: 10)
                                 .shadow(radius: 2)
                         }
                     }
                     .foregroundStyle(
                         .linearGradient(
                             colors: [
                                 Color(red: 167/255, green: 178/255, blue: 210/255).opacity(0.5),
                                 Color(red: 167/255, green: 178/255, blue: 210/255)
                             ],
                             startPoint: .bottom,
                             endPoint: .top)
                     )
                     .lineStyle(.init(lineWidth: 5))
                 }

         }
         /*.chartYAxis {
             let time = data.wearingTimes.map { $0.duration }
             let min = time.min() ?? 1000
             let max = time.max() ?? 20000
             //let consumptionStride = Array(stride(from: min, through: max, by: (max - min)/3))
             let test = Array(stride(from: min, to: max, by: 5000))
             AxisMarks(position: .trailing, values: test) { axis in
                 AxisGridLine(stroke: StrokeStyle(lineWidth: 1,
                                                  lineCap: .butt,
                                                  lineJoin: .bevel,
                                                  miterLimit: 3,
                                                  dash: [5],
                                                  dashPhase: 1))
             }
             
         } */
         .chartYAxis(.hidden)
         .chartXAxis(.hidden)
         .chartYScale(range: .plotDimension(padding: 10))
         .chartXScale(range: .plotDimension(padding: 15))
         */
    }
}

struct bg: View {
  
    var widgetFamily: WidgetFamily
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            Image("Image2") .resizable()
                .aspectRatio(1 / 1, contentMode: .fill)
                .edgesIgnoringSafeArea(.all)
                .opacity(0.05)
        case .systemLarge:
            ZStack{
                Image("Image2") .resizable()
                    .aspectRatio(1 / 1, contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.02)
                    .offset(x: -200)
                
                Image("Image2") .resizable()
                    .aspectRatio(1 / 1, contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.05)
                    .rotationEffect(.degrees(180))
                    .offset(x: 200)
            }
            
        case .systemMedium:
            ZStack{
                Image("Image2") .resizable()
                    .aspectRatio(1 / 1, contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.05)
                    .offset(x: -20)
                
                Image("Image2") .resizable()
                    .aspectRatio(1 / 1, contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.05)
                    .rotationEffect(.degrees(180))
                    .offset(x: 20)
            }
            default: Text("Default")
        }
    }
}

struct EventPlanerWidget: Widget {
    let kind: String = "ProthesenWidget"

    let persistenceController = PersistenceController.shared
    let stopWatchManager = StopWatchManager()
    let eventManager = EventManager()
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: EventPlanerWidgetProvider()) { entry in
            EventPlanerWidgetEntry(data: entry)
        }
         .configurationDisplayName("ProProthese Planer")
         .description("Habe deine Termine immer im Überblick.")
    }
}
*/
