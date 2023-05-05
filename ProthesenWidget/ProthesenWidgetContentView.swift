//
//  ProthesenWidgetContentView.swift
//  ProthesenWidgetExtension
//
//  Created by Frederik Kohler on 05.05.23.
//

import SwiftUI
import WidgetKit
import Charts

struct ProthesenWidgetContentView : View {
    @Environment(\.widgetFamily) var widgetFamily
    
    var data: WidgetData

    var body: some View {
        GeometryReader{ proxy in
            ZStack{
                AppConfig().backgroundGradient
                bg(widgetFamily: widgetFamily)
                
                switch widgetFamily {
                    case .systemSmall: SmallWidget(data: data, screenSize: proxy.size)
                case .systemMedium: MediumWidget(data: data, screenSize: proxy.size)
                    case .systemLarge: LargeWidget(data: data, screenSize: proxy.size)
                    default: Text("Default")
               }

            }
        }
    }
}


struct SmallWidget: View {
    var data: WidgetData
    var screenSize: CGSize
    var body: some View {
        VStack(alignment: .center){
            VStack{
                Text("\(convertSecondsToHrMinuteSec(seconds: Int(data.wearingTimes.last?.duration ?? 0)))")
                    .padding(.top, 10)
                Text("Heutige getragen")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            .frame(maxHeight: .infinity)
            
            
            HStack(){
                WearingChart(data: data)
            }
            .padding(.horizontal, 10)
            .frame(maxHeight: .infinity)
        }
        .padding(10)
        .widgetURL(URL(string: "Pro-these-://timer"))
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

struct MediumWidget: View {
    var data: WidgetData
    var screenSize: CGSize
    var body: some View {
        GeometryReader { proxy in
            VStack(alignment: .center){
                VStack(alignment: .leading){
                    Text("\(convertSecondsToHrMinuteSec(seconds: Int(data.wearingTimes.last?.duration ?? 0))) Tragezeit Heute")
                        .fontWeight(.medium)
                }
                .frame(maxWidth: proxy.size.width)
                .padding()
                
                HStack(alignment: .top){
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
                                            Color(red: 167/255, green: 178/255, blue: 210/255).opacity(0.1),
                                            Color(red: 167/255, green: 178/255, blue: 210/255).opacity(0.5)
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
                    .chartYAxis {
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
                        
                    }
                    .chartXAxis(.hidden)
                    .chartYScale(range: .plotDimension(padding: 10))
                    .chartXScale(range: .plotDimension(padding: 15))
                    
                }
                .frame(maxWidth: .infinity, maxHeight: proxy.size.height / 3.5)
            }
            .frame(width: proxy.size.width, height: proxy.size.height, alignment: .top)
        }
    }
    
    func convertSecondsToHrMinuteSec(seconds:Int) -> String{
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
      
        let formattedString = formatter.string(from:TimeInterval(seconds))!
        return formattedString
    }
}

struct LargeWidget: View {
    var data: WidgetData
    var screenSize: CGSize
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct WearingChart: View {
    var data: WidgetData
    var body: some View {
        Chart{
            ForEach(data.wearingTimes, id: \.id) { t in
                AreaMark(
                    x: .value("Dates", t.date),
                    y: .value("Duration", t.duration)
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(
                    .linearGradient(
                        colors: [
                            Color(red: 167/255, green: 178/255, blue: 210/255).opacity(0),
                            Color(red: 167/255, green: 178/255, blue: 210/255).opacity(0.1),
                            Color(red: 167/255, green: 178/255, blue: 210/255).opacity(0.5)
                        ],
                        startPoint: .bottom,
                        endPoint: .top)
                )
                
                LineMark(
                    x: .value("Dates", t.date),
                    y: .value("Duration", t.duration)
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
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
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

/*
struct ProthesenWidget_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader{ proxy in
            
            SmallWidget(data: WidgetData(date: Date(), wearingTimes: []), screenSize: proxy.size)
                .previewContext(WidgetPreviewContext(family: .systemSmall))
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)

            MediumWidget(data: WidgetData(date: Date(), wearingTimes: []))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)

            LargeWidget(data: WidgetData(date: Date(), wearingTimes: []))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
                .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)

        }
    }
}
*/
struct ProthesenWidget: Widget {
    let kind: String = "ProthesenWidget"

    let persistenceController = PersistenceController.shared
    let stopWatchManager = StopWatchManager()
    let eventManager = EventManager()
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            ProthesenWidgetContentView(data: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}
