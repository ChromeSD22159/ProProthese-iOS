//
//  newStepPreview.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 13.07.23.
//

import SwiftUI
import Charts
//import GoogleMobileAds

struct newStepPreview: View {
    @Environment(\.scenePhase) var scenePhase
    
    @EnvironmentObject var appConfig: AppConfig
    
    @EnvironmentObject var vm: WorkoutStatisticViewModel
    
    @EnvironmentObject var themeManager: ThemeManager
    
    @EnvironmentObject var googleInterstitial: GoogleInterstitialAd
    
    @StateObject var healthStore = HealthStoreProvider()
    
    @State var currentDate: Date = Date()
    
    @State var currentWeek: [DateValue] = []

    @State var StoredCollection: [ChartData] = []
    
    @State var StoredWorkouts: [ChartData] = []
    
    @State var totelStepsThisWeek: Int = 0
    
    @State var stairsCount: Int = 0
    
    @State var totelWearingThisWeek: Int = 0
    
    @State var totelStepDistanceThisWeek: Int = 0

    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    
    private var currentWeekFormatted: String {
        let first = currentWeek.first?.date.dateFormatte(date: "dd.MM", time: "").date ?? ""
        let last = currentWeek.last?.date.dateFormatte(date: "dd.MM.yy", time: "").date ?? ""
        return first + " - " + last
    }
  
    var maxValue: Double {
        let values = self.StoredCollection.map { $0.value }
        return values.max() ?? 0
    }
    
    var daysLeft: Int {
        let values = self.StoredCollection.count
        return 7 - values
    }
    
    @State var avgStepsThisWeek: Int = 0
    
    @State var avgStepsLastWeek: Int = 0
    
    @State private var end = 0.0
    
    @State var week: [DateValue] = []
    
    @State var selectedDate: Date = Date()
    
    @State var sheet = false
    
    @State var calendarSheet = false
    
    @State var CalendarSheetStartDate = Date()
    
    // FIXME: -
    //@State var interstitial: GADInterstitialAd?
    
    @State var loadingState: Bool = false
    
    @Binding var snapsheet: Bool
    
