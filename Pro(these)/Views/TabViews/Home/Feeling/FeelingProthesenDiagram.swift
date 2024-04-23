//
//  FeelingProthesenDiagram.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 08.08.23.
//

import SwiftUI
import Charts

struct FeelingProthesenDiagram: View {
    @FetchRequest var feelingRequest: FetchedResults<Feeling>
    
    @EnvironmentObject var themeManager: ThemeManager
    
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    
    var dates: [(id: UUID, date: Date)] {
        let dates = Date().extractLastDays(7)
        return dates.sorted(by: { $0.date > $1.date })
    }
    
    var feelings: [(prothese: String, data: [(id: UUID, value: Int, date: Date)])] {
        
        let dic = Dictionary(grouping: self.feelingRequest, by: { (item) -> String in
            if let prothese = item.prothese {
                return prothese.prosthesisKind.localizedstring()
            } else {
                return "nil"
            }
        }).mapValues({ (feelings) in
            
            Dictionary(grouping: feelings, by: { (item) -> DateComponents in
                let date = Calendar.current.dateComponents([.year, .month, .day], from: (item.date!))
                return date
            }).map({ (date, value) in
                let newDate = Calendar.current.date(from: date)!
                let count = value.count
                let sum = value.map({
                    return convertAxis(int: Int( ($0.name?.suffix(1))! ) ?? 0)
                }).reduce(0,+)
                
                return (id: UUID(), value: sum / count, date: newDate)
            }).sorted(by: { $0.date > $1.date})
            
        })
        
        let x = dic.map({
            return (prothese: $0.key as String, data: $0.value)
        })//.sorted(by: { $0.prothese > $1.prothese })
        
        return x.filter({ $0.prothese != "nil" }).sorted(by: { $0.prothese > $1.prothese })
    }
    
    var cleanedFeelings: [(prothese: String, data: [(id: UUID, value: Int, date: Date)])] {

        //var new: [(prothese: String, data: [(id: UUID, value: Int, date: Date)])]
        
        let cleaned = self.feelings.map { prothese in
            
            var count = 0
            
            let newData = dates.map({ week in
                let res = prothese.data.filter({ feeling in
                    Calendar.current.isDate(feeling.date, inSameDayAs: week.date)
                })
                
                if res.first?.value ?? 0 > 0 {
                    count = res.first!.value
                }
                
                return (id: week.id, value: res.first?.value ?? 0 == 0 ? count : res.first?.value ?? 0, date: week.date)
            })

            return (prothese: prothese.prothese, data: newData)
        }
        
        return cleaned
    }
    
    init() {
        let date = Date()
        let startDate = Calendar.current.date(byAdding: .day, value: -6, to: date)!.startEndOfDay().start
        let endDate = Date()
        _feelingRequest = FetchRequest<Feeling>(sortDescriptors: [], predicate: NSPredicate(format: "(date >= %@) AND (date <= %@)", startDate as CVarArg, endDate as CVarArg))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Prostheses Mood Chart")
                    .font(.body.bold())
                    .multilineTextAlignment(.leading)
                    .foregroundColor(currentTheme.text)
                
                Text("Your mood progression in the prosthesis comparison.")
                    .font(.caption2)
                    .foregroundColor(currentTheme.text)
            }
            
            ZStack {
                CHART(blur: feelings.count == 0 ? 2 : 0)
   
                if feelings.count == 0 {
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Text("You have not yet added any moods to your prostheses")
                                .font(.footnote.bold())
                            Spacer()
                        }
                        Spacer()
                    }
                }
                
            }
        }
        .homeScrollCardStyle(currentTheme: currentTheme)
    }
    
    @ViewBuilder func SmileChart(blur: CGFloat) -> some View {
        VStack(spacing: 6) {
            ForEach(1..<6) { num in
                
                Image("feeling_\(num)")
                    .resizable()
                    .foregroundColor(currentTheme.hightlightColor.opacity(Double(convertAxis(int: num)) * 2 / 10))
                    .frame(width: 20, height: 20)
            }
        }
        .padding(.bottom, 20)
        .opacity(feelings.count == 0 ? 0.5 : 1)
        .blur(radius: blur)
        
        Spacer()
    }
    
    func CHART(blur: CGFloat) -> some View {
        Chart() {
            RuleMark( x: .value("Today", Date()) )
                .lineStyle(StrokeStyle(lineWidth: 1, dash: [5]))
                .foregroundStyle(currentTheme.textGray.opacity(0.5))
            
            ForEach(cleanedFeelings, id: \.prothese) { prothese in
                
                ForEach(prothese.data, id: \.id) { data in
                    /*
                     let res = prothese.data.filter({ feeling in
                         Calendar.current.isDate(feeling.date, inSameDayAs: week.date)
                     })
                     */
                    
                    
                    LineMark(
                        x: .value("Date", data.date),
                        y: .value("Feeling", data.value )
                    )
                    .interpolationMethod(.catmullRom)
                    .lineStyle(.init(lineWidth: 3))
                }
                .foregroundStyle(by: .value("Prothese", prothese.prothese))
            }
        }
        .chartYScale(range: .plotDimension(padding: 10))
        .chartXScale(range: .plotDimension(padding: 20))
        .chartYAxis {
            
            let values = Array(stride(from: 0, to: 6, by: 1.0))
            
            AxisMarks(position: .leading, values: values) { axis in

                AxisValueLabel() {
                    if let axis = axis.as(Double.self) {
                        if axis > 0 {
                            Image("feeling_\(convertAxis(int: Int(axis)))").font(.system(size: 16))
                                .foregroundColor(currentTheme.hightlightColor.opacity(Double(Int(axis)) * 2 / 10))
                        } else {
                            Image(systemName: "circle.slash").font(.system(size: 16))
                                .foregroundColor(currentTheme.textGray.opacity(0.5))
                        }
                    }
                }
            }
        }
        .chartXAxis {
            AxisMarks(position: .bottom, values: .stride(by: .day, count: 7)) { date in
                AxisValueLabel() {
                    if let d = date.as(Date.self) {
                        Text(d.dateFormatte(date: "EEE", time: "").date)
                    }
                }
            }
        }
        .chartXAxis(.hidden)
        .opacity(feelings.count == 0 ? 0.1 : 1)
        .blur(radius: blur)
        .frame(minHeight: 200)
    }
    
    private func convertAxis(int: Int) -> Int {
        switch int {
            case 5: return 1
            case 4: return 2
            case 3: return 3
            case 2: return 4
            case 1: return 5
        default:
            return 1
        }
    }
}
