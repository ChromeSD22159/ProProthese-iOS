//
//  Gangbild.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 15.09.23.
//

import SwiftUI
import Charts

struct StepsTodayDiagram: View {
    @Environment(\.scenePhase) var scenePhase
    
    @EnvironmentObject var themeManager: ThemeManager
    
    @StateObject var healthStore = HealthStoreProvider()
    
    private var currentTheme: Theme {
        return  ThemeManager().currentTheme()
    }
    
    var hightlightColor: Color
    
    @State var stepDataToday: [ChartDataDayCompair] = []
    
    @State var stepDataYesterday: [ChartDataDayCompair] = []
    
    @State var isTimerRunning = false
    
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    @State var positionForNewColor: CGFloat = 0.01
    
    var hour: Int {
        Calendar.current.component(.hour, from: Date())
    }
    
    private var percent: CGFloat {
        guard hour != 0 else {
            //print("[StepsMonthDiagram] First hour of day")
            
            return 0.01
        }
        
        //return calculatePercentage(value: Double(countedData), percentageVal: Double(hour))
        return newCalculatePercentage(hour: Calendar.current.component(.hour, from: Date()))
    }
    
    private var countedData: Int {
        return stepDataToday.count
    }
    
    var todayMax: Double {
        return stepDataToday.map({$0.value}).max() ?? 0
    }
    
    var yesterdayMax: Double {
        return stepDataYesterday.map({$0.value}).max() ?? 0
    }
    
    var yValues: [Double] {
        let maxT = stepDataToday.map({ $0.value }).max() ?? 0
        let maxY = stepDataYesterday.map({ $0.value }).max() ?? 0
        let max = [maxT, maxY].max() ?? 0
        
        return stride(from: 0, to: (max + 1000).rounded(to: 1000, roundingRule: .up) , by: 2000).map { $0 }
    }
    
    var xValues: [Int] {
        return stepDataToday.map { $0.dabeBundle.hour }
    }
    
    var calcChange: Double { // FIXME:
        let change = todayMax - yesterdayMax
        
        if change.isNaN {
            return 0.0
        } else {
            return change / yesterdayMax * 100
        }
    }
    
