//
//  StepChart.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 20.05.23.
//

import SwiftUI
import Charts
import Foundation

struct StepChart: View {
    @EnvironmentObject var vm: WorkoutStatisticViewModel
    
    @State private var currentWeek:[Date] = []
    @State private var currentIndex = 7

    var body: some View {
        VStack(spacing: 10) {
            
            ChartSnapView(spacing: 0, trailingSpace: 0, index: $currentIndex, list: vm.CollectionWeeklySteps.sorted { $0.weekNr > $1.weekNr }.reversed(), content: { week in
                GeometryReader { proxy in
                    
                    VStack{
                        let extractedWeek = extractWeekByDate(weekDate: week.data.first?.date ?? Date())
 
                        Chart() {
                            
                            RuleMark(y: .value("Durchschnitt", week.avg ) )
                                .foregroundStyle(.yellow)
                                .lineStyle(StrokeStyle(lineWidth: 0.5, dash: [8]))
                                .annotation(position: .automatic, alignment: .leading, spacing: 10) {
                                    Text("⌀ \(week.avg) Steps")
                                        .font(.caption)
                                        .fontWeight(.semibold)
                                        .foregroundColor(.yellow)
                                }

                            ForEach(extractedWeek, id: \.self) { day in
                                
                                let formDate = Calendar.current.date(byAdding: .hour, value: 12, to: day)!
                                
                                if let wk = week.data.first(where: { return Calendar.current.isDate($0.date, equalTo: day, toGranularity: .day) }) {
                                    AreaMark(
                                        x: .value("Dates", formDate),
                                        y: .value("Steps", wk.value)
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
                                        x: .value("Dates", formDate),
                                        y: .value("Steps", wk.value)
                                    )
                                    .interpolationMethod(.catmullRom)
                                    .symbol {
                                        VStack(spacing: 5){
                                            if Calendar.current.isDate(formDate, inSameDayAs: vm.currentDay) {
                                                Text("\( seperator(wk.value) )").font(.caption2).foregroundColor(.white)
                                            } else {
                                                Text("").font(.caption2)
                                            }
                                            
                                            ZStack{
                                                // only show when date is not in future
                                                if formDate < Date() { // || Calendar.current.isDate(formDate, inSameDayAs: vm.currentDay)
                                                    let (targetReached, _) = vm.checkTargetSteps(steps: wk.value)
                                                    
                                                    Image(systemName: targetReached ? "hand.thumbsup.fill" : "circle.fill")
                                                        .scaleEffect(Calendar.current.isDate(formDate, inSameDayAs: vm.currentDay) && targetReached ? 2.1 : targetReached ? 1.6 : 0.7)
                                                        .foregroundColor(targetReached ? .yellow : .white )
                                                        .shadow(color: .black, radius: 10)
                                                    
                                                    // show wenn selected date is same as item
                                                    if Calendar.current.isDate(formDate, inSameDayAs: vm.currentDay) {
                                                        if !targetReached {
                                                            Circle()
                                                                .fill(targetReached ? .white.opacity(0) : .white.opacity(0.5))
                                                                .frame(width: 20)
                                                                .shadow(radius: 2)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        .offset(y: -10)
                                    }
                                    .foregroundStyle(
                                        .linearGradient(
                                            colors: [
                                                .yellow.opacity(0.5),
                                                .white.opacity(1)
                                            ],
                                            startPoint: .bottom,
                                            endPoint: .top)
                                    )
                                    .lineStyle(.init(lineWidth: 5))
                                    
                                } else {
                                    AreaMark(
                                        x: .value("Dates", formDate),
                                        y: .value("Steps", 0)
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
                                        x: .value("Dates", formDate),
                                        y: .value("Steps", 0)
                                    )
                                    .interpolationMethod(.catmullRom)
                                    /*.symbol {
                                        VStack(spacing: 5){
                                            if Calendar.current.isDate(formDate, inSameDayAs: vm.currentDay) {
                                                Text("\( seperator(0) )").font(.caption2).foregroundColor(.white)
                                            } else {
                                                Text("").font(.caption2)
                                            }
                                            
                                            ZStack{
                                                // only show when date is not in future
                                                if formDate < Date().endOfDay() { // || Calendar.current.isDate(formDate, inSameDayAs: vm.currentDay)
                                                    // show wenn selected date is same as item
                                                    let (targetReached, _) = vm.checkTargetSteps(steps: 0)
                                                    
                                                    Image(systemName: "circle.fill") //  targetReached ? "hand.thumbsup.fill" :
                                                        .scaleEffect(Calendar.current.isDate(formDate, inSameDayAs: vm.currentDay) && targetReached ? 2.1 : targetReached ? 1.6 : 0.7)
                                                        .foregroundColor(targetReached ? .yellow : .white )
                                                        .shadow(color: .black, radius: 10)
                                                    
                                                    if Calendar.current.isDate(formDate, inSameDayAs: vm.currentDay) {
                                                        if !targetReached {
                                                            Circle()
                                                            .fill(targetReached ? .white.opacity(0) : .white.opacity(0.5))
                                                            .frame(width: 20)
                                                            .shadow(radius: 2)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                        .offset(y: -10)
                                    } */ // TESTBUG
                                    .foregroundStyle(
                                        .linearGradient(
                                            colors: [
                                                .yellow.opacity(0.5),
                                                .white.opacity(1)
                                            ],
                                            startPoint: .bottom,
                                            endPoint: .top)
                                    )
                                    .lineStyle(.init(lineWidth: 5))
                                    
                                }
                                
                            }

                        }
                        .chartOverlay { proxy in
                          GeometryReader { geometry in
                            Rectangle().fill(.clear).contentShape(Rectangle())
                              .onTapGesture { location in
                                  let origin = geometry[proxy.plotAreaFrame].origin
                                  let location = CGPoint(
                                      x: location.x - origin.x,
                                      y: location.y - origin.y
                                  )
                                  
                                  let (date, _) = proxy.value(at: location, as: (Date, Double).self)!

                                  withAnimation {
                                      // only update when the date is not in future
                                      if date < Date().endOfDay() || Calendar.current.isDate(date, inSameDayAs: vm.currentDay) {
                                          vm.currentDay = date
                                      }
                                  }
                              }
                              
                           }
                        }
                        .chartXAxis {
                            AxisMarks(values: .automatic(desiredCount: 8))
                        }
                        .chartYAxis {
                            let max = (week.data.map { $0.value }.max() ?? -55555) + 2500
                            
                            let test = Array(stride(from: 0, to: max, by: 2500))
                            
                            AxisMarks(position: .trailing, values: test) { axis in
                                AxisGridLine(centered: true, stroke: StrokeStyle(lineWidth: 0.3, dash: [10]))

                                AxisValueLabel() {
                                    if let axis = axis.as(Int.self) {
                                        Text("\(axis)")
                                            .font(.system(size: 6))
                                    }
                                }
                            }
                        }
                        .chartYScale(range: .plotDimension(padding: 20))
                        .chartXScale(range: .plotDimension(padding: 30))
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        
                    }
                    .frame(height: 200)
                }
            })
            
            
            // Indicator
            HStack {
                let reversedArray:[ChartDataPacked] = vm.CollectionWeeklySteps.sorted(by: { $0.weekNr < $1.weekNr  })
                
                ForEach(vm.CollectionWeeklySteps.indices , id: \.self) { index in
                    VStack(spacing: 6) {
                        ZStack{
                            Text(currentIndex == index ? isThisWeek(date: reversedArray[index].data.first?.date ?? Date()) ? "Diese Woche" : "KW \(reversedArray[index].weekNr)" : "\(reversedArray[index].weekNr)")
                                .font(.caption2)
                        }
                        .padding(.horizontal, currentIndex == index ? 12 : 6)
                        .padding(.vertical, 6)
                        .background(.ultraThinMaterial.opacity(currentIndex == index ? 1 : 0.5))
                        .cornerRadius(20)
                        .animation(.easeInOut,  value: currentIndex == index)
                        .onTapGesture(perform: {
                            currentIndex = index
                        })
                        
                        Circle()
                            .fill(Color.white.opacity(currentIndex == index ? 1 : 0))
                            .frame(width: 2, height: 2)
                            .scaleEffect(currentIndex == index ? 1.4 : 1)
                            .animation(.easeInOut,  value: currentIndex == index)
                            .onTapGesture(perform: {
                                withAnimation(.easeInOut) {
                                    currentIndex = index
                               }
                            })
                    }
                }
            }
        }
        .frame(height: 250, alignment: .top)
    }
    
    func isThisWeek(date: Date) -> Bool {
        Calendar.current.isDate(date, equalTo: Date(), toGranularity: .weekOfYear)
    }
    
    func seperator(_ fv: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0;
        
        return formatter.string(from: NSNumber(value: fv))!
    }
    
    func secondsToHoursMinutesSeconds(_ seconds: Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    func nameDayByDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E" // OR "dd-MM-yyyy"
        var returnValue = ""
        switch dateFormatter.string(from: date) {
            case "Mon": returnValue = "Mo"
            case "Tue": returnValue = "Di"
            case "Wed": returnValue = "Mi"
            case "Thu": returnValue = "Do"
            case "Fri": returnValue = "Fr"
            case "Sat": returnValue = "Sa"
            case "Sun": returnValue = "So"
            default: returnValue = "null"
        }
        
        return returnValue
    }
    
    func getDurationForDateOrReturnZero(arr: [ChartData], currentDate: Date) -> Double {
        let result = arr.filter { entry in Calendar.current.isDate(entry.date, inSameDayAs: currentDate) }
        return  result.count > 0 ? Double(result[0].value) : 0.0
    }
    
    func getDateForDateOrReturnCurrent(arr: [ChartData], currentDate: Date) -> Date {
        let result = arr.filter { entry in Calendar.current.isDate(entry.date, inSameDayAs: currentDate) }
        return  result.count > 0 ? result[0].date : currentDate
    }
    
    func extractWeekByDate(weekDate: Date) -> [Date]{
        let calendar = Calendar.current
        let week = calendar.dateInterval(of: .weekOfMonth, for: weekDate)
        
        var ArrWeek: [Date] = []
        
        guard let firstDay = week?.start else {
            return []
        }

        (0..<7).forEach{ day in
            if let weekDay = calendar.date(byAdding: .day, value: day, to: firstDay) {
                let date = calendar.date(byAdding: .hour, value: 2, to: weekDay)
                ArrWeek.append(date! )
            }
        }
        
        return ArrWeek
    }
}

struct StepChart_Previews: PreviewProvider {
    static var previews: some View {
        StepChart()
    }
}