    var body: some View {
        GeometryReader { geo in
            let size = geo.size.width

            ZStack {

                VStack(spacing: 20) {
                    
                    // MARK: - Infomation
                    InfomationCards(size: size, spacing: 12)
                    
                    Spacer()

                    Controls(size: size) // MARK: - Control
                    
                    LineChart()
                    
                    Spacer()
                }
                
                // FIXME: - LOADING SHEET
                if loadingState {
                    LoadingScreen()
                }
            }
            .frame(width: size)
            .blurredSheet(.init(Material.ultraThinMaterial), show: $calendarSheet, onDismiss: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    googleInterstitial.showAd()
                })
            }) {
                calendarSheetBody(binding: $calendarSheet, currentDate: $currentDate)
            }
            .onAppear {
                resetData()
                loadData(week: DateInterval(start: Date().startOfWeek(), end: Date().endOfWeek!))
            }
            .onChange(of: currentDate, perform: { newDate in
                resetData()
                loadData(week: DateInterval(start: newDate.startOfWeek(), end: newDate.endOfWeek!))
            })
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    resetData()
                    loadData(week: DateInterval(start: Date().startOfWeek(), end: Date().endOfWeek!))
                }
            }
            
        }
    }
    
    @ViewBuilder func InfomationCards(size: Double, spacing: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: spacing) {
            
            HStack(spacing: spacing) {
                VStack(spacing: spacing) {
                    HStack {
                        Spacer()
                        Image("figure.steps")
                            .font(.title)
                            .foregroundColor(currentTheme.hightlightColor)
                            .padding(.trailing, 4)
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Text("**\(totelStepsThisWeek)**")
                            .font(size < 400 ? .headline : .title3).fontWeight(.bold)
                        Spacer()
                    }
                }
                .padding()
                .background(.ultraThinMaterial.opacity(0.4))
                .cornerRadius(15)
                
                VStack(spacing: spacing) {
                    HStack {
                        Spacer()
                        Image("distance")
                            .font(.title)
                            .foregroundColor(currentTheme.hightlightColor)
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Text("**\( String(format: "%.1f", Double(totelStepDistanceThisWeek) / 1000) )km**")
                            .font(size < 400 ? .headline : .title3).fontWeight(.bold)
                        Spacer()
                    }
                }
                .padding()
                .background(.ultraThinMaterial.opacity(0.4))
                .cornerRadius(15)
            }
            
            HStack(spacing: spacing) {
                VStack(spacing: spacing) {
                    HStack {
                        Spacer()
                        Image("figure.prothese")
                            .font(.title)
                            .foregroundColor(currentTheme.hightlightColor)
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        let (h,m,_) = totelWearingThisWeek.secondsToHoursMinutesSeconds
                        Text("**\(h):\(m)h**")
                            .font(size < 400 ? .headline : .title3).fontWeight(.bold)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                }
                .padding()
                .background(.ultraThinMaterial.opacity(0.4))
                .cornerRadius(15)
                
                VStack(spacing: spacing) {
                    HStack {
                        Spacer()
                        Image("figure.prothese.stairs")
                            .font(.title)
                            .foregroundColor(currentTheme.hightlightColor)
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Text(LocalizedStringKey("**\(stairsCount) floors**"))
                            .font(size < 400 ? .headline : .title3).fontWeight(.bold)
                        Spacer()
                    }
                }
                .padding()
                .background(.ultraThinMaterial.opacity(0.4))
                .cornerRadius(15)
            }
            
            HStack(spacing: spacing) {
                Spacer()
                
                if calcDiffSteps().string == "mehr" {
                    Text("You walked an average of \(avgStepsThisWeek) steps per day this week. These are \(calcDiffSteps().steps) steps more as last week.")
                        .font(.subheadline)
                        .fixedSize(horizontal: false, vertical: true)
                } else {
                    Text("You walked an average of \(avgStepsThisWeek) steps per day this week. That's  \(calcDiffSteps().steps) fewer steps than last week.")
                        .font(.subheadline)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
            }
            .padding()
            .background(.ultraThinMaterial.opacity(0.4))
            .cornerRadius(15)
 
        }
        .foregroundColor(currentTheme.text)
        .transaction { transaction in
            transaction.animation = nil
        }
        .padding(.horizontal)
        .padding(.top)
    }

    @ViewBuilder func Controls(size: Double) -> some View {
        HStack(spacing: 40) {
            HStack {
                Button(action: {
                    calendarSheet.toggle()
                }, label: {
                    VStack(spacing: 5) {
                        HStack(spacing: 5) {
                            Label("Week: **\(currentWeekFormatted)**", systemImage: "calendar")
                                .font(size < 400 ? .footnote : .body)
                                .foregroundColor(currentTheme.text)
                            
                            Image(systemName: "arrowtriangle.down.fill")
                                .foregroundColor(currentTheme.text)
                                .labelStyle(.iconOnly)
                            
                            Spacer()
                        }
                        .padding(.vertical)
                    }
                })
            }
            
            HStack {
                Button(action: {
                    currentDate = Calendar.current.date(byAdding: .day, value: -7, to: currentDate)!
                    withAnimation(.easeInOut(duration: 2)) {
                        self.end = 1
                    }
                }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(currentTheme.text)
                        .font(.title3)
                        .padding([.vertical,.leading])
                        .padding(.trailing, 5)
                })
                
                Button(action: {
                    let nextWeek = Calendar.current.date(byAdding: .day, value: 7, to: currentDate)!
                    if !Calendar.current.isDateInNextWeek(nextWeek) {
                        currentDate = Calendar.current.date(byAdding: .day, value: 7, to: currentDate)!
                        withAnimation(.easeInOut(duration: 2)) {
                            self.end = 1
                        }
                    }
                   
                }, label: {
                    Image(systemName: "chevron.right")
                        .foregroundColor(!Calendar.current.isDateInNextWeek(Calendar.current.date(byAdding: .day, value: 7, to: currentDate)!) ? currentTheme.text : currentTheme.textGray)
                        .font(.title3)
                        .padding([.vertical,.trailing])
                        .padding(.leading, 5)
                })
            }
        }
        .padding(.horizontal)
        .transaction { transaction in
            transaction.animation = nil
        }
    }
    
    @ViewBuilder func BarChart(size: Double) -> some View {
        VStack {
            ZStack(alignment: .bottom) {
                dashedLine(value: Double(avgStepsThisWeek), color: currentTheme.textGray, text: "AVG")
                    .opacity(appConfig.showAvgStepsOnChartBackground ? 1 : 0)
                
                dashedLine(value: Double(appConfig.targetSteps), color: currentTheme.hightlightColor, text: "target")
                    .opacity(appConfig.showTargetStepsOnChartBackground ? 1 : 0)
                
                HStack(spacing: 0) {
                    ForEach($currentWeek.indices, id: \.self) { int in
                        Pro_these_.dateCapsul(date: currentWeek[int], index: Double(int), weeklySteps: StoredCollection, isShowingSheet: $sheet, avg: avgStepsThisWeek, loadingState: $loadingState)
                            .frame(width: size / 7)
                    }
                }
            }
            .foregroundColor(currentTheme.text)
            .frame(maxWidth: .infinity, maxHeight: 300)
            
            HStack(spacing: 5) {
                Spacer()
                HStack{
                    Text("- -")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(currentTheme.hightlightColor)
                    
                    
                    Text(LocalizedStringKey("\( appConfig.targetSteps ) daily step goal"))
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(currentTheme.hightlightColor)
                }
                
                Spacer()
                Spacer()
                
                HStack{
                    Text("- -")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(currentTheme.textGray)
                                                            
                    Text(LocalizedStringKey("⌀ \( Int(avgStepsThisWeek) ) steps a day this week"))
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(currentTheme.textGray)
                }
                Spacer()
            }
            .padding(.vertical)
        }
    }
    
    @ViewBuilder func LineChart() -> some View {
        VStack(spacing: 20) {
            LineChartCompairWeek(currentDate: $currentDate, snapsheet: $snapsheet, max: 20000)
            
            HStack(spacing: 15) {
                HStack{
                    Text("–")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(currentTheme.textGray)
                                                            
                    Text(LocalizedStringKey("Steps from last week"))
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(currentTheme.textGray)
                }
                
                HStack{
                    Text("–")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(currentTheme.hightlightColor)
                                                            
                    Text(LocalizedStringKey("Steps this week"))
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(currentTheme.hightlightColor)
                }
                
                HStack{
                    Text("- -")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(currentTheme.hightlightColor.opacity(0.2))
                                                            
                    Text(LocalizedStringKey("Your step goal"))
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(currentTheme.hightlightColor.opacity(0.2))
                }
                Spacer()
            }
            .padding(.horizontal)
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder func LoadingScreen() -> some View {
        ZStack {
            currentTheme.textBlack.opacity(0.8)
            
            VStack {
                ProgressView()
                    .scaleEffect(3, anchor: .center)
                    .progressViewStyle(CircularProgressViewStyle(tint: currentTheme.hightlightColor))
            }
        }
    }
    
    func calcDiffSteps() -> (steps: Int, string: String) {
        let calc:Double = Double(self.avgStepsThisWeek -  self.avgStepsLastWeek)
        return (steps: abs(Int(calc)), string: calc.sign == .minus ? "weniger" : "mehr")
    }
    
    func extractWeek() -> [DateValue] {
        var days: [DateValue] = []
        for i in 0...6 {
            days.append(
                DateValue(
                    day: Calendar.current.date(byAdding: .day, value: i, to: self.currentDate.startOfWeek())! > Date() ? -1 : 0,
                    date: Calendar.current.date(byAdding: .day, value: i, to: self.currentDate.startOfWeek())!
                )
            )
        }
        
        return days
    }
    
    func getSteps(week: DateInterval ) {
        // Total Steps
        healthStore.queryWeekCountbyType(week: week, type: .stepCount, completion: { stepCount in
            DispatchQueue.main.async {
                self.StoredCollection = stepCount.data
                self.avgStepsThisWeek = stepCount.avg
                self.totelStepsThisWeek = stepCount.data.map { Int($0.value) }.reduce(0, +)
            }
        })
        
        healthStore.queryStairsByWeek(range: week, completion: { stairs in
            DispatchQueue.main.async {  
                self.stairsCount = Int(stairs)
            }
        })
        
        // Total DistanzesSteps
        healthStore.queryWeekCountbyType(week: week, type: .distanceWalkingRunning, completion: { distanceCount in
            DispatchQueue.main.async {
                self.totelStepDistanceThisWeek = distanceCount.data.map { Int($0.value) }.reduce(0, +)
            }
        })
        
        // Total WearingTimes
        healthStore.getWorkouts(week: week, workout: .default()) { workouts in
            DispatchQueue.main.async {
                let totalWorkouts = workouts.data.map({ workout in
                    return Int(workout.value)
                }).reduce(0, +)
                
                self.totelWearingThisWeek = totalWorkouts
            }
        }

        healthStore.getWorkouts(week: week, workout: .default(), completion: { workouts in
            DispatchQueue.main.async {
                self.StoredWorkouts = workouts.data
            }
        })
        
        // lastweek
        let lastweekDate: Date = Calendar.current.date(byAdding: .day, value: -7, to: week.start)!
        healthStore.queryWeekCountbyType(week: DateInterval(start: lastweekDate.startOfWeek(), end: lastweekDate.endOfWeek!), type: .stepCount, completion: { stepCount in
            DispatchQueue.main.async {
                self.avgStepsLastWeek = stepCount.avg
            }
        })
    }
    
    func resetData() {
        self.StoredCollection = []
        self.avgStepsThisWeek = 0
        self.totelStepsThisWeek = 0
        self.totelStepDistanceThisWeek = 0
        self.totelWearingThisWeek = 0
        self.StoredWorkouts = []
        self.avgStepsLastWeek = 0
        self.stairsCount = 0
    }
    
    func dashedLine(value: Double, color: Color, text: String) -> some View {
        let m = Int(self.maxValue) < appConfig.targetSteps ? Double(appConfig.targetSteps) : self.maxValue
        let calc = (getPercent(input: value, max: m) - 10)
        return VStack(spacing: 10) {
            Spacer()
            
            Line()
               .stroke(style: StrokeStyle(lineWidth: 1, dash: [5]))
               .foregroundColor(color)
               .frame(height: 1)
               .frame(maxWidth: .infinity)
            
            VStack {
               // let _ = print("percentHeight: \(calc)")
            }
            .frame(height: calc > 0 ? calc : 0 )
            
            Text("")
                .font(.caption2)
            
            Text("")
                .font(.caption.bold())
        }
        .animation(
            .interpolatingSpring(
                stiffness: 150,
                damping: 25
            ),
            value: value
        )
    }
    
    private func getPercent(input: Double, max: Double) -> CGFloat {
        return 200 / max * input
    }
    
    func loadData(week: DateInterval) {
        withAnimation( .easeInOut ) {
            currentWeek = extractWeek()
            getSteps(week: week)
        }
    } 
}

struct dateCapsul: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    @EnvironmentObject var googleInterstitial: GoogleInterstitialAd
    
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    
    @StateObject var healthStore = HealthStoreProvider()
    
    private var date: DateValue
    
    private var index: Double
    
    private var avg: Int
    
    private var weeklySteps: [ChartData]
    
    private var maxValue: Double {
        let values = self.weeklySteps.map { $0.value }
        return values.max() ?? 0
    }
    
    @Binding private var isShowingSheet: Bool
    
    @Binding private var loadingState: Bool
    
    @EnvironmentObject var appConfig: AppConfig
    
    @FetchRequest var fetchRequestFeeling: FetchedResults<Feeling>
    
    @FetchRequest var fetchRequestPain: FetchedResults<Pain>
    
    @State var sheet = false
    
    @State var sheetHeight:CGFloat = 150
    
    @State var hourlySteps:[StepsByHour] = []
    
    init(date: DateValue, index: Double, weeklySteps: [ChartData], isShowingSheet: Binding<Bool>, avg: Int, loadingState: Binding<Bool>) {
        self.date = date
        self.index = index
        self.weeklySteps = weeklySteps
        self.avg = avg
        self._isShowingSheet = isShowingSheet
        self._loadingState = loadingState
        _fetchRequestFeeling = FetchRequest<Feeling>(
            sortDescriptors: [],
            predicate: NSPredicate(
                format: "(date >= %@) AND (date <= %@)", self.date.date.startEndOfDay().start as CVarArg,  self.date.date.startEndOfDay().end as CVarArg
            )
        )
        
        _fetchRequestPain = FetchRequest<Pain>(
            sortDescriptors: [],
            predicate: NSPredicate(
                format: "(date >= %@) AND (date <= %@)", self.date.date.startEndOfDay().start as CVarArg,  self.date.date.startEndOfDay().end as CVarArg
            )
        )
    }
    
    func capsulHeight(day: ChartData) -> CGFloat {
        let percent = getPercent(input: day.value, max: Int(self.maxValue) < appConfig.targetSteps ? Double(appConfig.targetSteps) : self.maxValue)
        return percent < 35 ? 35 : percent
    }
    
    var body: some View {

            if let day = weeklySteps.filter({ Calendar.current.isDate(date.date, inSameDayAs: $0.date) }).first {
                VStack(alignment: .center, spacing: 10) {
                    ZStack(alignment: .bottom) {
                        Capsule()
                            .frame(width: 30, height: 250)
                            .foregroundColor(currentTheme.text.opacity(0.1))
                            .padding(5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(sheet ? currentTheme.textGray : .clear, lineWidth: 1)
                            )
                        
                        Capsule()
                            .frame(width: 30, height: capsulHeight(day: day) )
                            .foregroundColor(currentTheme.text)
                            .padding(5)
                            .animation(
                                .interpolatingSpring(
                                    stiffness: 150,
                                    damping: 25
                                )
                                .delay(index/20),
                                value: day.value
                            )
                        
                        VStack(spacing: 6) {
                            if let pain = fetchRequestPain.first {
                                HStack(spacing: 1) {
                                    Image(systemName: "bolt.fill")
                                        .font(.caption2)
                                        .foregroundColor(currentTheme.text)
                                    
                                    Text(String(pain.painIndex))
                                        .font(.footnote.bold())
                                        .foregroundColor(currentTheme.text)
                                }
                                .blendMode(.difference)
                            }
                            
                            if let feeling = fetchRequestFeeling.first {
                                Image("chart_bar_" + feeling.name! )
                                    .resizable()
                                    .scaledToFit()
                                    .clipShape(Circle())
                                    .frame(width: 20, height: 20 )
                            }
                        }
                        .padding(.bottom, 12)
                    }
                    
                    Text( String(format: "%.0f", Double(day.value)) )
                        .font(.caption2)
                    
                    Text(String(day.date.dateFormatte(date: "dd.MM", time: "").date ))
                        .font(.caption.bold())
                }
                .onTapGesture {
                    // FIXME: - LOADING SHEET
                    withAnimation(.easeIn) {
                        loadingState = true
                    }
                    
                    healthStore.readHourlyTotalStepCount(date: day.date) { data in
                        DispatchQueue.main.async {
                            self.hourlySteps = data
                            sheet = true
                            isShowingSheet = true
                            withAnimation(.easeOut) {
                                loadingState = false
                            }
                        }
                    }
                }
                .blurredSheet(
                    .init(.ultraThinMaterial),
                    show: $sheet,
                    onDismiss: {
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            googleInterstitial.showAd()
                        })
                        
                        withAnimation(.easeOut(duration: 0.25)) {
                            isShowingSheet = false
                            sheet = false
                        }
                    }, content: {
                        
                        ZStack(content: {
                            
                            VStack(spacing: 20){
                                HStack{
                                    Text(day.date.dateFormatte(date: "dd.MM.yyyy", time: "").date)
                                        .font(.headline.bold())
                                        .foregroundColor(currentTheme.text)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        withAnimation(.easeOut(duration: 0.25)) {
                                            sheet = false
                                            isShowingSheet = false
                                            
                                            
                                           
                                        }
                                    }, label: {
                                        Image(systemName: "xmark")
                                            .font(.headline.bold())
                                            .foregroundColor(currentTheme.text)
                                    })
                                }
                                .offset(y: -20)
                                
                                dailyStepsSheets(date: day.date, sheetHeight: $sheetHeight, hourlySteps: hourlySteps)
                            }
                            .padding(.horizontal)
                            
                        })
                        .presentationDetents([.height(sheetHeight)])
                        .presentationDragIndicator(.visible)
                        
                    }
                )

            } else {
                VStack(alignment: .center, spacing: 10) {
                    ZStack(alignment: .bottom) {
                        
                        Capsule()
                            .frame(width: 30, height: 250)
                            .foregroundColor(currentTheme.text.opacity(0.1))
                            .padding(5)
                        
                        Capsule()
                            .frame(width: 30, height: 0)
                            .foregroundColor(currentTheme.text)
                            .padding(5)
                    }
                    
                    Text( "0" )
                        .font(.caption2)
                    
                    Text(String(date.date.dateFormatte(date: "dd.MM", time: "").date ))
                        .font(.caption.bold())
                }
            }
        
    }

    private func getPercent(input: Double, max: Double) -> CGFloat {
        return 200 / max * input
    }
}