    var isAnimation: Bool? = nil
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {

            NavigateTo({
                Header(header: LocalizedStringKey("Steps today").localizedstring(), subline: LocalizedStringKey("Steps compared to yesterday.").localizedstring())
            }, {
                WorkOutEntryView()
            }, from: .home)
            
            ChartView()
            
            LabelRow()
            
        }
        .homeScrollCardStyle(currentTheme: currentTheme)
        .onAppear{
            resetData()
            extractDayInHours()
        }
        .onDisappear {
            resetData()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                resetData()
                extractDayInHours()
            }
        }
        .onReceive(timer) { _ in
            if self.isTimerRunning {
                
                guard positionForNewColor <= CGFloat(percent) else {
                    self.isTimerRunning.toggle()
                    self.positionForNewColor = percent
                    return
                }
                
                positionForNewColor += 0.02
            }
        }
    }
    
    @ViewBuilder func Header(header: String, subline: String) -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text(header)
                    .font(.body.bold())
                    .foregroundColor(currentTheme.text)
                
                HStack {
                    Text(subline)
                        .font(.caption2)
                        .foregroundColor(currentTheme.text)
                    
                    Spacer()
                    
                    ChangeString()
                }
                
                Spacer()
                
                
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 6) {
                
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundColor(currentTheme.text)
            }
        }
    }
    
    @ViewBuilder func ChartView() -> some View {
        Chart() { // TODAY
            
            ForEach(stepDataYesterday.sorted(by: { $0.dabeBundle.hour > $1.dabeBundle.hour }), id: \.id) { hour in
                LineMark(
                    x: .value("Hour", hour.dabeBundle.hour ),
                    y: .value("Steps", hour.value),
                    series: .value("Yesterday", "Yesterday")
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(currentTheme.textGray.opacity(0.5))
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5,5]))
            }
            
            ForEach(stepDataToday.sorted(by: { $0.dabeBundle.hour > $1.dabeBundle.hour }), id: \.id) { hour in
                
                AreaMark(
                    x: .value("Hour", hour.dabeBundle.hour ),
                    y: .value("Steps", hour.value),
                    series: .value("Today", "Today")
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(
                    .linearGradient(
                        colors: [ // currentTheme.hightlightColor
                            .clear.opacity(0.5),
                            .clear.opacity(0.1),
                            .clear.opacity(0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom)
                )
                
                LineMark(
                    x: .value("Hour", hour.dabeBundle.hour ),
                    y: .value("Steps", hour.value),
                    series: .value("T", "T")
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(
                    .linearGradient(
                        Gradient(
                            stops: [
                                .init(color: currentTheme.hightlightColor, location: 0),
                                .init(color: currentTheme.hightlightColor, location: min(max(0.001, percent + 0.001), 0.98)),
                                .init(color: .gray.opacity(0.0), location: min(max(0.001, percent + 0.001), 0.99)),
                                .init(color: .gray.opacity(0.0), location: 1),
                            ]),
                        startPoint: .leading,
                        endPoint: .trailing)
                )
                .lineStyle(.init(lineWidth: 3))
                .symbol {

                    if Calendar.current.component(.hour, from: Date()) == hour.dabeBundle.hour  {
                        AnimatedCircle(size: 12, color: currentTheme.hightlightColor)
                    }
                    
                }
            }
        }
        .chartYAxis(.hidden)
        .chartYScale(range: .plotDimension(padding: 10))
        .chartXScale(range: .plotDimension(padding: 20))
        .chartXAxis {
              AxisMarks(preset: .aligned, position: .bottom, values: xValues) { string in
                  AxisValueLabel() {
                      if let s = string.as(Int.self) {
                          
                          let currentHour = Calendar.current.component(.hour, from: Date())
                          
                          Text("\(s == 24 ? 0 : s)")
                              .font(.system(size: 6))
                              .fontWeight(s == currentHour ? .bold : .regular)
                              .foregroundColor(s == currentHour ? currentTheme.text : currentTheme.textGray)
                              .opacity(s == 0 || s == 3 || s == 6 || s == 9 || s == 12 || s == 15 || s == 18 || s == 21 || s == 24 || s == currentHour ? 1 : 0)
                      }
                  }
              }
          }
    }
    
    @ViewBuilder func ChangeString() -> some View {
        if calcChange == 0.0 || calcChange.isNaN {
            Text("No change from the previous day!")
                .font(.system(size: 8, weight: .bold))
                .foregroundStyle(currentTheme.textGray)
        } else {
            
            if calcChange.sign == .minus {
                Text("\( calcChange.round(decimal: 0) )% less than the day before!")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(.red)
            } else {
                Text("\( calcChange.round(decimal: 0) )% more than the day before!")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(.green)
            }
            
            
        }
    }
    
    @ViewBuilder func LabelRow() -> some View {
        HStack(spacing: 20) {
            Spacer()

            HStack{
                Text("- -")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(currentTheme.textGray)
                
                Text("\(yesterdayMax.seperator) steps yesterday")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(currentTheme.textGray)
            }
            
            HStack{
                Text("- -")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(hightlightColor)
                
                Text("\(todayMax.seperator) steps today")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(hightlightColor)
            }

            Spacer()
        }
    }
    
    private func extractDayInHours() {
        let today = Calendar.current.date(bySettingHour: 0, minute: 59, second: 59, of: Date())!
        
        let yesterday = Calendar.current.date(bySettingHour: 0, minute: 59, second: 59, of: Calendar.current.date(byAdding: .day, value: -1, to: Date())!)!
        
        for i in 0...24 {
            
            let dateIntervalToday = DateInterval(start: today.startEndOfDay().start, end: Calendar.current.date(byAdding: .hour, value: i, to: today)!)
            
            HealthStoreProvider().readIntervalQuantityType(dateInterval: dateIntervalToday, type: .stepCount, completion: { dataToday in
                DispatchQueue.main.async {
                    
                    if i == 24 {
                        let bundle = dateBundle(date: dateIntervalToday.end, dateName: nil, hour: i)
                        stepDataToday.append(ChartDataDayCompair(dabeBundle: bundle, value: dataToday))
                    } else {
                        let bundle = dateBundle(date: dateIntervalToday.end, dateName: nil, hour: Calendar.current.component(.hour, from: dateIntervalToday.end))
                        stepDataToday.append(ChartDataDayCompair(dabeBundle: bundle, value: dataToday))
                    }
                    
                    
                }
            })

            
            let dateIntervalYesterday = DateInterval(start: yesterday.startEndOfDay().start, end: Calendar.current.date(byAdding: .hour, value: i, to: yesterday)!)
            
            HealthStoreProvider().readIntervalQuantityType(dateInterval: dateIntervalYesterday, type: .stepCount, completion: { dataYesterday in
                DispatchQueue.main.async {
                    
                    if i == 24 {
                        let bundle = dateBundle(date: dateIntervalYesterday.end, dateName: nil, hour: i)
                        stepDataYesterday.append(ChartDataDayCompair(dabeBundle: bundle, value: dataYesterday))
                    } else {
                        let bundle = dateBundle(date: dateIntervalYesterday.end, dateName: nil, hour: Calendar.current.component(.hour, from: dateIntervalYesterday.end))
                        stepDataYesterday.append(ChartDataDayCompair(dabeBundle: bundle, value: dataYesterday))
                    }
                    
                    
                }
            })
        }
        
        guard hour != 0 else {
            return
        }

        if isAnimation ?? false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    isTimerRunning.toggle()
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                positionForNewColor = percent
            }
        }
        
    }
    
    private func resetData() {
        stepDataToday = []
        stepDataYesterday = []
        self.positionForNewColor = 0.01
    }
    
    private func calculatePercentage(value:Double,percentageVal:Double) -> CGFloat {
        return CGFloat(1.0 / value * percentageVal)
    }
    
    func newCalculatePercentage(hour: Int) -> Double {
       guard hour >= 0 else { return 0.0 }
       
       guard hour <= 24 else { return 1.0 }
       
       // Convert the hour to a percentage between 0.0 and 1.0
       let percentage = Double(hour) / 24.0
       return percentage
   }
}

