//
//  StopWatchView.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 25.04.23.
//

import SwiftUI
import Charts

struct StopWatchView: View {
    @EnvironmentObject var stopWatchManager: StopWatchManager
    @StateObject var watchTimerModel = TimerViewModel()
    
    @State var selectedDetent: PresentationDetent = .large
    @State var isShowListSheet = false
    
    @State var devideSizeWidth: CGFloat = 0
    @Namespace var StopWatchbottomID
    var body: some View {
        GeometryReader { proxy in
            let screenWidth = proxy.size.width
            VStack {
                
                VStack{
                    Spacer()
                    
                    StopWatch(spacingBottom: 20) //ring()
                        .foregroundColor(.white)
                        .padding(.bottom, 20)
                    
                    Spacer()
                    
                    showProthesisTimes()
                        .frame(width: (screenWidth/2))
                        .padding(.bottom, 50)

                    TimerChartScrolling(devideSizeWidth)
                        .frame(maxWidth: .infinity, maxHeight: 200)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
               
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    // EditButton()
                }
                ToolbarItem {
                    Button(action: { isShowListSheet.toggle() }) {
                        Label("", systemImage: "list.star")
                    }
                }
            }
            .sheet(isPresented: $isShowListSheet) {
                ListSheetContent()
                    .presentationDetents([.large], selection: $selectedDetent)
                    .presentationDragIndicator(.visible)
            }
            .fullSizeCenter()
            .onAppear{
                stopWatchManager.devideSizeWidth = proxy.size.width
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    
    @ViewBuilder
    func ring() -> some View {
        let angleGradient = AngularGradient(colors: [.white.opacity(0.5), .blue.opacity(0.5)], center: .center, startAngle: .degrees(-90), endAngle: .degrees(360))
        
        ZStack {
            
            if stopWatchManager.isRunning {
                
                Text(stopWatchManager.fetchStartTime()!, style: .timer)
                    .font(.largeTitle)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
            } else {
                Text("0:00")
                    .font(.system(size: 50))
            }
            
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 5))
                .foregroundStyle(.white)
                .overlay {
                    // Foreground ring
                    Circle()
                        .trim(from: 0, to: 0.5 )
                        .stroke(angleGradient, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                }
                .rotationEffect(.degrees(-90))
        }
        .padding(.bottom, 20)
        
        HStack{
            Spacer()
            VStack(alignment: .center){
                Text(stopWatchManager.totalProtheseTimeYesterday)
                    .font(.system(size: 20))
                    .multilineTextAlignment(.center)
                Text("Gester")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 200)
            Spacer()
            VStack(alignment: .center){
                Text(stopWatchManager.totalProtheseTimeToday)
                    .font(.system(size: 20))
                    .multilineTextAlignment(.center)
                Text("Heute")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 200)
            Spacer()
        }
        .padding(.bottom, 20)
    }
    
    @ViewBuilder
    func StopWatch(spacingBottom: CGFloat) -> some View {
        HStack(alignment: .center ,spacing: 50){
            if stopWatchManager.isRunning {
                Text( stopWatchManager.fetchStartTime()!, style: .timer )
                    .font(.system(size: 60))
                    .padding(.bottom, spacingBottom)
            } else {
                Text("0:00")
                    .font(.system(size: 60))
                    .padding(.bottom, spacingBottom)
            }
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(AppConfig().foreground)
        
        HStack {
            Spacer()
            ZStack {
                Circle()
                    .fill(.red.opacity(0.5))
                    .frame(width: 60)
                
                Button("Stop"){
                    if stopWatchManager.isRunning {
                        stopWatchManager.stop()
                    }
                }
            }
            Spacer()
            ZStack {
                Circle()
                    .fill(.green.opacity(0.5))
                    .frame(width: 60)
                
                Button("Start"){
                    if !stopWatchManager.isRunning {
                        stopWatchManager.start()
                    }
                }
            }
            Spacer()
        }
        .foregroundColor(.white)
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder
    func showProthesisTimes() -> some View {
        HStack{
            Spacer()
            VStack(alignment: .center){
                Text(stopWatchManager.totalProtheseTimeYesterday)
                    .font(.system(size: 20))
                    .multilineTextAlignment(.center)
                Text("Gester")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 200)
            Spacer()
            VStack(alignment: .center){
                Text(stopWatchManager.totalProtheseTimeToday)
                    .font(.system(size: 20))
                    .multilineTextAlignment(.center)
                Text("Heute")
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .frame(width: 200)
            Spacer()
        }
    }
    
    @ViewBuilder
    func ListSheetContent() -> some View {
        List {
            HStack{
                Spacer()
                VStack(alignment: .center){
                    Text(stopWatchManager.totalProtheseTimeYesterday)
                        .font(.title)
                    Text("Gester")
                        .foregroundColor(AppConfig().fontLight)
                }
                Spacer()
                VStack(alignment: .center){
                    Text(stopWatchManager.totalProtheseTimeToday)
                        .font(.title)
                    Text("Heute")
                        .foregroundColor(AppConfig().fontLight)
                }
                Spacer()
            }
            .listRowBackground(Color.white.opacity(0.01))
            
            HStack{
                Text("Aufgezeichnete Zeit")
                Spacer()
                Text("Datum")
            }
            .listRowBackground(Color.white.opacity(0.2))
            
            
            ForEach(stopWatchManager.timesArray, id: \.timestamp) { time in
                HStack {
                    Text(stopWatchManager.convertSecondsToHrMinuteSec(seconds: Int(time.duration) ))
                    Spacer()
                    Text("\(time.timestamp!.formatted(.dateTime.hour().minute())) Uhr -")
                    Text("\(time.timestamp!.formatted(.dateTime.day().month()))")
                    
                }
                .listRowBackground(Color.white.opacity(0.05))
            }
            .onDelete(perform: stopWatchManager.deleteItems)
            
        }
        .refreshable {
            do {
                stopWatchManager.refetchTimesData()
            }
        }
        .background{
            AppConfig().backgroundGradient
        }
        .ignoresSafeArea()
        .scrollContentBackground(.hidden)
        .foregroundColor(.white)
    }
    
    @ViewBuilder
    func TimerChartScrolling(_ devideSizeWidth: CGFloat) -> some View {
        ScrollViewReader { value in
            ScrollView(.horizontal, showsIndicators: false){
                HStack{
                    Chart() {
                       RuleMark(y: .value("Durchschnitt", stopWatchManager.avgTimes() ))
                         .foregroundStyle(.orange.opacity(0.5))

                        RuleMark(x: .value("ActiveSteps", stopWatchManager.activeDateCicle ) )
                            .foregroundStyle(stopWatchManager.activeisActive ? .white.opacity(1) : .white.opacity(0.2))
                            .offset(stopWatchManager.dragAmount)
                        
                        ForEach(stopWatchManager.mergedTimesArray, id: \.id) { t in
                            AreaMark(
                                x: .value("Dates", t.date),
                                y: .value("Steps", t.duration)
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
                                y: .value("Steps", t.duration)
                            )
                            .interpolationMethod(.catmullRom)
                            .symbol {
                                VStack{
                                    ZStack{
                                        Circle()
                                            .fill(.white)
                                            .frame(width: 10)
                                            .shadow(radius: 2)
                                        
                                        if stopWatchManager.activeDateCicle == t.date {
                                            Circle()
                                                .stroke(Color.white, lineWidth: 2)
                                                .frame(width: 20)
                                                .shadow(radius: 2)
                                        }
                                    }
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
                    .frame(width: stopWatchManager.calcChartItemSize())
                    .chartOverlay { proxy in
                        GeometryReader { geometry in
                            ZStack(alignment: .top) {
                                Rectangle().fill(.clear).contentShape(Rectangle())
                                    .onTapGesture { location in
                                        updateSelectedStep(at: location, proxy: proxy, geometry: geometry)
                                    }
                                    .gesture( DragGesture().onChanged { value in
                                        // find start and end positions of the drag
                                        let start = geometry[proxy.plotAreaFrame].origin.x
                                        let xStart = value.startLocation.x - start
                                        let xCurrent = value.location.x - start
                                        // map those positions to X-axis values in the chart
                                        if let dateCurrent: Date = proxy.value(atX: xCurrent) {
                                            stopWatchManager.activeDateCicle = dateCurrent //(dateStart, dateCurrent)
                                            withAnimation(.easeIn(duration: 0.2)){
                                                stopWatchManager.activeisActive = true
                                            }
                                        }
                                        
                                        updateSelectedStep(at: CGPoint(x: value.location.x, y: value.location.y) , proxy: proxy, geometry: geometry)
                                    }.onEnded { value in
                                        withAnimation(.easeOut(duration: 0.2)){
                                            stopWatchManager.activeisActive = false
                                        }
                                        updateSelectedStep(at: value.predictedEndLocation, proxy: proxy, geometry: geometry)
                                    } )
                            }
                        }
                    }
                    //Vertical
                    .chartYAxis {
                        let sec = stopWatchManager.mergedTimesArray.map { $0.duration }
                        let min = sec.min() ?? 1000
                        let max = sec.max() ?? 20000
                        
                        //let consumptionStride = Array(stride(from: min, through: max, by: (max - min)/3))
                        let test = Array(stride(from: min, to: max, by: 5808))
                        AxisMarks(position: .trailing, values: test) { axis in
                            AxisGridLine(stroke: StrokeStyle(lineWidth: 1,
                                                             lineCap: .butt,
                                                             lineJoin: .bevel,
                                                             miterLimit: 20,
                                                             dash: [10],
                                                             dashPhase: 1))
                            
                            AxisValueLabel(content: {
                                if let intValue = axis.as(Int.self) {
                                    Text("\(intValue / 3600) h")
                                        .font(.system(size: 10))
                                        .multilineTextAlignment(.trailing)
                                }
                            })
                        }
                        
                    }
                    .chartYScale(domain: stopWatchManager.maxValue(margin: 3600))
                    .chartYScale(range: .plotDimension(padding: 40))
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day, count: 1)) { value in
                            AxisGridLine(stroke: StrokeStyle(lineWidth: 0.3))
                            
                            if value.count > 7 {
                                AxisValueLabel(format: .dateTime.day().month())
                            } else {
                                AxisValueLabel(format: .dateTime.weekday())
                            }
                            
                            
                        }
                    }
                    .chartXScale(
                        range: .plotDimension(startPadding: 60)
                    )
                    
                    Text("").id(StopWatchbottomID)
                }
            }
            .onChange(of: stopWatchManager.fetchDays){ new in
                withAnimation(.easeInOut(duration: 1)){
                    value.scrollTo(StopWatchbottomID)
                    TabManager().currentTab = .timer
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                    withAnimation(.easeInOut(duration: 1)){
                        value.scrollTo(StopWatchbottomID)
                    }
                }
            }
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .padding(.bottom)
    }
    
    func updateSelectedStep(at location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) {
        let xPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        guard let date: Date = proxy.value(atX: xPosition) else {
            return
        }
        
        stopWatchManager.activeDateCicle = stopWatchManager.mergedTimesArray.sorted(by: {
            abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date))
        }).first?.date ?? Date()
        
    }
}
