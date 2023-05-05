//
//  StepCounter.swift
//  Pro Prothese
//
//  Created by Frederik Kohler on 23.04.23.
//

import SwiftUI
import Charts
import HealthKit
import Combine
import Foundation

struct StepCounterView: View {
    @Environment(\.scenePhase) var scenePhase
    var healthStore: HealthStore?
    @EnvironmentObject var stepCounterManager: StepCounterManager
    @EnvironmentObject var TM: TabManager
    @EnvironmentObject var stopWatchManager: StopWatchManager
    @EnvironmentObject var healthStorage: HealthStorage
    
    
    @Namespace private var MoodAnimationCounter
    @Namespace var StepCounterbottomID
    
    @State private var dragAmount = CGSize.zero
    
    init(){
        healthStore = HealthStore()
    }
    
    var body: some View {
        VStack{
            GeometryReader { proxy in
                VStack{
                    VStack{
                        HeaderComponent()
                            .padding(.bottom)

                        ZStack{
                            
                            RecorderButton()
                                .padding(.top, 10)
                                .padding(.trailing, 15)
                            
                            
                            StepCircle(Double: stepCounterManager.dez(Int: stepCounterManager.activeStepCount))
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                        
                        Spacer()
                        
                        // MARK: Small Active Circle
                        HStack{
                            Spacer()

                            VStack {
                                ring(color: .blue, trim: 0.9, stroke: 3, delay: 1, image: "percent")
                                    .frame(width: 50)
                                    .animation(.easeInOut(duration: 1), value: stepCounterManager.drawingRingStroke)
                                
                                Text("\(stepCounterManager.percent(Int: stepCounterManager.activeStepCount), specifier: "%.0f")%")
                                    .foregroundColor(.white)
                                
                                Text("vom Tagesziel")
                                    .font(.callout)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            VStack {
                                ring(color: .blue, trim: 0.9, stroke: 3, delay: 1, image: "figure.walk")
                                    .frame(width: 50)
                                    .animation(.easeInOut(duration: 1), value: stepCounterManager.drawingRingStroke)
                                
                                Text("\(String(format: "%.2f", stepCounterManager.activeStepDistance / 1000.0) ) km")
                                    .foregroundColor(.white)
                                
                                Text("Tages Distanz")
                                    .font(.callout)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            VStack {
                                ring(color: .blue, trim: 0.9, stroke: 3, delay: 1, image: "figure.walk")
                                    .frame(width: 50)
                                    .animation(.easeInOut(duration: 1), value: stepCounterManager.drawingRingStroke)
                                
                                Text("\(stepCounterManager.avgSteps(steps: healthStorage.Steps))")
                                    .foregroundColor(.white)
                                
                                Text("⌀ Schritte \(stepCounterManager.fetchDays)")
                                    .font(.callout)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                        }
                        Spacer()
                    }
                    .frame(maxHeight: .infinity, alignment: .top)
                    .onChange(of: stepCounterManager.activeStepCount, perform: { newCount in
                        stepCounterManager.drawingRingStroke = false
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                            stepCounterManager.drawingRingStroke = true
                        })
                    })
                    .onAppear{
                        loadData(days: 7)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            stepCounterManager.devideSizeWidth = proxy.size.width
                            stepCounterManager.activeStepCount = healthStorage.showStep
                            stepCounterManager.activeStepDistance = healthStorage.Distances.last ?? 9999
                            stepCounterManager.activeDateCicle = healthStorage.showDate
                            stepCounterManager.drawingRingStroke = true
                        })
                        
                    }
                    
                    
                    // MARK: CHARTswitcher
                    chooseDay()
                    
                   // StepChartNoScrolling()
                    
                    StepChartScrolling(days: stepCounterManager.fetchDays)
                    // MARK: CHART
//                    if(stepCounterManager.fetchDays == 7){
//                        // StepChartNoScrolling()
//                    } else {
//                       // StepChartScrolling(days: stepCounterManager.fetchDays)
//                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: stepCounterManager.fetchDays){ new in
            loadData(days: new)
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
            } else if newPhase == .inactive {
                
            } else if newPhase == .background {
       
            }
        }
        
    }
    
    func loadData(days: Int) {
        if let healthStore = healthStore {
            healthStore.requestAuthorization { success in
                if success {
                    
                    healthStore.getDistance { statisticsCollection in
                       let startDate =  Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -(days-1), to: Date())!)
                        
                        var arr = [Double]()
                        var distances = [Double]()
                        if let statisticsCollection = statisticsCollection {
                            
                            statisticsCollection.enumerateStatistics(from: startDate, to: Date()) { (statistics, stop) in
                                let count = statistics.sumQuantity()?.doubleValue(for: HKUnit.meter())
                                arr.append(count ?? 0)
                                distances.append(count ?? 0)
                            }
                            
                        }
                        
                        DispatchQueue.main.async {
                            healthStorage.showDistance = distances.last ?? 0 // Update APPStorage for distance in HomeTabView
                            healthStorage.Distances = distances
                        }
                        
                    }
   
                    healthStore.calculateSteps { statisticsCollection in
                        if let statisticsCollection = statisticsCollection {
                            // update the UI
                            let startDateNew =  Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: -(days-1), to: Date())!)
                            let endDateNew = Date()
                            var StepsData: [Step] = [Step]()
                            statisticsCollection.enumerateStatistics(from: startDateNew, to: endDateNew) { (statistics, stop) in
                                let count = statistics.sumQuantity()?.doubleValue(for: .count())
                                let step = Step(count: Int(count ?? 0), date: statistics.startDate, dist: nil)
                                StepsData.append(step)
                            }

                            
                            DispatchQueue.main.async {
                                healthStorage.showStep = StepsData.last?.count ?? 0 // Update APPStorage for Circle in HomeTabView
                                healthStorage.Steps = StepsData
                                healthStorage.StepCount = StepsData.count
                                healthStorage.showDate = StepsData.last?.date ?? Date()
                            }
                           
                            
                        }
                    }
                   
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        mergeArray()
                    })
                }
            }
        }
    }
    
    func mergeArray(){
        let distances = healthStorage.Distances
        var steps = healthStorage.Steps
        
        var newSteps: [Step] = [Step]()

        for (index, step) in steps.enumerated() {
            if index == 0 {
                let newStep = Step(count: step.count, date: step.date, dist: nil)
                newSteps.append(newStep)
            } else {
                let newStep = Step(count: step.count, date: step.date, dist: distances[index])
                newSteps.append(newStep)
            }
            
            
        }
        steps.removeAll(keepingCapacity: false)
        healthStorage.Steps = newSteps
    }
    
    func updateSelectedStep(at location: CGPoint, proxy: ChartProxy, geometry: GeometryProxy) {
        let xPosition = location.x - geometry[proxy.plotAreaFrame].origin.x
        guard let date: Date = proxy.value(atX: xPosition) else {
            return
        }
        
        stepCounterManager.activeDateCicle = healthStorage.Steps.sorted(by: {
            abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date))
        }).first?.date ?? Date()
        
        stepCounterManager.activeStepDistance = healthStorage.Steps.sorted(by: {
            abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date))
        }).first?.dist ?? 9999999
        
        stepCounterManager.activeStepCount = healthStorage.Steps.sorted(by: {
            abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date))
        }).first?.count ?? 9999999
    }
    
    // MARK: Recorder
    @ViewBuilder
    func RecorderButton() -> some View {
        VStack{
            HStack{
                if AppConfig().ShowRecordOnHomeView == true {
                    Button {
                        if stopWatchManager.isRunning {
                            stopWatchManager.stop()
                        } else {
                            stopWatchManager.start()
                        }
                    } label: {
                        VStack{
                            if stopWatchManager.isRunning {
                                Image(systemName: "record.circle")
                                    .font(.largeTitle)
                                    .foregroundColor(.red)
                                Text(stopWatchManager.fetchStartTime()!, style: .timer)
                                    .font(.caption2)
                                    .padding(.top, 2)
                                    .foregroundColor(.white)
                            } else {
                                Image(systemName: "record.circle")
                                    .font(.largeTitle)
                                    .foregroundColor(.white)
                                Text("0:00")
                                    .font(.caption2)
                                    .padding(.top, 2)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
    }
    
    // MARK: Step Circle VB
    @ViewBuilder
    func StepCircle(Double: Double) -> some View {
        ZStack {
            ring(color: .blue, trim: Double, stroke: 5, delay: 1, image: "")
                .frame(width: 200)
                .animation(.easeIn(duration: 1), value: stepCounterManager.drawingRingStroke)
            
            if stepCounterManager.drawingshowRecordStroke {
                Roundes(for: .blue)
                    .frame(width: 250)
                    .animation(.linear(duration: 1).repeatForever(autoreverses: false), value: stepCounterManager.drawingRecordStroke)
            }
            
            VStack {
                Image("prothesis")
                    .imageScale(.large)
                    .font(Font.system(size: 50, weight: .regular))
                    .frame(width: 50, height: 50)
                
                Button("\(stepCounterManager.activeStepCount)"){
                    withAnimation{
                        stepCounterManager.drawingshowRecordStroke.toggle()
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1){
                        stepCounterManager.drawingRecordStroke.toggle()
                    }
                }
            }
            .foregroundColor(.white)
            
        }
        .padding(.bottom)
    }
    
    // MARK: Select Days VB
    @ViewBuilder
    func chooseDay() -> some View {
        HStack(spacing: 5) {
            chooseDayButton(7)
            
            chooseDayButton(30)
            
            chooseDayButton(90)
        }
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    // MARK: Select Button VB
    @ViewBuilder
    func chooseDayButton(_ day: Int) -> some View {
        HStack{
            Button("\(day) Tage"){
                loadData(days: day)
                stepCounterManager.fetchDays = day
            }
        }
        .frame(maxWidth: .infinity)
        .padding(5)
        .background(AppConfig().backgroundLabel)
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(lineWidth: 2)
                .stroke(AppConfig().backgroundLabel)
        )
        .cornerRadius(10)
    }
    
    // MARK: No Scrollable Chart VB
    @ViewBuilder
    func StepChartNoScrolling() -> some View{
        HStack {
            Chart() {
                
                if AppConfig().stepRuleMark {
                    RuleMark(y: .value("Durchschnitt", stepCounterManager.avgSteps(steps: healthStorage.Steps) ) )
                        .foregroundStyle(.orange.opacity(0.5))
                }
                
                RuleMark(x: .value("ActiveSteps", stepCounterManager.activeDateCicle ) )
                    .foregroundStyle(stepCounterManager.activeisActive ? .white.opacity(1) : .white.opacity(0.2))
                    .offset(dragAmount)
                
                
                if AppConfig().ChartBarIsShowing {
                    ForEach(Array(healthStorage.Steps.enumerated()), id: \.offset) { index, step in
                        BarMark(
                            x: .value("Dates", step.date),
                            y: .value("Steps", (step.count))
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(stepCounterManager.targetSteps < step.count ? .green.opacity(0.2) : .white.opacity(0))
                    }
                }
                
                if AppConfig().ChartLineDistanceIsShowing {
                    ForEach(Array(healthStorage.Steps.enumerated()), id: \.offset) { index, step in
                        LineMark(
                            x: .value("Dates", step.date),
                            y: .value("Steps", (step.dist ?? 0))
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(.red)
                        .lineStyle(StrokeStyle(lineWidth: 3, dash: [5, 10]))
                        .symbol() {
                            Rectangle()
                                .fill(.red)
                                .frame(width: 8, height: 8)
                        }
                        .symbolSize(30)
                        .accessibilityLabel("\(step.date)")
                        .accessibilityValue("\(step.count) Steps")
                    }
                }
                
                if AppConfig().ChartLineStepsIsShowing {
                    ForEach(Array(healthStorage.Steps.enumerated()), id: \.offset) { index, step in
                        AreaMark(
                            x: .value("Dates", step.date),
                            y: .value("Steps", (step.count))
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
                            x: .value("Dates", step.date),
                            y: .value("Steps", (step.count))
                        )
                        .interpolationMethod(.catmullRom)
                        .symbol {
                            ZStack{
                                Circle()
                                    .fill(.white)
                                    .frame(width: 10)
                                    .shadow(radius: 2)
                                
                                if stepCounterManager.activeDateCicle == step.date {
                                    Circle()
                                        .stroke(Color.white, lineWidth: 2)
                                        .frame(width: 20)
                                        .shadow(radius: 2)
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
                        .foregroundStyle(by: .value("step", "Schritte"))
                    }
                }
                
                
            }
            //.frame(width: stepCounterManager.calcChartItemSize())
            .chartForegroundStyleScale([
             "Schritte": Color.white,
             "Distanz": Color.red,
             "Durschnitt": Color.orange
             ])
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    ZStack(alignment: .top) {
                        Rectangle().fill(.clear).contentShape(Rectangle())
                            .onTapGesture { location in updateSelectedStep(at: location, proxy: proxy, geometry: geometry) }
                            .gesture( DragGesture().onChanged { value in
                                // find start and end positions of the drag
                                let start = geometry[proxy.plotAreaFrame].origin.x
                                let xStart = value.startLocation.x - start
                                let xCurrent = value.location.x - start
                                // map those positions to X-axis values in the chart
                                if let dateCurrent: Date = proxy.value(atX: xCurrent) {
                                    stepCounterManager.activeDateCicle = dateCurrent //(dateStart, dateCurrent)
                                    withAnimation(.easeIn(duration: 0.2)){
                                        stepCounterManager.activeisActive = true
                                    }
                                }
                                updateSelectedStep(at: CGPoint(x: value.location.x, y: value.location.y) , proxy: proxy, geometry: geometry)
                            }.onEnded { value in
                                withAnimation(.easeOut(duration: 0.2)){
                                    stepCounterManager.activeisActive = false
                                }
                                updateSelectedStep(at: value.predictedEndLocation, proxy: proxy, geometry: geometry)
                            } )
                    }
                }
            }
            .chartYAxis {
                let steps = healthStorage.Steps.map { $0.count }
                let min = steps.min() ?? 1000
                let max = steps.max() ?? 20000
                //let consumptionStride = Array(stride(from: min, through: max, by: (max - min)/3))
                let test = Array(stride(from: min, to: max, by: 5000))
                AxisMarks(position: .trailing, values: test) { axis in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 2,
                                                     lineCap: .butt,
                                                     lineJoin: .bevel,
                                                     miterLimit: 3,
                                                     dash: [5],
                                                     dashPhase: 1))
                }
                
            }
            .chartXAxis {
                AxisMarks(values: .stride(by: .day, count: 1)) { value in
                    AxisGridLine(stroke: StrokeStyle(lineWidth: 0.3))
                    // print(value)
                    if value.count > 7 {
                        AxisValueLabel(format: .dateTime.day().month())
                    } else {
                        AxisValueLabel(format: .dateTime.weekday())
                    }
                    
                    
                }
            }
            .chartYScale(range: .plotDimension(padding: 20))
            .chartXScale(range: .plotDimension(padding: 30))
            Text("").id(StepCounterbottomID)
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .padding(.bottom)
    }
    
    // MARK: Scrollable Chart VB
    @ViewBuilder
    func StepChartScrolling(days: Int) -> some View{
        ScrollViewReader { value in
            ScrollView(.horizontal, showsIndicators: false){
                HStack {
                    Chart() {
                        if AppConfig().stepRuleMark {
                            RuleMark(y: .value("Durchschnitt", stepCounterManager.avgSteps(steps: healthStorage.Steps) ) )
                                .foregroundStyle(.orange.opacity(0.5))
                        }
                        if AppConfig().ChartBarIsShowing {
                            ForEach(Array(healthStorage.Steps.enumerated()), id: \.offset) { index, step in
                                BarMark(
                                    x: .value("Dates", step.date),
                                    y: .value("Steps", (step.count))
                                )
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(stepCounterManager.targetSteps < step.count ? .green.opacity(0.2) : .white.opacity(0))
                            }
                        }
                        
                        if AppConfig().ChartLineDistanceIsShowing {
                            ForEach(Array(healthStorage.Steps.enumerated()), id: \.offset) { index, step in
                                LineMark(
                                    x: .value("Dates", step.date),
                                    y: .value("Steps", (step.dist ?? 0))
                                )
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(.red)
                                .foregroundStyle(by: .value("distance", "Distanz"))
                                .lineStyle(StrokeStyle(lineWidth: 3, dash: [5, 10]))
                                .symbol() {
                                    Rectangle()
                                        .fill(.red)
                                        .frame(width: 8, height: 8)
                                }
                                .symbolSize(30)
                                .accessibilityLabel("\(step.date)")
                                .accessibilityValue("\(step.count) Steps")
                            }
                        }
                        
                        if AppConfig().ChartLineStepsIsShowing {
                            ForEach(Array(healthStorage.Steps.enumerated()), id: \.offset) { index, step in
                                AreaMark(
                                    x: .value("Dates", step.date),
                                    y: .value("Steps", (step.count))
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
                                    x: .value("Dates", step.date),
                                    y: .value("Steps", (step.count))
                                )
                                .interpolationMethod(.catmullRom)
                                .symbol {
                                    ZStack{
                                        Circle()
                                            .fill(.white)
                                            .frame(width: 10)
                                            .shadow(radius: 2)
                                        
                                        if stepCounterManager.activeDateCicle == step.date {
                                            Circle()
                                                .stroke(Color.white, lineWidth: 2)
                                                .frame(width: 20)
                                                .shadow(radius: 2)
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
                                //.foregroundStyle(by: .value("step", "Schritte"))
                            }
                        }
                        
                    }
                    .frame(width: stepCounterManager.calcChartItemSize())
                    .chartForegroundStyleScale([
                     "Schritte": Color.white,
                     "Distanz": Color.red,
                     "Durschnitt": Color.orange
                     ])
                    .chartOverlay { proxy in
                        GeometryReader { geometry in
                            ZStack(alignment: .top) {
                                Rectangle().fill(.clear).contentShape(Rectangle())
                                    .onTapGesture { location in
                                        updateSelectedStep(at: location, proxy: proxy, geometry: geometry)
                                    }
                            }
                        }
                    }
                    .chartYAxis {
                        let steps = healthStorage.Steps.map { $0.count }
                        let min = steps.min() ?? 1000
                        let max = steps.max() ?? 20000
                        let consumptionStride = Array(stride(from: min, through: max, by: (max - min)/3))
                        AxisMarks(position: .trailing, values: consumptionStride) { axis in
                            let value = consumptionStride[axis.index]
                            //AxisValueLabel("\(value)", centered: true)
                            AxisGridLine(stroke: StrokeStyle(lineWidth: 2,
                                                             lineCap: .butt,
                                                             lineJoin: .bevel,
                                                             miterLimit: 3,
                                                             dash: [5],
                                                             dashPhase: 1))
                        }
                    }
                    .chartXAxis {
                        AxisMarks(values: .stride(by: .day, count: 1)) { value in
                            AxisGridLine(stroke: StrokeStyle(lineWidth: 0.3))
                            // print(value)
                            if value.count > 7 {
                                AxisValueLabel(format: .dateTime.day().month())
                            } else {
                                AxisValueLabel(format: .dateTime.weekday())
                            }
                            
                            
                        }
                    }
                    .chartYScale(range: .plotDimension(padding: 20))
                    .chartXScale(range: .plotDimension(padding: 20))
                    Text("").id(StepCounterbottomID)
                }
                
            }
            .onChange(of: stepCounterManager.fetchDays){ new in
                withAnimation(.easeInOut(duration: 1)){
                    value.scrollTo(StepCounterbottomID)
                    //TM.currentTab = .step
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                    withAnimation(.easeInOut(duration: 1)){
                        if stepCounterManager.fetchDays != 7 {
                            value.scrollTo(StepCounterbottomID)
                        }
                    }
                }
            }
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .padding(.bottom)
    }
    
    // MARK: CIRCLES VB
    @ViewBuilder
    func ring(color: Color, trim: Double, stroke: Double, delay: Double, image: String?) -> some View {
        // Background ring
        ZStack {
            if image != "" {
                Image(systemName: image ?? "figure.walk", variableValue: 5)
                    .opacity(image != nil ? Double(1) : Double(0))
            } 
            Circle()
                .stroke(style: StrokeStyle(lineWidth: stroke))
                .foregroundStyle(.tertiary)
                .overlay {
                    // Foreground ring
                    Circle()
                        .trim(from: 0, to: stepCounterManager.drawingRingStroke ? trim : 0 )
                        .stroke(stepCounterManager.angleGradient, style: StrokeStyle(lineWidth: stroke, lineCap: .round))
                }
                .rotationEffect(.degrees(-90))
        }
        
    }
    
    @ViewBuilder
    func Roundes(for color: Color) -> some View {
          // Background ring
          Circle()
              .stroke(style: StrokeStyle(lineWidth: 5))
              .foregroundStyle(.tertiary)
              .overlay {
                  // Foreground ring
                  Circle()
                      .trim(from: 0, to: stepCounterManager.drawingRecordStroke ? 1 : 0)
                      .stroke(stepCounterManager.recordGradient, style: StrokeStyle(lineWidth: 5, lineCap: .round))
              }
              .rotationEffect(.degrees(-90))
      }
    
}
