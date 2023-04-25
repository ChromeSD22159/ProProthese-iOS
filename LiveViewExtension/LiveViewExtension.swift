//
//  LiveViewExtension.swift
//  LiveViewExtension
//
//  Created by Frederik Kohler on 25.04.23.
//

import WidgetKit
import SwiftUI
import Foundation
import Charts

struct Provider: TimelineProvider {
    @Environment(\.managedObjectContext) private var viewContext
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }
    
   // let stepsArray = UserDefaults.array(forKey: "StepsWidget")
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date

    
}

struct LiveViewExtensionEntryView : View {
    var entry: Provider.Entry
    var ste:Int = 13215
   
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        ZStack{
            AppConfig().backgroundGradient
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
            
            GeometryReader { proxy in
                VStack {
                    
                    switch widgetFamily {
                    case .systemSmall: VStack { StepSmallCircle(proxy.size) }
                    case .systemLarge: VStack { StepLargeCircle(proxy.size) }
                    case .systemMedium: StepMediumCircle(proxy.size)
                        default: Text("Default")
                    }


                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
                
        }
    }
    
    @ViewBuilder
    func StepSmallCircle(_ proxy: CGSize) -> some View {
        ZStack {
            VStack {
                Image("prothesis")
                    .imageScale(.large)
                    .font(Font.system(size: proxy.width/10, weight: .heavy))
                    .padding(.bottom, 1)
                Text("\(ste)")
                    .fontWeight(.semibold)
            }
            .foregroundColor(.white)
            
            Circle()
                .stroke(lineWidth: proxy.width/15)
                .opacity(0.2)
                .foregroundColor(Color.blue)
                .frame(width: proxy.width/2)
            
            Circle()
                .trim(from: 0.0, to: 0.8)
                .stroke(style: StrokeStyle(lineWidth: proxy.width/15, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.orange)
                .rotationEffect(.degrees(-90))
                .frame(width: proxy.width/2)
        }

    }
    
    @ViewBuilder
    func StepMediumCircle(_ proxy: CGSize) -> some View {
        HStack(spacing: 50){
            ZStack {
                VStack {
                    Image("prothesis")
                        .imageScale(.large)
                        .font(Font.system(size: proxy.width/10, weight: .heavy))
                        .padding(.bottom, 1)
                    Text("\(ste)")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                
                Circle()
                    .stroke(lineWidth: proxy.width/50)
                    .opacity(0.2)
                    .foregroundColor(Color.blue)
                    .frame(width: proxy.width/3)
                
                Circle()
                    .trim(from: 0.0, to: 0.8)
                    .stroke(style: StrokeStyle(lineWidth: proxy.width/50, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color.orange)
                    .rotationEffect(.degrees(-90))
                    .frame(width: proxy.width/3)
            }
            ZStack {
                VStack {
                    Image("prothesis")
                        .imageScale(.large)
                        .font(Font.system(size: proxy.width/10, weight: .heavy))
                        .padding(.bottom, 1)
                    Text("\(ste)")
                        .fontWeight(.semibold)
                }
                .foregroundColor(.white)
                
                Circle()
                    .stroke(lineWidth: proxy.width/50)
                    .opacity(0.2)
                    .foregroundColor(Color.blue)
                    .frame(width: proxy.width/3)
                
                Circle()
                    .trim(from: 0.0, to: 0.8)
                    .stroke(style: StrokeStyle(lineWidth: proxy.width/50, lineCap: .round, lineJoin: .round))
                    .foregroundColor(Color.orange)
                    .rotationEffect(.degrees(-90))
                    .frame(width: proxy.width/3)
            }
        }
    }
    
    @ViewBuilder
    func StepLargeCircle(_ proxy: CGSize) -> some View {
        VStack(){
            Spacer()
            
            HStack(alignment: .bottom){
                Spacer()
                VStack(alignment: .center){
                    Image("prothesis")
                        .imageScale(.large)
                        .font(Font.system(size: proxy.width/6, weight: .heavy))
                        .padding(.bottom, 1)
                    Text("\(ste)")
                        .fontWeight(.semibold)
                }
                Spacer()
                VStack(alignment: .center){
                    Image(systemName: "clock")
                        .imageScale(.large)
                        .font(Font.system(size: proxy.width/8, weight: .heavy))
                        .padding(.bottom, 1)
                    
                    Text("1:52h")
                        .fontWeight(.semibold)
                }
                
                Spacer()
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
            
            HStack(alignment: .bottom){
                Spacer()
                VStack(alignment: .center){
                    Image("prothesis")
                        .imageScale(.large)
                        .font(Font.system(size: proxy.width/6, weight: .heavy))
                        .padding(.bottom, 1)
                    Text("\(ste)")
                        .fontWeight(.semibold)
                }
                Spacer()
                VStack(alignment: .center){
                    Image(systemName: "clock")
                        .imageScale(.large)
                        .font(Font.system(size: proxy.width/8, weight: .heavy))
                        .padding(.bottom, 1)
                    
                    Text("1:52h")
                        .fontWeight(.semibold)
                }
                
                Spacer()
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity, alignment: .center)
            
            Spacer()
        }
    }
}

struct LiveViewExtension: Widget {
    let kind: String = "LiveViewExtension"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            LiveViewExtensionEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct LiveViewExtension_Previews: PreviewProvider {
    static var previews: some View {
        LiveViewExtensionEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
        
        LiveViewExtensionEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
        
        LiveViewExtensionEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
