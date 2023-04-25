//
//  StepCounter.swift
//  Pro Prothese
//
//  Created by Frederik Kohler on 23.04.23.
//

import SwiftUI
import Charts

struct StepCounter: View {
    @EnvironmentObject var healthStorage: HealthStorage
    @EnvironmentObject var stepCounterManager: StepCounterManager
    @AppStorage("Days") var fetchDays:Int = 7
    
    @Namespace private var MoodAnimationCounter
    @Namespace var bottomID
    
    func dateMin(_ value: Int) -> Date {
        let dateMin = Calendar.current.date(byAdding: .day, value: -value, to: Date())!
        return dateMin
    }
    
    func dateMax(_ value: Int) -> Date {
        let dateMin = Calendar.current.date(byAdding: .day, value: +value, to: Date())!
        return dateMin
    }
    
    @State private var dragAmount = CGSize.zero

    var body: some View {
        VStack{
            GeometryReader { proxy in
             
                VStack{
                    VStack{
                        Spacer()
                        // MARK: Step Circle
                        StepCircle(Double: stepCounterManager.dez(Int: stepCounterManager.activeStepCount))
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
                                
                                Text("⌀ Schritte \(healthStorage.fetchDays)")
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
                    
                    
                    // MARK: CHART
                    if(healthStorage.fetchDays == 7){
                        StepChartNoScrolling()
                    } else {
                        StepChartScrolling(days: healthStorage.fetchDays)
                    }
                    
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
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
    
    
    @ViewBuilder
    func StepChartNoScrolling() -> some View{
        HStack {
            Chart() {
                RuleMark(y: .value("Durchschnitt", stepCounterManager.avgSteps(steps: healthStorage.Steps) ) )
                    .foregroundStyle(.orange.opacity(0.5))
                
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
                        .foregroundStyle(by: .value("distance", "Distanz"))
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
            /*.chartForegroundStyleScale([
                    "Schritte": Color.white,
                    "Distanz": Color.red,
                    "Durschnitt": Color.orange
                ])*/
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    ZStack(alignment: .top) {
                        Rectangle().fill(.clear).contentShape(Rectangle())
                            .onTapGesture { location in
                                updateSelectedStep(at: location, proxy: proxy, geometry: geometry)
                            }
                            .gesture(DragGesture()
                                    .onChanged { value in
                                      // find start and end positions of the drag
                                      let start = geometry[proxy.plotAreaFrame].origin.x
                                      let xStart = value.startLocation.x - start
                                      let xCurrent = value.location.x - start
                                      // map those positions to X-axis values in the chart
                                      if let dateStart: Date = proxy.value(atX: xStart),
                                         let dateCurrent: Date = proxy.value(atX: xCurrent) {
                                          stepCounterManager.activeDateCicle = dateCurrent //(dateStart, dateCurrent)
                                          //dragAmount = CGSize(width: value.location.x, height: start)
                                          withAnimation(.easeIn(duration: 0.2)){
                                              stepCounterManager.activeisActive = true
                                          }
                                      }
                                        
                                        updateSelectedStep(at: CGPoint(x: value.location.x, y: value.location.y) , proxy: proxy, geometry: geometry)
                                    }
                                    .onEnded { value in
                                        withAnimation(.easeOut(duration: 0.2)){
                                            stepCounterManager.activeisActive = false
                                           // dragAmount = .zero
                                        }
                                        updateSelectedStep(at: value.predictedEndLocation, proxy: proxy, geometry: geometry)
                                    })
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
            Text("").id(bottomID)
        }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .padding(.bottom)
    }
    
    @ViewBuilder
    func StepChartScrolling(days: Int) -> some View{
        ScrollViewReader { value in
            ScrollView(.horizontal, showsIndicators: false){
                HStack {
                    Chart() {
                        RuleMark(y: .value("Durchschnitt", stepCounterManager.avgSteps(steps: healthStorage.Steps) ) )
                            .foregroundStyle(.orange.opacity(0.5))
                        
                        if AppConfig().ChartBarIsShowing {
                            ForEach(Array(healthStorage.Steps.enumerated()), id: \.offset) { index, step in
                                BarMark(
                                    x: .value("Dates", step.date),
                                    y: .value("Steps", (step.count))
                                )
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(stepCounterManager.targetSteps < step.count ? .green.opacity(0.2) : .white.opacity(0))
                                .foregroundStyle(by: .value("distance", "Distanz"))
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
                                .foregroundStyle(by: .value("step", "Schritte"))
                            }
                        }

                    }
                    .frame(width: stepCounterManager.calcChartItemSize())
                   /* .chartForegroundStyleScale([
                            "Schritte": Color.white,
                            "Distanz": Color.red,
                            "Durschnitt": Color.orange
                        ])*/
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
                    .chartXScale(range: .plotDimension(padding: 30))
                    Text("").id(bottomID)
                }
                
            }
            .onChange(of: fetchDays){ new in
                withAnimation(.easeIn(duration: 0.8)){
                    value.scrollTo(bottomID)
                }
            }
            .onAppear{
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2){
                    withAnimation(.easeInOut(duration: 1)){
                        value.scrollTo(bottomID)
                    }
                }
            }
       }
        .frame(height: 200)
        .frame(maxWidth: .infinity)
        .padding(.bottom)
    }
    
    @ViewBuilder
    func chooseDayButton(_ day: Int) -> some View {
        HStack{
            Button("\(day) Tage"){
                healthStorage.fetchDays = day
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
    
    @ViewBuilder
    func ring(color: Color, trim: Double, stroke: Double, delay: Double, image: String?) -> some View {
        // Background ring
        ZStack {
            Image(systemName: image ?? "figure.walk", variableValue: 5)
                .opacity(image != nil ? Double(1) : Double(0))
    
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

struct StepCounter_Previews: PreviewProvider {
    static var previews: some View {
        StepCounter()
    }
}
