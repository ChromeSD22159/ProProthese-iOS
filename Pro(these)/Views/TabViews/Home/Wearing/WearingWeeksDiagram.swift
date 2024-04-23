//
//  WearingWeeksDiagram.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 19.09.23.
//

import SwiftUI
import Charts

struct WearingWeeksDiagram: View {
    @Environment(\.scenePhase) var scenePhase
    
    @EnvironmentObject var themeManager: ThemeManager
    
    @StateObject var healthStore = HealthStoreProvider()
    
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }

    @State var timeData: [WeeklyTimes] = []
    
    var lastWeeksTimes: [WeeklyTimes] {
        return self.timeData.sorted(by: { $0.week.end > $1.week.end })
    }
    
    var maxTime: Double {
        return self.timeData.map({ $0.seconds }).max() ?? 20.000
    }
    
    var scaleMaxTime: Double {
        let weekTarget = AppConfig.shared.targetSteps * 7
        let value = self.maxTime > Double(weekTarget) ? self.maxTime : Double(weekTarget)
        return value
    }
    
    var avgTime: Double {
        guard self.timeData.count != 0 else {
            return 0
        }
        
        let count = self.timeData.count
        let sum = self.timeData.map({ return $0.seconds }).reduce(0,+)
        
        return sum / Double(count)
    }
    
    @State var ruleMarkAvgTime: Double = 0
    
    var weeks: Int
    
    var hightlightColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            HStack{
                VStack(alignment: .leading, spacing: 6) {
                    Text("Wearing times chart")
                        .font(.body.bold())
                        .foregroundColor(currentTheme.text)
                    
                    Text("Progress of wearing times.")
                        .font(.caption2)
                        .foregroundColor(currentTheme.text)
                }
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack{
                        Text("- -")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundStyle(hightlightColor)
  
                        let (h,m,_) = Int(lastWeeksTimes.first?.seconds ?? 0).secondsToHoursMinutesSeconds
                    
                          Text("⌀ \(h):\(m)h")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundStyle(hightlightColor)
                    }
                    
                    HStack{
                        Text("- -")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundStyle(currentTheme.textGray)
                        
                        let (h,m,_) = Int(avgTime).secondsToHoursMinutesSeconds
                        
                        Text("⌀ \(h):\(m)h")
                            .font(.system(size: 8, weight: .bold))
                            .foregroundStyle(currentTheme.textGray)
                    }
                }
            }
            
            HStack(spacing: 10) {
                
                Chart() {
                    
                    RuleMark( y: .value("Weekly Avg Wearing Time", ruleMarkAvgTime) )
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                        .foregroundStyle(currentTheme.textGray)
                    
                    ForEach(lastWeeksTimes.indices, id: \.self) { int in
                        
                        AreaMark(
                            x: .value("Date", lastWeeksTimes[int].week.start),
                            y: .value("Times", lastWeeksTimes[int].seconds)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(
                            .linearGradient(
                                colors: [
                                    currentTheme.hightlightColor.opacity(0.75),
                                    currentTheme.hightlightColor.opacity(0.1),
                                    currentTheme.hightlightColor.opacity(0)
                                ],
                                startPoint: .top,
                                endPoint: .bottom)
                        )
                        
                        let bool = Calendar.current.isDateInThisWeek(lastWeeksTimes[int].week.end)
                        
                        LineMark(
                            x: .value("Date", lastWeeksTimes[int].week.start),
                            y: .value("Times", lastWeeksTimes[int].seconds)
                        )
                        .interpolationMethod(.catmullRom)
                        .foregroundStyle(currentTheme.hightlightColor)
                        .lineStyle(.init(lineWidth: 3))
                        .symbol {
                            if bool {
                                AnimatedCircle(size: 12, color: currentTheme.hightlightColor)
                            } else {
                                ZStack {
                                    Circle()
                                        .fill(.ultraThinMaterial)
                                        .frame(width: 12)
                                    
                                    Circle()
                                        .fill(currentTheme.hightlightColor)
                                        .frame(width: 6)
                                }
                            }
                        }
                    }
                    
                }
                .chartYScale(range: .plotDimension(padding: 10))
                .chartYAxis {
                   
                    let max = (scaleMaxTime / 3600).rounded(to: 10, roundingRule: .up)
                    
                    let values = Array(stride(from: 0, to: max * 3600 , by: 18000))
                    
                    AxisMarks(position: .leading, values: values) { axis in

                        AxisValueLabel() {
                            if let axis = axis.as(Double.self) {
                                
                                let (h,_,_) = Int(axis).secondsToHoursMinutesSeconds
                                
                                Text("\(h)h")
                                    .font(.system(size: 8))
                                    .foregroundColor(avgTime < axis && avgTime > axis ? .gray : .white)
                            }
                        }
                    }
                }
                .chartXScale(range: .plotDimension(padding: 20))
                .chartXAxis {
                    AxisMarks(preset: .aligned, position: .bottom, values: .stride(by: .day, count: 7)) { date in
                        AxisValueLabel() {                            
                            if let d = date.as(Date.self) {
                                let startCurrentWeek = Date().startOfWeek()
                                let sameWeek = Calendar.current.isDate(d, inSameDayAs: startCurrentWeek)
                                Text(d.dateFormatte(date: "dd.MM", time: "").date)
                                    .font(.system(size: 6))
                                    .foregroundColor(sameWeek ? currentTheme.text : currentTheme.textGray)
                                    .fontWeight(sameWeek ? .bold : .regular)
                            }
                        }
                    }
                }
            }
        }
        .homeScrollCardStyle(currentTheme: currentTheme)
        .onAppear{
            resetData()
            loadData()
        }
        .onDisappear {
            resetData()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                resetData()
                loadData()
            }
        }
    }

    var xValues: [Date] {
        let dates = self.timeData.map({ $0.week.start })
        return dates
    }
    
    func getSteps(weeks: Int) {
        for i in 0...weeks {
            let weekRawValue = getWeekStartEnd(int: i)
            let week = DateInterval(start: weekRawValue.start, end: weekRawValue.end)
            
            healthStore.getWorkouts(week: week, workout: .default()) { workouts in
                DispatchQueue.main.async {
                    let totalWorkouts = workouts.data.map({ workout in
                        return Int(workout.value)
                    }).reduce(0, +)
                    
                    self.timeData.append(WeeklyTimes(week: weekRawValue, seconds: Double(totalWorkouts)))
                }
            }
        }
    }
    
    func getWeekStartEnd(int: Int) -> (start: Date, end: Date) {
        let week = Calendar.current.date(byAdding: .weekOfYear, value: -int, to: Date())!
        return week.startEndOfWeek
    }
    
    func resetData() {
        self.timeData = []
        self.ruleMarkAvgTime = 0
    }
    
    func loadData() {
        getSteps(weeks: weeks)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.easeInOut) {
                self.ruleMarkAvgTime = self.avgTime
            }
        }
    }
}

struct WeeklyTimes {
    var week: (start: Date, end: Date)
    var seconds: Double
}

extension FloatingPoint {
    func rounded(to value: Self, roundingRule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> Self {
       (self / value).rounded(roundingRule) * value
    }
}

/*
#Preview { weeks: 8, hightlightColor: .red
    WearingWeeksDiagram()
}
*/