struct StepsMonthDiagram: View {
    @Environment(\.scenePhase) var scenePhase
    
    @EnvironmentObject var themeManager: ThemeManager
    
    @StateObject var healthStore = HealthStoreProvider()
    
    private var currentTheme: Theme {
        return  ThemeManager().currentTheme()
    }
    
    var hightlightColor: Color
    
    @State var stepDataThisMonth: [ChartDataMonthCompair] = []
    
    @State var stepDataLastMonth: [ChartDataMonthCompair] = []
    
    @State var isTimerRunning = false
    
    @State var highestCountLastMonth: Double = 0
    
    let timer = Timer.publish(every: 0.01, on: .main, in: .common).autoconnect()
    
    @State var positionForNewColor: CGFloat = 0.01
    
    var today: Int {
        let today = Date().startEndOfDay().end
        return Calendar.current.component(.day, from: today)
    }
    
    private var percent: CGFloat {
        guard self.today != 1 else {
            return 0.01
        }
        
        return calculatePercentage(value: Double(self.countMaxDays.count - 1), percentageVal: Double(self.today - 1))
    }
    
    var thisMonthAvg: Double {
        let steps = stepDataThisMonth.map({$0.value}).max() ?? 0
        
        let count = stepDataThisMonth.map({
            $0.date < Date().startEndOfDay().end
        }).count
        
        guard Int(steps) + count != 0 else {
            return 0.0
        }
        
        return Double(Int(steps) / count)
    }
    
    var lastMonthAvg: Double {
        let steps = stepDataLastMonth.map({$0.value}).max() ?? 0
        let count = stepDataLastMonth.map({$0.value}).count
        
        guard Int(steps) + count != 0 else {
            return 0.0
        }
        
        return Double(Int(steps) / count)
    }
    
    var countMaxDays: [Date] {
        let th = stepDataThisMonth.map({ $0.date })
        let lm = stepDataLastMonth.map({ $0.date })
        return th.count > lm.count ? th : lm
    }
    
    var maxSteps: Double {
        let maxT = stepDataThisMonth.map({ $0.value }).max() ?? 0
        let maxY = stepDataLastMonth.map({ $0.value }).max() ?? 0
        return [maxT, maxY].max() ?? 0
    }
    
    var yValues: [Double] {
        return stride(from: 0, to: (maxSteps + maxSteps / 10).rounded(to: 10000, roundingRule: .up) , by: 50000).map { $0 }
    }
    
    var xValues: [Date] {
        return countMaxDays
    }
    