struct dailyStepsSheets: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var themeManager: ThemeManager
    
    @EnvironmentObject var googleInterstitial: GoogleInterstitialAd
    
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    
    var date: Date
    
    @Binding var sheetHeight: CGFloat
    
    @StateObject var healthStore = HealthStoreProvider()
    
    @State var stepCount: Double = 0
    @State var distanceCount: Double = 0
    @State var workoutSeconds: Double = 0
    @State var walkingAsymmetryPercentage: Double = 0
    
    var hourlySteps:[StepsByHour]
    
    @State var snapsheet = false
    
    var body: some View {
        VStack(spacing: 20){
            
            HStack(spacing: 10) {
                Spacer()
                
                Button(action: {
                    snapsheet.toggle()
                }, label: {
                    Image(systemName: "square.and.arrow.up")
                        .padding(10)
                })
            }
            
            HStack{
                // Steps
                VStack(alignment: .leading, spacing: 5) {
                    HStack{
                        Image("figure.steps")
                            .font(.largeTitle)
                        
                        // selected Values
                        VStack(alignment: .leading) {
                            Text(String(format: "%.0f", stepCount))
                                .font(.title2).fontWeight(.bold)
                            
                            Text("Steps")
                                .font(.subheadline)
                        }
                        
                        Spacer()
                    }
                }
                
                Spacer()
                
                // Distanz
                VStack(alignment: .leading, spacing: 5) {
                    HStack{
                        Image("distance")
                            .font(.largeTitle)
                        
                        // selected Values
                        VStack(alignment: .leading) {
                            Text(String(format: "%.1f", (distanceCount / 1000) ) + "km")
                                .font(.title2).fontWeight(.bold)
                            
                            Text("Distance")
                                .font(.subheadline)
                        }
                        
                        Spacer()
                    }
                }
                
                Spacer()
                
                // Tragezeit
                VStack(alignment: .leading, spacing: 5) {
                    HStack{
                        Image("figure.prothese")
                            .font(.largeTitle)
                        
                        // selected Values
                        VStack(alignment: .leading) {
                            let (h,m,_) = Int(workoutSeconds).secondsToHoursMinutesSeconds
                            Text("\(h):\(m)h")
                                .font(.title2).fontWeight(.bold)
                            
                            Text("Wearing time")
                                .font(.subheadline)
                        }
                        
                        Spacer()
                    }
                }
            }
            .foregroundColor(currentTheme.text)
            
            HStack {
                HourlyStepsChart()
            }
            .foregroundColor(currentTheme.text)
        }
        .fullScreenCover(isPresented: $snapsheet, onDismiss: { 
        //.blurredSheet(.init(.ultraThinMaterial), show: $snapsheet, onDismiss: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                googleInterstitial.showAd()
            })
        }, content: {
            
            ZStack(content: {
                currentTheme.gradientBackground(nil).ignoresSafeArea()
                
                FloatingClouds(speed: 1.0, opacity: 0.5, currentTheme: currentTheme)
                    .opacity(0.5)
                
               // SnapShotView(sheet: $snapsheet, steps: stepCount, distance: "\( String(format: "%.1f", distanceCount / 1000 ) )km", date: Date())
            })
            
            
        })
        .onAppear {
            healthStore.queryDayCountbyType(date: date, type: .stepCount) { steps in
                DispatchQueue.main.async {
                    self.stepCount = steps
                }
            }
            healthStore.queryDayCountbyType(date: date, type: .distanceWalkingRunning) { steps in
                DispatchQueue.main.async {
                    self.distanceCount = steps
                }
            }
            healthStore.getWorkoutsByDate(date: date, workout: .default(), completion: { seconds in
                DispatchQueue.main.async {
                    self.workoutSeconds = seconds
                }
            })
        }
        .background(GeometryReader { gp -> Color in
           DispatchQueue.main.async {
               self.sheetHeight = gp.size.height + 35 + 35
           }
            return Color.clear
       })
    }
    
    @ViewBuilder
    func HourlyStepsChart() -> some View {
        Chart {
            ForEach(hourlySteps, id: \.start) { day in
                AreaMark(x: .value("date", day.start), y: .value("value", day.count))
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(
                        .linearGradient(
                            colors: [
                                currentTheme.accentColor.opacity(0),
                                currentTheme.accentColor.opacity(0.1),
                                currentTheme.accentColor.opacity(0.5)
                            ],
                            startPoint: .bottom,
                            endPoint: .top)
                    )
                
                LineMark(x: .value("date", day.start), y: .value("value", day.count))
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(
                        .linearGradient(
                            colors: [
                                currentTheme.text.opacity(0.5),
                                currentTheme.hightlightColor.opacity(0.5)
                            ],
                            startPoint: .bottom,
                            endPoint: .top)
                    )
                    .lineStyle(.init(lineWidth: 3))
            }
            
        }
        .chartYScale(range: .plotDimension(padding: 10))
        .chartXScale(range: .plotDimension(padding: 10))
        .frame(maxHeight: 150)
    }
}

