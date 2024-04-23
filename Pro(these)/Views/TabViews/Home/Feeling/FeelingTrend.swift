//
//  FeelingTrend.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 31.07.23.
//

import SwiftUI

struct FeelingTrend: View {
    
    @FetchRequest var feelingRequestThis: FetchedResults<Feeling>
   
    @FetchRequest var feelingRequestLast: FetchedResults<Feeling>
    
    @EnvironmentObject var themeManager: ThemeManager
    
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    
    var avgFeelingsThisWeek: Double {
        
        let dict = Dictionary(grouping: self.feelingRequestThis, by: { (item) -> DateComponents in
            let date = Calendar.current.dateComponents([.year, .month, .day], from: (item.date!))
            return date
        }).map({ (date, value) in
            let newDate = Calendar.current.date(from: date)!
            let count = Double(value.count)
            let sum = value.map({
                return Double(convertAxis(int: Int( ($0.name?.suffix(1))! ) ?? 0))
            }).reduce(0,+)
            
            return (id: UUID(), value: sum / count, date: newDate)
        })
        
        return Double(dict.map({ $0.value }).reduce(0,+) / Double(dict.map({ $0.value }).count))
    }
    
    // FIXME: - BRAUCHT ES DAS?
    var avgFeelingsLastWeek: Double {
        
        let dict = Dictionary(grouping: self.feelingRequestLast, by: { (item) -> DateComponents in
            let date = Calendar.current.dateComponents([.year, .month, .day], from: (item.date!))
            return date
        }).map({ (date, value) in
            let newDate = Calendar.current.date(from: date)!
            let count = Double(value.count)
            let sum = value.map({
                return Double(convertAxis(int: Int( ($0.name?.suffix(1))! ) ?? 0))
            }).reduce(0,+)
            
            return (id: UUID(), value: sum / count, date: newDate)
        })
        
        return Double(dict.map({ $0.value }).reduce(0,+) / Double(dict.map({ $0.value }).count))
    }

    var percentWidth: CGFloat {
        let screen = Double(self.screenWidth)

        // percent diffenrece, if more them 100 / 100
        let percent = abs(self.percent.difference) > 100 ? abs(self.percent.difference) / 10 : abs(self.percent.difference)
        
        let newScreen = screen / 100 * (percent / 2)
        
        let halfScreen = screen / 2
        
        return self.percent.sign == "-" ? (halfScreen - newScreen) : (halfScreen + newScreen)
    }
    
    @State var animationWidth: CGFloat = 0
    
    var percent: (sign: String, last: Double, current: Double, difference: Double) {
        let max: Double = 5
        let percent: Double = 100
        let currentPeriode = self.avgFeelingsLastWeek.isNaN ? 0 : self.avgFeelingsLastWeek
        let lastPeriode = self.avgFeelingsThisWeek.isNaN ? 0 : self.avgFeelingsThisWeek
        
        guard currentPeriode + lastPeriode != 0 else {
           return (sign: "" , last: 0, current: 0, difference: 0)
        }
        
        let calcThisPeriode = percent / max * currentPeriode
        let calcLastPeriode = percent / max * lastPeriode
        let difference = calcLastPeriode - calcThisPeriode
        
        return (sign: difference.sign == .minus ? "-" : "+" , last: calcLastPeriode, current: calcThisPeriode, difference: abs(difference))
    }
    
    var trendTyp: trendTyp
    