    var isAnimation: Bool? = nil
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
             
            NavigateTo({
                Header(header: LocalizedStringKey("Steps this month").localizedstring(), subline: LocalizedStringKey("Steps compared to the previous month.").localizedstring())
            }, {
                WorkOutEntryView()
            }, from: .home)

            ChartView()
            
            LabelRow()
            
        }
        .homeScrollCardStyle(currentTheme: currentTheme)
        .onAppear{
            resetData()
            extractMonths()
        }
        .onDisappear {
            resetData()
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                resetData()
                extractMonths()
            }
        }
        .onReceive(timer) { _ in
            if self.isTimerRunning {
                
                guard positionForNewColor <= CGFloat(percent) else {
                    self.isTimerRunning.toggle()
                    self.positionForNewColor = percent
                    return
                }
                
                positionForNewColor += 0.02
            }
        }
        
    }
    
    @ViewBuilder func Header(header: String, subline: String) -> some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text(header)
                    .font(.body.bold())
                    .foregroundColor(currentTheme.text)
                
                Text(subline)
                    .font(.caption2)
                    .foregroundColor(currentTheme.text)
            }
            
            Spacer()
            
            VStack(alignment: .leading, spacing: 6) {
                
                Image(systemName: "chevron.right")
                    .font(.caption2)
                    .foregroundColor(currentTheme.text)
                
            }
        }
    }
    
    @ViewBuilder func ChartView() -> some View {
        Chart() {
            
            ForEach(countMaxDays.sorted(by: { $0 > $1 }), id: \.self) { date in
                let day = Calendar.current.component(.day, from: date) // 25 -> from month
                
                let stepsOfDay = stepDataLastMonth.first(where: { thisMonth in
                    day == Calendar.current.component(.day, from: thisMonth.date)
                })?.value ?? highestCountLastMonth
                
                LineMark(
                    x: .value("Day", date),
                    y: .value("Steps", stepsOfDay),
                    series: .value("Last Month", "Last Month")
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(currentTheme.textGray.opacity(0.5))
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5,5]))
            }
            
            ForEach(countMaxDays.sorted(by: { $0 > $1 }), id: \.self) { date in
                
                let day = Calendar.current.component(.day, from: date) // 25 -> from month
                
                let stepsOfDay = stepDataThisMonth.first(where: { thisMonth in
                    day == Calendar.current.component(.day, from: thisMonth.date)
                })?.value ?? 0
                
                AreaMark(
                    x: .value("Day", date),
                    y: .value("Steps", stepsOfDay),
                    series: .value("This Month", "This Month")
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(
                    .linearGradient(
                        colors: [ // currentTheme.hightlightColor
                            .clear.opacity(0.5),
                            .clear.opacity(0.1),
                            .clear.opacity(0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom)
                )
                
                LineMark(
                    x: .value("Day", date),
                    y: .value("Steps", stepsOfDay),
                    series: .value("This Month", "This Month")
                )
                .interpolationMethod(.catmullRom)
                .foregroundStyle(
                    .linearGradient(
                        Gradient(
                            stops: [
                                .init(color: currentTheme.hightlightColor, location: 0),
                                .init(color: currentTheme.hightlightColor, location: min(max(0.001, percent + 0.001), 0.98)),
                                .init(color: .gray.opacity(0.0), location: min(max(0.001, percent + 0.001), 0.99)),
                                .init(color: .gray.opacity(0.0), location: 1),
                            ]),
                        startPoint: .leading,
                        endPoint: .trailing)
                )
                .foregroundStyle(currentTheme.hightlightColor.opacity(0.5))
                .lineStyle(.init(lineWidth: 3))
                .symbol {
                    if day == today {
                        AnimatedCircle(size: 12, color: currentTheme.hightlightColor)
                    }
                }
            }
        }
        .chartYAxis(.hidden)
        .chartYScale(range: .plotDimension(padding: 10))
        .chartYAxis {
            AxisMarks(position: .leading, values: yValues) { axis in
                AxisValueLabel() {
                    if let axis = axis.as(Double.self) {
                        Text("\( Int(axis) )")
                            .font(.system(size: 8))
                            .foregroundColor(.white)
                    }
                }
            }
        }
        .chartXScale(range: .plotDimension(padding: 20))
        .chartXAxis {
            AxisMarks(preset: .aligned, position: .bottom, values: xValues) { date in
                AxisValueLabel() {
                    if let d = date.as(Date.self) {
                        let currentDay = Calendar.current.component(.day, from: Date().startEndOfDay().end)
                        let day = Calendar.current.component(.day, from: d)
                        
                        Text("\(day)")
                            .font(.system(size: 6))
                            .fontWeight(day == currentDay ? .bold : .regular)
                            .foregroundColor(day == currentDay ? currentTheme.text : currentTheme.textGray)
                            .opacity(day == 5 || day == 10 || day == 15 || day == 20 || day == 25 || day == 30 || day == currentDay ? 1 : 0)
                        
                    }
                }
            }
        }
    }
    
    @ViewBuilder func LabelRow() -> some View {
        HStack(spacing: 20) {
            Spacer()
            
            HStack{
                Text("- -")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(currentTheme.textGray)
                
                //Text("avg " + lastMonthAvg.round(decimal: 0)  + " steps in \(stepDataLastMonth.first?.date.dateFormatte(date: "MMM", time: "").date ?? "")" )
                Text(stepDataLastMonth.first?.date.dateFormatte(date: "MMM yyyy", time: "").date ?? "")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(currentTheme.textGray)
            }
            
            HStack{
                Text("- -")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(hightlightColor)
                
                Text(stepDataThisMonth.first?.date.dateFormatte(date: "MMM yyyy", time: "").date ?? "")
                    .font(.system(size: 8, weight: .bold))
                    .foregroundStyle(hightlightColor)
            }
            
            Spacer()
        }
    }
    
    private func extractMonths() {
        
        /// get current month
        let firstOfThisMonth = getfirstDayOfMonth(int: 0)
        let thisMonth = firstOfThisMonth.getAllDatesdeomMonth().compactMap{ date -> Date in
            return date
        }
        
        let firstOfLastMonth = getfirstDayOfMonth(int: -1)
        let lastMonth = firstOfLastMonth.getAllDatesdeomMonth().compactMap{ date -> Date in
            return date
        }
        
        for day in thisMonth {
            let d = day.startEndOfDay()
            let dateInterval = DateInterval(start: firstOfThisMonth.startEndOfDay().start, end: d.end)
            
            HealthStoreProvider().readIntervalQuantityType(dateInterval: dateInterval, type: .stepCount, completion: { data in
                DispatchQueue.main.async {
                    stepDataThisMonth.append(ChartDataMonthCompair(date: d.end, value: data))
                }
            })
        }
        
        for day in lastMonth {
            let d = day.startEndOfDay()
            let dateInterval = DateInterval(start: firstOfLastMonth.startEndOfDay().start, end: d.end)
            
            HealthStoreProvider().readIntervalQuantityType(dateInterval: dateInterval, type: .stepCount, completion: { data in
                DispatchQueue.main.async {
                    stepDataLastMonth.append(ChartDataMonthCompair(date: d.end, value: data))
                    
                    guard data > highestCountLastMonth else {
                        return
                    }
                    
                    highestCountLastMonth = data
                }
            })
        }

        guard self.today != 1 else {
            return
        }
        
        if isAnimation ?? false {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.easeInOut(duration: 1.0)) {
                    isTimerRunning.toggle()
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                positionForNewColor = percent
            }
        }
    }
    
    private func getfirstDayOfMonth(int: Int) -> Date {
        let calendar = Calendar.current
        
        guard let currentMonth = calendar.date(byAdding: .month, value: int, to: Date()) else {
            return Date()
        }
        
        return calendar.date(from: Calendar.current.dateComponents([.year, .month], from: currentMonth))!
    }
    
    private func resetData() {
        stepDataThisMonth = []
        stepDataLastMonth = []
        self.positionForNewColor = 0.001
    }
    
    private func calculatePercentage(value:Double,percentageVal:Double) -> CGFloat {
        return CGFloat(1.0 / value * percentageVal)
    }
}




// MODEL
struct ChartDataDayCompair {
    var id = UUID()
    var dabeBundle: dateBundle
    var value: Double
}

struct ChartDataMonthCompair {
    var id = UUID()
    var date: Date
    var value: Double
}

struct dateBundle {
    var date: Date
    var dateName: String? = nil
    var hour: Int
}