struct calendarSheetBody: View {
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var adSheet: GoogleInterstitialAd
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    
    @Binding var binding: Bool
    
    @Binding var currentDate: Date
    
    @State var date = Date()
    
    @State var months: [(date: Date, name: String)] = []
    
    @State var weeks: [(start: Date, end: Date)] = []
    
    @State var disable = true
    
    var body: some View {
        VStack(spacing: 20) {
            // YEAR CHANGER
            HStack {
                Button(action: {
                    date = Calendar.current.date(byAdding: .year, value: -1, to: date)!
                    weeks.removeAll()
                }, label: {
                    Image(systemName: "chevron.left")
                        .font(.title3.bold())
                        .foregroundColor(currentTheme.text)
                        .padding()
                })
                .transaction { transaction in
                    transaction.animation = nil
                }
                
                Text(date.dateFormatte(date: "yyyy", time: "").date)
                    .font(.title3.bold())
                    .foregroundColor(currentTheme.text)
                    .transaction { transaction in
                        transaction.animation = nil
                    }
                
                Button(action: {
                    let nextYear = Calendar.current.date(byAdding: .year, value: +1, to: date)!
                    
                    if !Calendar.current.isDateInNextYear(nextYear) {
                        date = Calendar.current.date(byAdding: .year, value: +1, to: date)!
                        weeks.removeAll()
                    }
                }, label: {
                    Image(systemName: "chevron.right")
                        .font(.title3.bold())
                        .foregroundColor(!Calendar.current.isDateInNextYear(Calendar.current.date(byAdding: .year, value: +1, to: date)!) ? currentTheme.text : currentTheme.textGray )
                        .padding()
                })
                .transaction { transaction in
                    transaction.animation = nil
                }
            }
            .padding(.top)
            .transaction { transaction in
                transaction.animation = nil
            }
            
            
            // MONTHS CHANGER
            if weeks.count == 0 {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4) , spacing: 12) {
                    ForEach(months, id: \.date) { month in
                        
                        Button(action: {
                            date = month.date
                            
                            withAnimation(.spring()) {
                                self.weeks = extractWeeks(date: month.date)
                            }
                        }, label: {
                            HStack {
                                
                                Spacer()
                                
                                Text("\(month.date.dateFormatte(date: "MMM", time: "").date)" ) //\(month.name.prefix(3)).
                                    .font(.caption.bold())
                                    .foregroundColor(currentTheme.text)
                                
                                Spacer()
                            }
                            .padding()
                            .disabled(month.date > Date())
                            .background(isSameMonth(d1: date, d2: month.date) ? currentTheme.primary :  month.date > Date() ? currentTheme.text.opacity(0.05) : currentTheme.text.opacity(0.25)   )
                            .cornerRadius(20)
                            .frame(maxWidth: .infinity)
                        })
                        
                    }
                }
                .padding(.horizontal)
            }
            
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(weeks, id: \.start) { week in
                    
                    Button(action: {
                        if week.start == date {
                            weeks.removeAll()
                        } else {
                            
                            if week.start < Date() {
                                date = week.start
                                currentDate = date
                                binding = false
                            }
                            
                        }
                    }, label: {
                        HStack {
                            
                            Spacer()
                            
                            Text(week.start.dateFormatte(date: "dd.MM.", time: "").date + "-" + week.end.dateFormatte(date: "dd.MM.", time: "").date)
                                .font(.caption.bold())
                                .foregroundColor(currentTheme.text)
                            
                            Spacer()
                        }
                        .padding()
                        .disabled(week.start > Date())
                        .background(isSameWeek(d1: date, d2: week.start) ? currentTheme.primary : week.start > Date() ? currentTheme.text.opacity(0.05) : currentTheme.text.opacity(0.25))
                        .cornerRadius(20)
                        .frame(maxWidth: .infinity)
                    })
                    
                }
            }
            .padding(.horizontal)
            
            HStack {
                Button(action: {
                    weeks.removeAll(keepingCapacity: true)
                }, label: {
                    Text("Reset")
                        .foregroundColor(currentTheme.text)
                        .padding()
                })
                .background(.ultraThinMaterial)
                .cornerRadius(20)
                
                Button(action: {
                    withAnimation(.spring()) {
                        currentDate = Date()
                        binding = false
                    }
                }, label: {
                    Text("Today")
                        .foregroundColor(currentTheme.text)
                        .padding()
                })
                .background(.ultraThinMaterial)
                .cornerRadius(20)
            }
            
            Spacer()
        }
        .onAppear{
            months = extractMonts()
            adSheet.requestInterstitialAds()
        }
        .onChange(of: date, perform: { newDate in
            months = extractMonts()
        })
        .presentationDetents([.height(450)])
        .presentationDragIndicator(.visible)
    }
    
    func extractMonts() -> [(date: Date, name: String)] {
        var dates: [(date: Date, name: String)] = []
        // this year
        let year = Calendar.current.component(.year, from: self.date)
        // first day of this year
        if let firstOfthisYear = Calendar.current.date(from: DateComponents(year: year, month: 1, day: 1)) {
            for i in 0..<12 {
                let month = Calendar.current.date(byAdding: .month, value: i, to: firstOfthisYear)
                
                dates.append((date: month!, name: month?.dateFormatte(date: "MMMM", time: "").date ?? ""))
            }
        }
        
        return dates
    }
    
    func extractWeeks(date: Date) -> [(start: Date, end: Date)] {
        
        let today = Calendar.current.startOfDay(for: date)

        let firstOfMonth = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: today))!

        var weeks: [(start: Date, end: Date)] = []

        for i in 0...5 {
            let week = Calendar.current.date(byAdding: .weekOfMonth, value: i, to: firstOfMonth)!
            if Calendar.current.isDate(firstOfMonth, equalTo: week, toGranularity: .month) {
           
                print(Calendar.current.date(byAdding: .minute, value: -1, to: week.endOfWeek!)!)
                weeks.append(
                    (
                        start: week.startOfWeek(),
                        end: Calendar.current.date(byAdding: .minute, value: -1, to: week.endOfWeek!)!
                    )
                )
            }
        }
        
        return weeks
    }
    
    func isSameMonth(d1: Date, d2: Date) -> Bool {
        return Calendar.current.isDate(d1, equalTo: d2, toGranularity: .month) ? true : false
    }
    
    func isSameWeek(d1: Date, d2: Date) -> Bool {
        return Calendar.current.isDate(d1, equalTo: d2, toGranularity: .weekOfMonth) ? true : false
    }
}

