//
//  StepCounter.swift
//  ProWatchOS Watch App
//
//  Created by Frederik Kohler on 29.04.23.
//

import SwiftUI
import Charts
import HealthKit


struct StepCounterWatchView: View {
    var healthStore: HealthStore?
    @EnvironmentObject var healthStorage: HealthStorage
    @EnvironmentObject var SM: StepCounterManager
    
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
                    // Circle with Steps
                    HStack {
                        StepCircle(Double: SM.dez(Int: SM.activeStepCount))
                            .padding(.leading, 10)
                        Spacer()
                        VStack(alignment: .trailing){
                            Text("\(SM.activeStepCount)")
                                .font(.largeTitle)
                                .fontWeight(.medium)
   
                            Text(SM.activeDateCicle, style: .date)
                                .font(.caption2)
                                .foregroundColor(.gray)
                            
                        }
                        .padding(.trailing, 10)
                    }
                    .padding(.vertical)
                    
                    // Chart with all Weekly Steps
                    StepChartNoScrolling(screenSize: proxy.size)
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
             
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: SM.fetchDays){ new in
            loadData(days: new)
        }
        .onAppear{
            loadData(days: 7)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                SM.activeStepCount = healthStorage.showStep
                SM.activeStepDistance = healthStorage.Distances.last ?? 9999
                SM.activeDateCicle = healthStorage.showDate
                SM.drawingRingStroke = true
            })
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
        
        SM.activeDateCicle = healthStorage.Steps.sorted(by: {
            abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date))
        }).first?.date ?? Date()
        
        SM.activeStepDistance = healthStorage.Steps.sorted(by: {
            abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date))
        }).first?.dist ?? 9999999
        
        SM.activeStepCount = healthStorage.Steps.sorted(by: {
            abs($0.date.timeIntervalSince(date)) < abs($1.date.timeIntervalSince(date))
        }).first?.count ?? 9999999
    }

    // MARK: No Scrollable Chart VB
    @ViewBuilder
    func StepChartNoScrolling(screenSize: CGSize) -> some View{
        HStack {
            Chart() {
                
                if AppConfig().stepRuleMark {
                    RuleMark(y: .value("Durchschnitt", SM.avgSteps(steps: healthStorage.Steps) ) )
                        .foregroundStyle(.orange.opacity(0.5))
                }
                
                RuleMark(x: .value("ActiveSteps", SM.activeDateCicle ) )
                    .foregroundStyle(SM.activeisActive ? .white.opacity(1) : .white.opacity(0.2))
                    .offset(dragAmount)
                
                
                if AppConfig().ChartBarIsShowing {
                    ForEach(Array(healthStorage.Steps.enumerated()), id: \.offset) { index, step in
                        BarMark(
                            x: .value("Dates", step.date),
                            y: .value("Steps", (step.count))
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(SM.targetSteps < step.count ? .green.opacity(0.2) : .white.opacity(0))
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
                                
                                if SM.activeDateCicle == step.date {
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
                                    SM.activeDateCicle = dateCurrent //(dateStart, dateCurrent)
                                    withAnimation(.easeIn(duration: 0.2)){
                                        SM.activeisActive = true
                                    }
                                }
                                updateSelectedStep(at: CGPoint(x: value.location.x, y: value.location.y) , proxy: proxy, geometry: geometry)
                            }.onEnded { value in
                                withAnimation(.easeOut(duration: 0.2)){
                                    SM.activeisActive = false
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
            .chartYScale(range: .plotDimension(padding: 10))
            .chartXScale(range: .plotDimension(padding: 15))
            Text("").id(StepCounterbottomID)
        }
        .frame(height: screenSize.height - 50)
        .frame(maxWidth: .infinity)
    }
    
    // MARK: Step Circle VB
    @ViewBuilder
    func StepCircle(Double: Double) -> some View {
        ring(color: .blue, trim: Double, stroke: 5, delay: 1, image: "prothesis")
            .frame(maxHeight: .infinity)
            .animation(.easeIn(duration: 1), value: SM.drawingRingStroke)
    }
    
    // MARK: CIRCLES VB
    @ViewBuilder
    func ring(color: Color, trim: Double, stroke: Double, delay: Double, image: String?) -> some View {
        // Background ring
        ZStack {
            Image("prothesis")
                .imageScale(.large)
                .font(Font.system(size: 35, weight: .regular))
                .frame(width: 50, height: 50)
            
            Circle()
                .stroke(style: StrokeStyle(lineWidth: stroke))
                .foregroundStyle(.tertiary)
                .overlay {
                    // Foreground ring
                    Circle()
                        .trim(from: 0, to: SM.drawingRingStroke ? trim : 0 )
                        .stroke(SM.angleGradient, style: StrokeStyle(lineWidth: stroke, lineCap: .round))
                }
                .rotationEffect(.degrees(-90))
        }
        
    }
}