    init(trendTyp: trendTyp) {
        
        self.trendTyp = trendTyp
        
        if trendTyp.rawValue == "Week" {
            let date = Date()
            let startThisWeek = Calendar.current.date(byAdding: .day, value: -6, to: date)!.startEndOfDay().start
            let endThisWeek = Date()
            
            let startLastWeek = Calendar.current.date(byAdding: .day, value: -13, to: date)!.startEndOfDay().start
            let endLastWeek = Calendar.current.date(byAdding: .day, value: -6, to: date)!.startEndOfDay().end
            
            _feelingRequestThis = FetchRequest<Feeling>(sortDescriptors: [], predicate: NSPredicate(format: "(date >= %@) AND (date <= %@)", startThisWeek as CVarArg, endThisWeek as CVarArg))
            
            _feelingRequestLast = FetchRequest<Feeling>(sortDescriptors: [], predicate: NSPredicate(format: "(date >= %@) AND (date <= %@)", startLastWeek as CVarArg, endLastWeek as CVarArg))
        } else {
            let date = Date()
            let startThisMonth = Calendar.current.date(byAdding: .day, value: -30, to: date)!.startEndOfDay().start
            
            let startLastMonth = Calendar.current.date(byAdding: .day, value: -60, to: date)!.startEndOfDay().start
            let endLastMonth = Calendar.current.date(byAdding: .day, value: -30, to: date)!.startEndOfDay().end
            
            _feelingRequestThis = FetchRequest<Feeling>(sortDescriptors: [], predicate: NSPredicate(format: "(date >= %@) AND (date <= %@)", startThisMonth as CVarArg, date as CVarArg))
            
            _feelingRequestLast = FetchRequest<Feeling>(sortDescriptors: [], predicate: NSPredicate(format: "(date >= %@) AND (date <= %@)", startLastMonth as CVarArg, endLastMonth as CVarArg))
        }
       
    }
    
    @State var screenWidth:CGFloat = 0
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 6) {
            
            HStack {
                Text(trendTyp.rawValue == "Week" ? LocalizedStringKey("Weekly Mood Trend") : LocalizedStringKey("Montly Mood Trend"))
                    .font(.body.bold())
                    .foregroundColor(currentTheme.text)

                Spacer()
            }
            
            HStack {
                Text(trendTyp.rawValue == "Week" ? LocalizedStringKey("Your mood trend compared to the week before.") : LocalizedStringKey("Your mood trend compared to the month before."))
                    .font(.caption2)
                    .foregroundColor(currentTheme.text)
                    .padding(.bottom, 6)
                
                Spacer()
            }
            
            
                
            ZStack {
                
                Rectangle()
                    .fill(.gray.opacity(0.2))
                    .frame(width: screenWidth)
                    .cornerRadius(10)
                
                HStack {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    currentTheme.hightlightColor.opacity(1),
                                    currentTheme.hightlightColor.opacity(0.6)
                                ],
                                startPoint: .trailing,
                                endPoint: .leading
                            )
                        )
                        .frame(width: animationWidth)
                        .cornerRadius(10)
                    
                    Spacer()
                }
                
                MoodSmilyStack()
                
                PercentStack()
                
            }
            .frame(width: screenWidth, height: 50)
        }
        .background(GeometryReader { gp -> Color in
           DispatchQueue.main.async {
               self.screenWidth = gp.size.width
           }
            return Color.clear
       })
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                withAnimation(.easeInOut) {
                    self.animationWidth = self.percentWidth
                }
           }
        }
        .onDisappear{
            self.animationWidth = 0
        }
    }
    
    @ViewBuilder
    func PercentStack() -> some View {
        HStack {
            Spacer()
            
            Text("\(percent.sign) \( Int(percent.difference) )%")
                .font(.headline.bold())
                .foregroundColor(currentTheme.hightlightColor)
                .blendMode(.difference)
            
            Spacer()
        }
        .padding(.horizontal, 10)
    }
    
    @ViewBuilder
    func MoodSmilyStack() -> some View {
        HStack {
            Image("feeling_1")
                .resizable()
                .foregroundColor(currentTheme.hightlightColor)
                .blendMode(.difference)
                .frame(width: 25, height: 25)
            
            Spacer()
            
            Image("feeling_5")
                .resizable()
                .foregroundColor(currentTheme.hightlightColor)
                .blendMode(.difference)
                .frame(width: 25, height: 25)
        }
        .padding(.horizontal, 10)
    }
    
    func convertAxis(int: Int) -> Int {
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
    
    func percent(width: CGFloat, index: Int ) -> CGFloat {
        return CGFloat(5 / Int(width) * index)
    }
    
    
}

enum trendTyp {
    case week
    case month
    
    var rawValue: String {
        switch self {
        case .week : return "Week"
        case .month: return "Month"
        }
    }
}

struct FeelingTrend_Previews: PreviewProvider {
    static var previews: some View {
        FeelingTrend(trendTyp: trendTyp.week)
    }
}