struct newStepPreview_Previews: PreviewProvider {
    static var previews: some View {
        newStepPreview(snapsheet: .constant(false))
            .environmentObject(AppConfig())
            .environmentObject(WorkoutStatisticViewModel())
    }
}

struct Line: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        return path
    }
}





struct LineChartCompairWeek: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    
    @Environment(\.scenePhase) var scenePhase
    
    @EnvironmentObject var googleInterstitial: GoogleInterstitialAd
    
    @StateObject var healthStore = HealthStoreProvider()
    
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    
    @Binding var currentDate: Date
    
    @Binding var snapsheet:Bool
    
    var max: Int
    
    @State var StoredCollectionThisWeek: [ChartData] = []
    
    @State var StoredCollectionLastWeek: [ChartData] = []
    
    @State var currentWeek: [DateValue] = []
    
    @State var positionForNewColor: CGFloat = 0.0
    
    private var countedData: Int {
        var data: [Double] = []
        
        let _ = currentWeek.map({ weekDay in
            let steps = StoredCollectionThisWeek.first(where: { Calendar.current.isDate(weekDay.date, inSameDayAs: $0.date) })?.value ?? -1
            
            if steps > 0 {
                data.append(steps)
            }
            
        })
        
        return data.count
    }
    
    public func calculatePercentage(value:Double,percentageVal:Double)->Double{
        return 100.0 / value * percentageVal
    }
    
    var percent: CGFloat {
        guard countedData >= 1 else {
            return 0.0
        }
        
        return CGFloat(calculatePercentage(value: 6, percentageVal: Double(countedData - 1)) / 100)
    }

    @State var rulemark: Date? = nil
    @State var rulemarkOpacity = 0.0
    
    let timer = Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
    @State var isTimerRunning = false
    
    @State var selectedDate: Date? = nil
   
    @State var stepCount: Double = 0
    @State var distanceCount: Double = 0
    @State var workoutSeconds: Double = 0
    
    var xValues: [Date] {
        return currentWeek.map({ $0.date })
    }
    
    var body: some View {
        
        VStack {
            Chart() {
                if let ru = rulemark {
                    RuleMark(x: .value("Date", ru ))
                        .foregroundStyle(currentTheme.textGray.opacity(0.5))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [5,5]))
                        .opacity(rulemarkOpacity)
                }
                
                RuleMark(y: .value("Steps", AppConfig.shared.targetSteps ))
                    .foregroundStyle(currentTheme.hightlightColor.opacity(0.2))
                    .lineStyle(StrokeStyle(lineWidth: 1, dash: [15,10]))
                    .opacity(rulemarkOpacity)
            
                ForEach(currentWeek, id: \.date) { weekDay in
                    let dateLastWeek = Calendar.current.date(byAdding: .day, value: -7, to: weekDay.date)!
                    let steps = StoredCollectionLastWeek.first(where: { Calendar.current.isDate(dateLastWeek, inSameDayAs: $0.date) })?.value ?? 0

                    LineMark(
                        x: .value("Date", weekDay.date ),
                        y: .value("Steps", steps),
                        series: .value("Last Week", "Last Week")
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(currentTheme.textGray.opacity(0.5))
                    .lineStyle(.init(lineWidth: 1))
                    .symbol {
                        
                        ZStack {
                            let calendar = Calendar.current
                            let rule = calendar.isDate(weekDay.date, inSameDayAs: ditectTodayCircle()) || calendar.isDate(weekDay.date, inSameDayAs: rulemark ?? calendar.date(byAdding: .day, value: -10, to: weekDay.date)! )
                            
                            Circle()
                                .fill(currentTheme.textGray)
                                .frame(width: 6)
                                .opacity(rule ? 1 : 0)
                            
                            Text("")
                                .font(.caption2.bold())
                                .foregroundColor(currentTheme.textGray)
                                .offset(y: -20)
                        }

                    }
                    
                }
                
                ForEach(currentWeek, id: \.date) { weekDay in
                    
                    let steps = StoredCollectionThisWeek.first(where: { Calendar.current.isDate(weekDay.date, inSameDayAs: $0.date) })?.value ?? 0
                    
                    LineMark(
                        x: .value("Date", weekDay.date ),
                        y: .value("Steps", steps),
                        series: .value("This Week", "This Week")
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(
                        .linearGradient(
                            Gradient(
                                stops: [
                                    .init(color: currentTheme.hightlightColor.opacity(positionForNewColor == 0.0 ? 0 : 1), location: 0),
                                    .init(color: currentTheme.hightlightColor.opacity(positionForNewColor == 0.0 ? 0 : 1), location: positionForNewColor - 0.0005),
                                    .init(color: .gray.opacity(0.0), location: positionForNewColor - 0.0005),
                                    .init(color: .gray.opacity(0.0), location: 1),
                                ]),
                            startPoint: .leading,
                            endPoint: .trailing)
                    )
                    .lineStyle(.init(lineWidth: 3))
                    .symbol {
                        
                        ZStack {
                            let calendar = Calendar.current
                            let rule = calendar.isDate(weekDay.date, inSameDayAs: ditectTodayCircle()) || calendar.isDate(weekDay.date, inSameDayAs: rulemark ?? calendar.date(byAdding: .day, value: -10, to: weekDay.date)! )
                            
                            
                            if Calendar.current.isDate(weekDay.date, inSameDayAs: ditectTodayCircle()) {
                                AnimatedCircle(size: 12, color: currentTheme.hightlightColor)
                                    .opacity(rule ? 1 : 0)
                            } else {
                                Circle()
                                    .fill(.ultraThinMaterial)
                                    .frame(width: 12)
                                    .opacity(rule ? 1 : 0)
                                
                                Circle()
                                    .fill(currentTheme.hightlightColor)
                                    .frame(width: 6)
                                    .opacity(rule ? 1 : 0)
                            }
                            
                            Text(steps.round(decimal: 0))
                                .font(.caption2.bold())
                                .foregroundColor(currentTheme.text)
                                .offset(y: -20)
                                .opacity(rule ? 1 : 0)
                        }
                        .opacity(weekDay.date > Date().startEndOfDay().end ? 0 : 1)
                        
                        
                    }
                    
                }
            }
            .chartYScale(domain: 0...max)
            .chartYAxis(.hidden)
            .chartYScale(range: .plotDimension(padding: 20))
            .chartXScale(range: .plotDimension(padding: 30))
            .chartXAxis {
                AxisMarks(preset: .aligned, position: .bottom, values: xValues) { date in
                    AxisValueLabel() {
                        if let d = date.as(Date.self) {
                            
                            Text("\(d.toDayString)")
                                .font(.system(size: 6))
                                //.opacity(day == 5 || day == 10 || day == 15 || day == 20 || day == 25 || day == 30 ? 1 : 0)
                        }
                    }
                }
            }
            .chartOverlay { proxy in
                GeometryReader { geometry in
                        Rectangle().fill(.clear).contentShape(Rectangle())
                            .gesture(
                                DragGesture()
                                    .onChanged { value in
                                        // Convert the gesture location to the coordinate space of the plot area.
                                        let origin = geometry[proxy.plotAreaFrame].origin
                                        let location = CGPoint(
                                            x: value.location.x - origin.x,
                                            y: value.location.y - origin.y
                                        )
                                        // Get the x (date) and y (price) value from the location.
                                        let (date, _) = proxy.value(at: location, as: (Date, Double).self)!
                                        selectedDate = date
                                        
                                    }
                            )
                    }
            }
            .chartOverlay { proxy in
              GeometryReader { geometry in
                Rectangle().fill(.clear).contentShape(Rectangle())
                  .onTapGesture { location in
                        let (date, _) = proxy.value(at: location, as: (Date, Double).self)!
                        //Check if value is included in the data from the chart
                        selectedDate = date
                  }
               }
            }
            .frame(height: 300)
            .fullScreenCover(isPresented: $snapsheet, onDismiss: {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    googleInterstitial.showAd()
                })
            }, content: {
                
                ZStack(content: {
                    currentTheme.gradientBackground(nil).ignoresSafeArea()
                    
                    FloatingClouds(speed: 1.0, opacity: 0.5, currentTheme: currentTheme)
                        .opacity(0.5)

                    SnapShotView(isSheet: $snapsheet)
                })
            })
            .onAppear {
                resetData()
                loadData(week: DateInterval(start: currentDate.startOfWeek(), end: currentDate.endOfWeek!))
            }
            .onChange(of: selectedDate, perform: { newDate in
                rulemark = newDate!.startEndOfDay().start
                loadSnapData()
            })
            .onChange(of: rulemark, perform: { newDate in
                loadSnapData()
            })
            .onChange(of: currentDate, perform: { newDate in
                resetData()
                loadData(week: DateInterval(start: newDate.startOfWeek(), end: newDate.endOfWeek!))
            })
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    resetData()
                    loadData(week: DateInterval(start: currentDate.startOfWeek(), end: currentDate.endOfWeek!))
                }
            }
            .onReceive(timer) { _ in
                guard percent != 0.0 else {
                    return positionForNewColor = 0.0
                }
                
                if self.isTimerRunning {
                    
                    guard positionForNewColor <= CGFloat(percent) else {
                        self.isTimerRunning.toggle()
                        return
                    }
                    
                    positionForNewColor += 0.005
                }
            }
            
        }
        
    }
    
    func resetData() {
        StoredCollectionThisWeek = []
        StoredCollectionLastWeek = []
        self.positionForNewColor = 0
        self.rulemark = Date().startOfWeek()
        self.rulemarkOpacity = 0.0
    }
    
    func loadData(week: DateInterval) { // , type: AnimationType
        withAnimation( .easeInOut ) {
            currentWeek = extractWeek()
            getSteps(week: week)
        }

        selectedDate = extractWeek().first?.date ?? Date()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.easeInOut) {
                isTimerRunning.toggle()
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            withAnimation(.easeInOut) {
                rulemarkOpacity = 1.0
                rulemarkHandler()
            }
        }
        
    }

    func loadSnapData() {
        healthStore.queryDayCountbyType(date: rulemark ?? Date(), type: .stepCount) { steps in
            DispatchQueue.main.async {
                self.stepCount = steps
            }
        }
        healthStore.queryDayCountbyType(date: rulemark ?? Date(), type: .distanceWalkingRunning) { steps in
            DispatchQueue.main.async {
                self.distanceCount = steps
            }
        }
        healthStore.getWorkoutsByDate(date: rulemark ?? Date(), workout: .default(), completion: { seconds in
            DispatchQueue.main.async {
                self.workoutSeconds = seconds
            }
        })
    }
    
    func rulemarkHandler() {
        guard currentWeek.last != nil else { return }
        
        if Calendar.current.isDateInThisWeek(currentDate) {
            let todaySteps = StoredCollectionThisWeek.first(where: { Calendar.current.isDate(currentDate, inSameDayAs: $0.date) })?.value ?? 0
            
            if todaySteps == 0 {
                // when its today but you dont have any Steps dont today
                let date = currentWeek.first(where: { Calendar.current.isDate(Calendar.current.date(byAdding: .day, value: -1, to: Date())!, inSameDayAs: $0.date) })?.date
                if let foundDay = date {
                   rulemark = foundDay
                }
            } else {
                // when its today but you have any Steps today
                let date = currentWeek.first(where: { Calendar.current.isDate(Date(), inSameDayAs: $0.date) })?.date
                if let foundDay = date {
                    rulemark = foundDay
                }
            }
        } else {
            rulemark = currentWeek.first?.date
        }
        
        loadSnapData()
    }
    
    func ditectTodayCircle() -> Date {
        guard let lastDay = currentWeek.last else { return Date() }
        
        guard Calendar.current.isDateInThisWeek(lastDay.date) else { return Date() }
        
        let todaySteps = StoredCollectionThisWeek.first(where: { Calendar.current.isDate(Date(), inSameDayAs: $0.date) })?.value ?? 0
        
        guard todaySteps == 0 else {
            // when its today but you have any Steps today
            let date = currentWeek.first(where: { Calendar.current.isDate(Date(), inSameDayAs: $0.date) })?.date
            guard let foundDay = date else {
                return Date()
            }
            
            return foundDay
        }
        
        let date = currentWeek.first(where: { Calendar.current.isDate(Calendar.current.date(byAdding: .day, value: -1, to: Date())!, inSameDayAs: $0.date) })?.date
       
        guard let foundDay = date else {
            return Date()
        }
        
        return foundDay
    }
    
    func getSteps(week: DateInterval ) {
        // Total Steps
        healthStore.queryWeekCountbyType(week: week, type: .stepCount, completion: { stepCount in
            DispatchQueue.main.async {
                self.StoredCollectionThisWeek = stepCount.data
            }
        })
        
        
        let lastweekDate: Date = Calendar.current.date(byAdding: .day, value: -7, to: week.start)!
        let lastweekDates = lastweekDate.startEndOfWeek
        healthStore.queryWeekCountbyType(week: DateInterval(start: lastweekDates.start, end: lastweekDates.end), type: .stepCount, completion: { stepCount in
            DispatchQueue.main.async {
                self.StoredCollectionLastWeek = stepCount.data
            }
        })
    }
    
    func extractWeek() -> [DateValue] {
        var days: [DateValue] = []
        for i in 0...6 {
            days.append(
                DateValue(
                    day: Calendar.current.date(byAdding: .day, value: i, to: self.currentDate.startOfWeek())! > Date() ? -1 : 0,
                    date: Calendar.current.date(byAdding: .day, value: i, to: self.currentDate.startOfWeek())!
                )
            )
        }
        
        return days
    }
}
