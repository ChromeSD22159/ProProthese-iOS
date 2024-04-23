//
//  PainEntry.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 26.05.23.
//

import SwiftUI
import CoreData
import Charts

struct PainEntry: View {
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject var cal: MoodCalendar
    @EnvironmentObject var vm: PainViewModel
    @EnvironmentObject var tabManager: TabManager
    @EnvironmentObject var entitlementManager: EntitlementManager
    @EnvironmentObject var appConfig: AppConfig
    @EnvironmentObject var googleInterstitial: GoogleInterstitialAd
    let persistenceController = PersistenceController.shared
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) private var Pains: FetchedResults<Pain>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) private var PainReasons: FetchedResults<PainReason>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.date, order: .reverse)]) private var PainDrugs: FetchedResults<PainDrug>
    
    @EnvironmentObject var themeManager: ThemeManager
    
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    
    private var avg: Int {
        if Pains.count != 0 {
            return (Pains.map({ Int($0.painIndex) }).reduce(0, +) / Pains.count)
        } else {
            return 0
        }
    }
    
    private var Reasons: [String] {
        return PainReasons.map({ $0.name ?? "" })
    }
    
    @State var PainCorrelations: [PainCorrelation] = []
 
    @State private var shouldUpdate: Int = 0
    
    var dimensions: [Ray] {
        var r: [Ray] = []
        r.append(Ray(maxVal: 1.0, rayCase: .Steps))
        r.append(Ray(maxVal: 1.0, rayCase: .Weather))

        if appConfig.WidgetContentTemp == .c {
            r.append(Ray(maxVal: 1.0, rayCase: .TemperatureC))
        } else {
            r.append(Ray(maxVal: 1.0, rayCase: .TemperatureF))
        }
        
        r.append( Ray(maxVal: 1.0, rayCase: .Pressure))
        r.append(Ray(maxVal: 1.0, rayCase: .Times))
        
        return r
    }
    
    @State var tabSize: CGSize = .zero
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false, content: {
            VStack(spacing: 10) {
                AnimatedHeader()
                
                AddPainCard()

                if vm.showList {
                    ListPainEntrys()
                        .padding(.top)
                } else {
                    StatisticCard(avg: avg, items: Pains.count)
                    
                    PainStatisticEntrys(min: Pains.map{ Int($0.painIndex) }.min() ?? 0, max: Pains.map{ Int($0.painIndex) }.max() ?? 0, avg: avg).saveSize(in: $tabSize)
                        .padding()
                        .background(.ultraThinMaterial.opacity(0.4))
                        .cornerRadius(20)
                        .padding(.horizontal)
                        .show(Pains.count > 0)
                    
                    CorrelationsView()
                        .padding()
                        .background(.ultraThinMaterial.opacity(0.4))
                        .cornerRadius(20)
                        .padding(.horizontal)
                        .show(getSumOfCorrelation() > 0.0)
                    
                    CorrelationsReasons()
                        .show(getSumOfCorrelation() > 0.0)
                    
                    Spacer()
                }
            }
            .onChange(of: shouldUpdate) { _ in
                PainCorrelations = []
                PainCorrelations = calculateCorrelations()
            }
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    PainCorrelations = []
                    PainCorrelations = calculateCorrelations()
                }
            }
            .onAppear(perform: {
                PainCorrelations = calculateCorrelations()
            })
        })
        .coordinateSpace(name: "SCROLL")
        .ignoresSafeArea(.container, edges: .vertical)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        // MARK: - AddNewPainSheet
        .fullScreenCover(isPresented: $vm.isPainAddSheet, onDismiss: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                googleInterstitial.showAd()
            })
            
            shouldUpdate += 1
            
            vm.editPain = nil
            vm.resetStates()
        }, content: {
            ZStack(content: {
                currentTheme.gradientBackground(nil).ignoresSafeArea()
                
                FloatingClouds(speed: 1.0, opacity: 0.5, currentTheme: currentTheme)
                    .opacity(0.5)
                
                PainAddSheet(isSheet: $vm.isPainAddSheet, entryDate: Date())
            })
        })
        
        // MARK: - Delete Reason & Drugs
        .fullScreenCover(isPresented: $vm.isDeleteReasonDrugsSheet, onDismiss: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { // Show InterstitialSheet if not Pro
                googleInterstitial.showAd()
            })
        }, content: {
            ZStack(content: {
                currentTheme.gradientBackground(nil).ignoresSafeArea()
                
                FloatingClouds(speed: 1.0, opacity: 0.5, currentTheme: currentTheme)
                    .opacity(0.5)
                
                DeleteReasonDrugsSheetBody()
            })
        })
        // MARK: - Init PainDrugs & Reason
        .onAppear{

            if PainReasons.count == 0 {
                vm.addDefaultPainReason(["weather", "cold", "warmth", "No Reason"])
            }
            
            if PainDrugs.count == 0 {
                vm.addDefaultPainDrugs(["No Painkiller"])
            }
            
            let searchNoReason = PainReasons.map({ $0.name }).contains("No Reason")
            
            if !searchNoReason {
                vm.addDefaultPainReason(["No Reason"])
            }
        }
    }
    
    @ViewBuilder func AnimatedHeader() -> some View {
        GeometryReader { proxy in
            
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let size = proxy.size
            let height = (size.height + minY)
            
            Rectangle()
                .fill(currentTheme.radialBackground(unitPoint: nil, radius: nil))
                .frame(width: size.width, height: max(0, height), alignment: .top)
                .overlay(content: {
                    ZStack {
                        
                        currentTheme.radialBackground(unitPoint: nil, radius: nil)
                        
                        WelcomeHeader()
                            .blur(radius: minY.sign == .minus ? abs(minY / 10) : 0)
                            .offset(y: minY.sign == .minus ? minY * 0.5 : 0)
                    }
                    
                })
                .cornerRadius(20)
                .offset(y: -minY)
            
        }
        .frame(height: 125)
    }
    
    @ViewBuilder func WelcomeHeader() -> some View {
        HStack(){
            VStack(spacing: 2){
                sayHallo(name: AppConfig.shared.username)
                    .font(.title2)
                    .foregroundColor(currentTheme.text)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Keep track of your phantom limb pain.")
                    .font(.caption2)
                    .foregroundColor(currentTheme.textGray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            HStack(spacing: 20){
                
                if !entitlementManager.hasPro {
                    Image(systemName: "trophy.fill")
                        .foregroundColor(currentTheme.text)
                        .onTapGesture {
                            DispatchQueue.main.async {
                                tabManager.ishasProFeatureSheet.toggle()
                            }
                        }
                }
                
                Image(systemName: vm.showList ? "chart.pie" : "list.bullet.below.rectangle")
                    .foregroundColor(currentTheme.text)
                    .font(.title3)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.5)){
                            vm.showList.toggle()
                        }
                    }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 30)
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder func StatisticCard(avg: Int, items: Int) -> some View {
        VStack(alignment: .leading, spacing: 8){
            HStack(spacing: 8) {
                Text("Statistics")
                Spacer()
            }
            
            HStack(spacing: 8) {
                VStack(alignment: .leading){
                    Text("\(avg)")
                        .font(.title.bold())
                    Text("⌀ Pain value")
                        .font(.caption2)
                        .foregroundColor(currentTheme.textGray)
                    
                    Rectangle()
                        .fill(currentTheme.hightlightColor)
                        .frame(maxWidth: .infinity, maxHeight: 5)
                }
                Spacer()
                VStack(alignment: .leading){
                    Text("\(items)")
                        .font(.title.bold())
                    
                    Text("Number of entries")
                        .font(.caption2)
                        .foregroundColor(currentTheme.textGray)
                    
                    Rectangle()
                        .fill(currentTheme.primary)
                        .frame(maxWidth: .infinity, maxHeight: 5)
                }
            }
        }
        .foregroundColor(currentTheme.text)
        .padding()
        .background(.ultraThinMaterial.opacity(0.4))
        .cornerRadius(20)
        .padding(.horizontal)
    }
    
    @ViewBuilder func AddPainCard() -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.5)){
                vm.isPainAddSheet.toggle()
                
                if PainReasons.count != 0 {
                    vm.selectedReason = PainReasons.first(where: { LocalizedStringKey($0.name!) == LocalizedStringKey("No Reason") })
                } else {
                    vm.selectedReason = nil
                }
                
                if PainDrugs.count != 0 {
                    vm.selectedDrug = PainDrugs.first(where: { LocalizedStringKey($0.name!) == LocalizedStringKey("No Painkiller") })
                } else {
                    vm.selectedDrug = nil
                }
            }
        }, label: {
            HStack(alignment: .center, spacing: 20) {
                Image(systemName: "bolt.fill")
                    .font(.largeTitle)
                
                VStack {
                    HStack {
                        Text("Enter current pain")
                            .font(.headline.bold())
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Text("Document your current pain")
                            .font(.footnote)
                            .multilineTextAlignment(.leading)
                        
                        Spacer()
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .foregroundColor(currentTheme == Theme.orange ? currentTheme.text : currentTheme.primary)
            .padding()
            .background(currentTheme.hightlightColor.gradient)
            .cornerRadius(20)
            .padding(.horizontal)
        })
    }
    
    @ViewBuilder func ListPainEntrys() -> some View {
        HStack(spacing: 20){
            Text("entries:")
                .font(.body.bold())
                .foregroundColor(currentTheme.text)
            Spacer()
            
            Label("Administer", systemImage: "slider.vertical.3")
                .foregroundColor(currentTheme.text)
                .font(.body.bold())
                .onTapGesture {
                    withAnimation(.easeInOut(duration: 0.5)){
                        vm.isDeleteReasonDrugsSheet.toggle()
                    }
                }
        }
        .padding(.horizontal)
        
        ScrollView(.vertical, showsIndicators: false, content: {
            
            if Pains.count == 0 {
                HStack{
                    Label("No pain recorded!", systemImage: "chart.bar.xaxis")
                    Spacer()
                }
                .foregroundColor(currentTheme.text)
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(10)
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
            }
            
            ForEach(Pains){ pain in
                
                PainRow(pain: pain, vm: vm)

            }
            
            // In-App-ABO
            InfomationField( // In-App-ABO
                backgroundStyle: .ultraThinMaterial,
                text: LocalizedStringKey("The pain recorder is available in the current version. A more detailed recording is planned, in combination with a medication plan/reminder. In addition, a PDF creation of the documented data is planned, which can be easily shared or emailed to the appropriate contacts. In addition, other widgets and statistics are created."),
                visibility: AppConfig.shared.hasUnlockedPro ? AppConfig.shared.hideInfomations : true) 
                .padding(.horizontal)
        })
    }
    
    @ViewBuilder func PainStatisticEntrys(min: Int, max: Int, avg: Int) -> some View {
        VStack(spacing: 20){
            VStack(alignment: .leading, spacing: 8){

                Text("Pain average per reason")
                
                Chart(Reasons, id: \.self) { reason in
                    let filter = Pains.filter{ $0.painReasons?.name == reason }.map{ Int($0.painIndex) }
                    
                    let avg = filter.count == 0 ? filter.count : filter.reduce(0, +) / filter.count
                    
                    BarMark(
                        x: .value("Reason", LocalizedStringKey(reason).localizedstring()) ,
                        y: .value("Pain", avg)
                    )
                    .foregroundStyle(by: .value("Pain", avg))
                   
                }
                .chartForegroundStyleScale(
                    range: [.blue, .yellow, .orange, .red]
                )
                .frame(height: 200)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Pain assessment")
                    Text("What was your last pain?")
                        .font(.caption2)
                        .foregroundColor(currentTheme.textGray)
                }
                
                HStack(spacing: 8) {
                    
                    VStack(alignment: .leading){
                        Text("\(min)")
                            .font(.title.bold())
                        Text("Lowest")
                            .font(.caption2)
                            .foregroundColor(currentTheme.textGray)
                        
                        Rectangle()
                            .fill(.blue)
                            .frame(maxWidth: .infinity, maxHeight: 5)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading){
                        Text("\(avg)")
                            .font(.title.bold())
                        
                        Text("Average")
                            .font(.caption2)
                            .foregroundColor(currentTheme.textGray)
                        
                        Rectangle()
                            .fill(currentTheme.hightlightColor)
                            .frame(maxWidth: .infinity, maxHeight: 5)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading){
                        Text("\(max)")
                            .font(.title.bold())
                        
                        Text("Highest")
                            .font(.caption2)
                            .foregroundColor(currentTheme.textGray)
                        
                        Rectangle()
                            .fill(.red)
                            .frame(maxWidth: .infinity, maxHeight: 5)
                    }
                }
            }
            .foregroundColor(currentTheme.text)
        }
    }
    
    @ViewBuilder func CorrelationsView() -> some View {
        VStack(alignment: .leading, spacing: 10){

            Text("Find your pain connections")
                .foregroundColor(currentTheme.text)
            
            RadarChartView(
                width: tabSize.width,
                MainColor: Color.gray.opacity(0.5),
                SubtleColor: Color.gray.opacity(0.3),
                LabelColor: currentTheme.hightlightColor,
                quantity_incrementalDividers: 10,
                dimensions: dimensions,
                data: [
                    DataPoint(
                        Steps: abs( self.PainCorrelations.first(where: { $0.type == .step })?.correlationCoefficient ?? 0 ),
                        Weather: abs( self.PainCorrelations.first(where: { $0.type == .waether })?.correlationCoefficient ?? 0 ),
                        TemperatureC: abs( self.PainCorrelations.first(where: { $0.type == .tempC })?.correlationCoefficient ?? 0 ),
                        TemperatureF: abs( self.PainCorrelations.first(where: { $0.type == .tempF })?.correlationCoefficient ?? 0 ),
                        Pressure: abs( self.PainCorrelations.first(where: { $0.type == .pressure })?.correlationCoefficient ?? 0 ),
                        Times: abs( self.PainCorrelations.first(where: { $0.type == .times })?.correlationCoefficient ?? 0 ),
                        color: currentTheme.hightlightColor
                    )
                ]
            ).show(self.PainCorrelations.count > 5)
        }
        .foregroundColor(currentTheme.text)
    }
    
    @State var tabSizeCorrelation:CGSize = .zero
    @State var percent = 10.0
    @State var avgSteps = 0.0
    @ViewBuilder func CorrelationsReasons() -> some View {
        TabView {
            CollerationReason(
                reason:  getStepLevel(avg: avgSteps, correlationSteps: Double(highestSteps.highest ?? Int(0.0))).localizedstring(),
                quality: convertToPercentage(value: abs(highestSteps.correlation)),
                image: "bolt.fill"
            )
            .saveSize(in: $tabSizeCorrelation)
            .show(convertToPercentage(value: abs(highestSteps.correlation)) > 0)
            .padding(.horizontal)
            
            if appConfig.WidgetContentTemp == .c {
                CollerationReason(
                    reason: String(format: NSLocalizedString("Most pain at %lld °C", comment: ""), highestCelsius.highest ?? 0),
                    quality: convertToPercentage(value: abs(highestCelsius.correlation)),
                    image: "thermometer.low"
                ) 
                .saveSize(in: $tabSizeCorrelation)
                .show(convertToPercentage(value: abs(highestCelsius.correlation)) > 0)
                .padding(.horizontal)
            }
            
            if appConfig.WidgetContentTemp == .f {
                CollerationReason(
                    reason: String(format: NSLocalizedString("Most pain at %lld °F", comment: ""), highestFahrenheit.highest ?? 0),
                    quality: convertToPercentage(value: abs(highestFahrenheit.correlation)),
                    image: "thermometer.low"
                )
                .saveSize(in: $tabSizeCorrelation)
                .show(convertToPercentage(value: abs(highestFahrenheit.correlation)) > 0)
                .padding(.horizontal)
            }
            
            CollerationReason(
                reason: String(format: NSLocalizedString("Most pain at %lld hPa", comment: ""), highestPressures.highest ?? 0),
                quality: convertToPercentage(value: abs(highestPressures.correlation)),
                image: "barometer"
            )
            .saveSize(in: $tabSizeCorrelation)
            .show(convertToPercentage(value: abs(highestPressures.correlation)) > 0)
            .padding(.horizontal)
            
            CollerationReason(
                reason: DayTime(rawValue: (highestTimes.highest ?? 6) - 1)?.timeString.localizedstring() ?? "",
                quality: convertToPercentage(value: abs(highestTimes.correlation)),
                image: DayTime(rawValue: (highestTimes.highest ?? 6) - 1)?.iconString ?? ""
            )
            .saveSize(in: $tabSizeCorrelation)
            .show(convertToPercentage(value: abs(highestTimes.correlation)) > 0)
            .padding(.horizontal)
            
        }
        .frame(height: tabSizeCorrelation.height + 80)
        .tabViewStyle(.page)
        .padding(.vertical, -20)
        .padding(.top, -20)
        .onAppear {
            HealthStoreProvider().getAverageDailySteps(days: 180) { averageSteps, error in
                if let averageSteps = averageSteps {
                    avgSteps = averageSteps
                }
            }
        }
    }
    
    func getSumOfCorrelation() -> Double {
        return abs(highestSteps.correlation + highestweather.correlation + highestCelsius.correlation + highestFahrenheit.correlation + highestPressures.correlation + highestTimes.correlation)
    }
    
    
    private func getStepLevel(avg: Double, correlationSteps: Double) -> LocalizedStringKey {
        guard avg != 0 || correlationSteps != 0 else { return "low" }
        
        let percent = 100 / avg * correlationSteps
        
        let localizedString: LocalizedStringKey
           
       if percent > 50 {
           localizedString = LocalizedStringKey("Most pain with high activity")
       } else {
           localizedString = LocalizedStringKey("Most pain with low activity")
       }
       
       return localizedString
    }
    
    @ViewBuilder func CollerationReason(reason: String, quality: Int, image: String? = nil) -> some View {
        HStack {
            Image(systemName: image ?? "sparkles")
                .font(.title)
                .foregroundColor(currentTheme.hightlightColor)
             
            Spacer(minLength: 2)
            
            VStack(spacing: 10) {
                HStack {
                    Spacer()
                    Text(LocalizedStringKey(reason))
                        .font(.footnote.bold())
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(currentTheme.text)
                }
                
                HStack(spacing: 10) {
                    Spacer()
                    Text(LocalizedStringKey("Your pain has a connection of \(quality) %."))
                        .font(.system(size: 10))
                        .foregroundColor(currentTheme.textGray)
                        .multilineTextAlignment(.trailing)
                        .foregroundColor(currentTheme.text)
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial.opacity(0.5))
        .cornerRadius(15)
    }
    
    
    @State var highestSteps:(correlation: Double, highest: Int?, count: Int) = (correlation: 0.0, highest: 0, count: 0)
    @State var highestweather:(correlation: Double, highest: Int?, count: Int) = (correlation: 0.0, highest: 0, count: 0)
    @State var highestCelsius:(correlation: Double, highest: Int?, count: Int) = (correlation: 0.0, highest: 0, count: 0)
    @State var highestFahrenheit:(correlation: Double, highest: Int?, count: Int) = (correlation: 0.0, highest: 0, count: 0)
    @State var highestPressures:(correlation: Double, highest: Int?, count: Int) = (correlation: 0.0, highest: 0, count: 0)
    @State var highestTimes:(correlation: Double, highest: Int?, count: Int) = (correlation: 0.0, highest: 0, count: 0)
    
    func calculateCorrelations() -> [PainCorrelation] {
        var correlations = [PainCorrelation]()

        let fetchRequest: NSFetchRequest<Pain> = Pain.fetchRequest()

        do {
            let context = PersistenceController.shared.container.viewContext
            let allPains = try context.fetch(fetchRequest)
            
            // Arrays für die verschiedenen Variablen
            var painIndices = [Double]()
            var stepCounts = [Double]()
            var temperaturesCelsius = [Double]()
            var temperaturesFahrenheit = [Double]()
            var pressures = [Double]()
            var weathers = [Double]()
            var times = [Double]()
            
            // Daten aus Core Data extrahieren
            for pain in allPains {
                painIndices.append(Double(pain.painIndex))
                stepCounts.append(pain.stepCount)
                temperaturesCelsius.append(pain.tempC)
                temperaturesFahrenheit.append(pain.tempF)
                pressures.append(pain.pressureMb)
                weathers.append(Double(extractImageNumber(imagePath: pain.conditionIcon ?? "").number ?? 0))
                times.append(determineDayTime(for: pain.date ?? Date()))
            }
            
            // Korrelationskoeffizienten berechnen
            let painIndexCorrelation = pearsonCorrelation(painIndices, painIndices)
            let stepCountCorrelation = pearsonCorrelation(painIndices, stepCounts)
            let temperaturesCelsiusCorrelation = pearsonCorrelation(painIndices, temperaturesCelsius)
            let temperaturesFahrenheitCorrelation = pearsonCorrelation(painIndices, temperaturesFahrenheit)
            let pressureCorrelation = pearsonCorrelation(painIndices, pressures)
            let weatherCorrelation = pearsonCorrelation(painIndices, weathers)
            let timeCorrelation = pearsonCorrelation(painIndices, times)
            
            // Ergebnisse speichern
            correlations.append(PainCorrelation(type: .pain, variableName: "Pain Index", comparison: "Pain vs. Pain", correlationCoefficient: painIndexCorrelation))
            correlations.append(PainCorrelation(type: .step, variableName: "Step Count", comparison: "Pain vs. Steps", correlationCoefficient: stepCountCorrelation))
            correlations.append(PainCorrelation(type: .waether, variableName: "Weather", comparison: "Pain vs. Weather", correlationCoefficient: weatherCorrelation))
            correlations.append(PainCorrelation(type: .tempC, variableName: "Temperature Celsius", comparison: "Pain vs. Temperature Celsius", correlationCoefficient: temperaturesCelsiusCorrelation))
            correlations.append(PainCorrelation(type: .tempF, variableName: "Temperature Fahrenheit", comparison: "Pain vs. Temperature Fahrenheit", correlationCoefficient: temperaturesFahrenheitCorrelation))
            correlations.append(PainCorrelation(type: .pressure, variableName: "Pressure", comparison: "Pain vs. Pressure", correlationCoefficient: pressureCorrelation))
            correlations.append(PainCorrelation(type: .times, variableName: "Time", comparison: "Pain vs. Time", correlationCoefficient: timeCorrelation))
            
            highestSteps = (correlation: stepCountCorrelation, highest: findWithHighestCorrelation(painLevels: painIndices, compared: stepCounts, correlation: stepCountCorrelation), count: stepCounts.count)
            highestweather = (correlation: weatherCorrelation, highest: findWithHighestCorrelation(painLevels: painIndices, compared: weathers, correlation: weatherCorrelation), count: weathers.count)
            highestCelsius = (correlation: temperaturesCelsiusCorrelation, highest: findWithHighestCorrelation(painLevels: painIndices, compared: temperaturesCelsius, correlation: temperaturesCelsiusCorrelation), count: temperaturesCelsius.count)
            highestFahrenheit = (correlation: temperaturesFahrenheitCorrelation, highest: findWithHighestCorrelation(painLevels: painIndices, compared: temperaturesFahrenheit, correlation: temperaturesFahrenheitCorrelation), count: temperaturesFahrenheit.count)
            highestPressures = (correlation: pressureCorrelation, highest: findWithHighestCorrelation(painLevels: painIndices, compared: pressures, correlation: pressureCorrelation), count: pressures.count)
            highestTimes = (correlation: timeCorrelation, highest: findWithHighestCorrelation(painLevels: painIndices, compared: times, correlation: timeCorrelation), count: times.count)
            
        } catch {
            print("Failed to fetch pain data: \(error.localizedDescription)")
        }

        return correlations
    }
    
    func describeCorrelation(correlationCoefficient: Double) -> String { // https://studyflix.de/statistik/korrelationskoeffizient-2290
        if correlationCoefficient == 1.0 {
            return "Es besteht eine perfekte positive Zusammenhänge."
        } else if correlationCoefficient == -1.0 {
            return "Es besteht eine perfekte negative Zusammenhänge."
        } else if correlationCoefficient > 0.7 {
            return "Es besteht eine starke positive Zusammenhänge."
        } else if correlationCoefficient > 0.3 {
            return "Es besteht eine mäßige positive Zusammenhänge."
        } else if correlationCoefficient > -0.3 {
            return "Es besteht keine klare Zusammenhänge zwischen den Variablen."
        } else if correlationCoefficient > -0.7 {
            return "Es besteht eine mäßige negative Zusammenhänge."
        } else {
            return "Es besteht eine starke negative Zusammenhänge."
        }
    }
    
    func extractImageNumber(imagePath: String) -> (dayOrNigh: String?, number: Int?) {
        // Trenne den String nach "/"
        let components = imagePath.components(separatedBy: "/")
        
        var number: Int?
        var dayOrNigh: String?
        // Die Bildnummer ist der letzte Bestandteil des Pfads
        if let lastComponent = components.last, let imageNumber = Int(lastComponent.split(separator: ".").first ?? "") {
            number = imageNumber
        }
        
        if components.contains("day") {
            dayOrNigh = "d"
        } else if components.contains("night") {
            dayOrNigh = "n"
        }
        
        return (dayOrNigh: dayOrNigh ?? nil, number: number ?? nil)
    }
    
    func findWithHighestCorrelation(painLevels: [Double], compared: [Double], correlation: Double) -> Int? {
        guard painLevels.count == compared.count && !painLevels.isEmpty else {
            return nil  // Ensure valid input data
        }

        var maxCorrelation: Double = -1.0  // Initialize with a negative value
        var comparedWithMaxCorrelation: Int?

        for (_, comparedData) in compared.enumerated() {
           if correlation > maxCorrelation {
               maxCorrelation = correlation
               comparedWithMaxCorrelation = Int(comparedData)
           }
       }

       return comparedWithMaxCorrelation
    }
    
    func convertToPercentage(value: Double) -> Int {
        guard value >= 0.0 else { return 0 }
        
        guard value <= 1.0 else { return 100 }
        
        return Int(value * 100.0)
    }
}

struct ReasonRow: View {
    var reason: PainReason
    
    @EnvironmentObject var appConfig: AppConfig
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var googleInterstitial: GoogleInterstitialAd
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    @State var confirm = false
    @ObservedObject var vm: PainViewModel
    private let persistenceController = PersistenceController.shared
    
    var body: some View {
        HStack(spacing: 8){
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: "chart.bar.xaxis")
                    .font(.title.bold())
                    .foregroundColor(currentTheme.hightlightColor)
            }
            
            VStack(alignment: .leading, spacing: 8) {

                Text(LocalizedStringKey(reason.name ?? "")) // translateReasons(reason.name)
                    .font(.body.bold())
                
                let i = vm.dateFormatte(inputDate: reason.date ?? Date(), dateString: "dd.MM.yy", timeString: "HH:mm")
                Text(i.date + " " + i.time)
                    .font(.caption2)
                    .foregroundColor(currentTheme.textGray)
            }
            
            Spacer()
            let arr = [LocalizedStringKey("weather"), LocalizedStringKey("cold"), LocalizedStringKey("warmth"), LocalizedStringKey("No Reason")]
            if !arr.contains(LocalizedStringKey(reason.name ?? "Unknown Name"))  {
                Image(systemName: "trash")
                    .onTapGesture{
                        confirm = true
                    }
            }
        }
        .foregroundColor(currentTheme.text)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
        .confirmationDialog("Delete reason?", isPresented: $confirm) {
            let i = vm.dateFormatte(inputDate: reason.date ?? Date(), dateString: "dd.MM.yy", timeString: "HH:mm")
            Button("Delete \(reason.name ?? "")?", role: .destructive) {
                withAnimation {
                    persistenceController.container.viewContext.delete(reason)
                    do {
                        try persistenceController.container.viewContext.save()
                        vm.deletePainReason = nil
                    } catch {
                        print("Reason deleted from \(i.date) \(i.time)! ")
                    }
                    
                    // Show InterstitialSheet if not Pro
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        googleInterstitial.showAd()
                    })
                }
            }
            .font(.callout)
        } // Confirm
    }
}

struct DrugRow: View {
    var drug: PainDrug
    
    @EnvironmentObject var appConfig: AppConfig
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var googleInterstitial: GoogleInterstitialAd
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    @State var confirm = false
    @ObservedObject var vm: PainViewModel
    private let persistenceController = PersistenceController.shared
    
    var body: some View {
        HStack(spacing: 8){
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: "pills.fill")
                    .font(.title.bold())
                    .foregroundColor(currentTheme.hightlightColor)
            }
            
            VStack(alignment: .leading, spacing: 8) {
                if let p = drug.name {
                    Text(LocalizedStringKey(p)) // translateReasons(p)
                        .font(.body.bold())
                }
                
                
                let i = vm.dateFormatte(inputDate: drug.date ?? Date(), dateString: "dd.MM.yy", timeString: "HH:mm")
                Text(i.date + " " + i.time)
                    .font(.caption2)
                    .foregroundColor(currentTheme.textGray)
            }
            
            Spacer()
            
            if drug.name! != "No Painkiller" {
                VStack(alignment: .trailing, spacing: 8) {
                    Image(systemName: "trash")
                        .onTapGesture {
                            confirm = true
                        }
                    
                }
            }
            
        }
        .foregroundColor(currentTheme.text)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
        .confirmationDialog("Delete painkillers?", isPresented: $confirm) {
            let i = vm.dateFormatte(inputDate: drug.date ?? Date(), dateString: "dd.MM.yy", timeString: "HH:mm")
            Button("Delete \(drug.name ?? "")?", role: .destructive) {
                withAnimation {
                    persistenceController.container.viewContext.delete(drug)
                    do {
                        try persistenceController.container.viewContext.save()
                        vm.deletePainDrug = nil
                    } catch {
                        print("Reason deleted from \(i.date) \(i.time)! ")
                    }
                    
                    // Show InterstitialSheet if not Pro
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        googleInterstitial.showAd()
                    })
                }
            }
            .font(.callout)
        } // Confirm
    }
}

struct PainRow: View {
    var pain: Pain
    
    @EnvironmentObject var appConfig: AppConfig
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var googleInterstitial: GoogleInterstitialAd
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    @State var confirm = false
    @ObservedObject var vm: PainViewModel
    private let persistenceController = PersistenceController.shared
    
    
    var body: some View {
        HStack(spacing: 8){
            
            
            NavigateTo({
                HStack(spacing: 8) {
                    VStack(alignment: .leading, spacing: 8) {
                        Image(systemName: "bolt.fill")
                            .font(.title.bold())
                            .foregroundColor(currentTheme.hightlightColor)
                    }
                    VStack(alignment: .leading, spacing: 8) {
                        
                        HStack {
                            Text("\(Int(pain.painIndex)) pain index")
                                .font(.body.bold())
                        }
                        
                        let i = vm.dateFormatte(inputDate: pain.date ?? Date(), dateString: "dd.MM.yy", timeString: "HH:mm")
                        Text(i.date + " " + i.time)
                            .font(.caption2)
                            .foregroundColor(currentTheme.textGray)
                    }
                }
            }, {
                PainDetailView(pain: pain)
            }, from: .pain)

            Spacer()
            
            HStack(alignment: .center, spacing: 15) {
                Image(systemName: "pencil")
                    .onTapGesture {
                        vm.isPainAddSheet.toggle()
                        vm.editPain = pain
                    }
                
                Image(systemName: "trash")
                    .onTapGesture {
                        confirm = true
                    }
            }
        }
        .foregroundColor(currentTheme.text)
        .padding()
        .background(.ultraThinMaterial)
        .cornerRadius(10)
        .frame(maxWidth: .infinity)
        .padding(.horizontal)
        .confirmationDialog("Delete entry", isPresented: $confirm) {
            let i = vm.dateFormatte(inputDate: pain.date ?? Date(), dateString: "dd.MM.yy", timeString: "HH:mm")
            Button("Delete \(pain.painIndex)?", role: .destructive) {
                withAnimation {
                    persistenceController.container.viewContext.delete(pain)
                    do {
                        try persistenceController.container.viewContext.save()
                        vm.deletePain = nil
                    } catch {
                        print("Reason deleted from \(i.date) \(i.time)! ")
                    }
                }
                
                // Show InterstitialSheet if not Pro
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    googleInterstitial.showAd()
                })
            }
            .font(.callout)
            
        } // Confirm
    }
}

struct PainDetailView: View {
    private var currentTheme: Theme {
        return ThemeManager().currentTheme()
    }
    
    var pain: Pain
    
    var painDateString: String {
        self.pain.date?.dateFormatte(date: "dd.MM.yyyy", time: "").date ?? ""
    }
    
    private var dynamicGrid: Int {
        return 2
    }
    
    @State var allProthesis:[ProthesenTimes] = []
    
    var body: some View {
        GeometryReader { geo in
            let size = geo.size.width
            
            ZStack {
                
                currentTheme.gradientBackground(nil).ignoresSafeArea()
                
                VStack {
                    FloatingClouds(speed: 1.0, opacity: 0.5, currentTheme: currentTheme)
                        .opacity(0.5).ignoresSafeArea()
                        .frame(height: geo.size.height / 3)
                    
                    Spacer()
                }
                
                
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        // MARK: - Page Header
                        Header("Pain from \(painDateString)")
                            .padding(.bottom)
                        
                        InfomationCards(size: size, spacing: 12)
                            .padding(.bottom)
                        
                        if allProthesis.count > 0 {
                            WearedCards(size: size, spacing: 12)
                                .padding(.bottom)
                        }
                        
                    }
                }
            }
        }
    }
    
    @ViewBuilder func Header(_ text: LocalizedStringKey) -> some View {
        HStack{
            Spacer()
            
            Text(text)
                .foregroundColor(currentTheme.text)
            
            Spacer()
        }
        .padding(.top, 25)
        .padding(.horizontal)
    }
    
    @ViewBuilder func InfomationCards(size: Double, spacing: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: spacing) {
            
            HStack {
                Text("Saved data")
                    .font(.footnote.bold())
                Spacer()
            }
            
            HStack(spacing: spacing) {
                // PAININDEX
                VStack(spacing: spacing) {
                    HStack {
                        Spacer()
                        Image(systemName: "bolt.fill")
                            .font(.title)
                            .foregroundColor(currentTheme.hightlightColor)
                            .padding(.trailing, 4)
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        Text("\(Int(pain.painIndex))")
                            .font(size < 400 ? .body : .headline).fontWeight(.bold)
                        Spacer()
                    }
                }
                .padding()
                .background(.ultraThinMaterial.opacity(0.4))
                .cornerRadius(15)
                
                // STEPS
                VStack(spacing: spacing) {
                    HStack {
                        Spacer()
                        Image("figure.steps")
                            .font(.title)
                            .foregroundColor(currentTheme.hightlightColor)
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        
                        if pain.stepCount != 0.0  {
                            Text("\(pain.stepCount.round(decimal: 0)) Steps")
                                .font(size < 400 ? .body : .headline).fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                        } else {
                            Text("No step data")
                                .font(size < 400 ? .body : .headline).fontWeight(.bold)
                                .multilineTextAlignment(.leading)
                        }
                        
                        Spacer()
                    }
                }
                .padding()
                .background(.ultraThinMaterial.opacity(0.4))
                .cornerRadius(15)
            }

            HStack(spacing: spacing) {
                // temp
                VStack(spacing: spacing) {
                    HStack {
                        Spacer()
                        
                        if let wetaherConditionIcon = pain.conditionIcon {
                            let image = extractImageNumber(imagePath: wetaherConditionIcon)
                            
                            if let day = image.dayOrNigh, let num = image.number {
                                Image("\(day)\(num)")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                        } else {
                            ZStack {
                                Image(systemName: "cloud.sun")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(currentTheme.hightlightColor)
                            }
                            .frame(width: 30, height: 30)
                        }
                        
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        if pain.conditionIcon != nil {
                            if AppConfig.shared.WidgetContentTemp == .c {
                                Text(pain.tempC.round(decimal: 0))
                                    .font(size < 400 ? .body : .headline).fontWeight(.bold)
                                    .italic()
                                
                                Text("°C")
                                    .font(.footnote.bold())
                                    .italic()
                                    .offset(y: -2)
                            } else {
                                Text(pain.tempF.round(decimal: 0))
                                    .font(size < 400 ? .body : .headline).fontWeight(.bold)
                                    .italic()
                                
                                Text("°F")
                                    .font(.footnote.bold())
                                    .italic()
                                    .offset(y: -2)
                            }
                        } else {
                            Text("No weather data")
                                .font(size < 400 ? .body : .headline).fontWeight(.bold)
                        }
                        
                        
                        
                        Spacer()
                    }
                }
                .padding()
                .background(.ultraThinMaterial.opacity(0.4))
                .cornerRadius(15)
                
                // pressureMb
                VStack(spacing: spacing) {
                    HStack {
                        Spacer()
                        
                        Image(systemName: "barometer")
                            .font(.title)
                            .foregroundColor(currentTheme.hightlightColor)
                            .padding(.trailing, 4)
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        if pain.pressureMb != 0 {
                            Text("\(pain.pressureMb.round(decimal: 2)) hPa")
                                .font(size < 400 ? .body : .headline).fontWeight(.bold)
                        } else {
                            Text("No pressure data")
                                .font(size < 400 ? .body : .headline).fontWeight(.bold)
                        }
                        Spacer()
                    }
                }
                .padding()
                .background(.ultraThinMaterial.opacity(0.4))
                .cornerRadius(15)
            }
            
            HStack(spacing: spacing) {
                // PROTHESE
                VStack(spacing: spacing) {
                    HStack {
                        Spacer()
                        
                        Image(.protheseBelow)
                            .font(.title)
                            .foregroundColor(currentTheme.hightlightColor)
                        
                        
                        Spacer()
                    }
                    
                    if pain.wearingAllProtheses != 0  {
                        HStack {
                            Spacer()
                            let (h,m,_) = Int(pain.wearingAllProtheses).secondsToHoursMinutesSeconds

                            if Int(pain.wearingAllProtheses) < 60 {
                                Text("00 hrs. 01 mins.")
                                    .font(size < 400 ? .body : .headline).fontWeight(.bold)
                            } else {
                                Text("\(h) hrs. \(m) mins.")
                                    .font(size < 400 ? .body : .headline).fontWeight(.bold)
                            }
                            
                            
                            Spacer()
                        }
                    } else {
                        HStack {
                            Spacer()
                            Text(LocalizedStringKey("No time"))
                                .font(size < 400 ? .body : .headline).fontWeight(.bold)
                            Spacer()
                        }
                    }
                    
                   
                }
                .padding()
                .background(.ultraThinMaterial.opacity(0.4))
                .cornerRadius(15)
                
                VStack(spacing: spacing) {
                    HStack {
                        Spacer()
                        
                        if let prothese = pain.prothese {
                            Image(prothese.prosthesisIcon)
                                .font(.title)
                                .foregroundColor(currentTheme.hightlightColor)
                        } else {
                            Image(.protheseBelow)
                                .font(.title)
                                .foregroundColor(currentTheme.hightlightColor)
                        }
                        
                        
                        Spacer()
                    }
                    
                    if let prothese = pain.prothese {
                        HStack {
                            Spacer()
                            Text(LocalizedStringKey(prothese.prosthesisKindString))
                                .font(size < 400 ? .body : .headline).fontWeight(.bold)
                            Spacer()
                        }
                    } else {
                        HStack {
                            Spacer()
                            Text(LocalizedStringKey("No prosthetic data"))
                                .font(size < 400 ? .body : .headline).fontWeight(.bold)
                            Spacer()
                        }
                    }
                    
                   
                }
                .padding()
                .background(.ultraThinMaterial.opacity(0.4))
                .cornerRadius(15)
            }
 
        }
        .foregroundColor(currentTheme.text)
        .transaction { transaction in
            transaction.animation = nil
        }
        .padding(.horizontal)
        .padding(.top)
        .onAppear(perform: {
            self.allProthesis = getAllProthesesWearedToday(date: pain.date)
        })
    }
    
    @ViewBuilder func WearedCards(size: Double, spacing: CGFloat) -> some View {
        VStack(alignment: .leading, spacing: spacing) {
            
            HStack {
                let d = pain.date ?? Date()
                Text("Prostheses worn on \(d.dateFormatte(date: "dd.MM.yy", time: "").date)")
                    .font(.footnote.bold())
                Spacer()
            }
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: dynamicGrid), spacing: spacing) {
                ForEach(allProthesis, id: \.id) { prothese in
                    
                    VStack(spacing: spacing) {
                        HStack {
                            Spacer()
                            Image(prothese.prothese.prosthesisIcon)
                                .font(.title)
                                .foregroundColor(currentTheme.hightlightColor)
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            
                            let (h,m,s) =  prothese.totalTime.secondsToHoursMinutesSeconds

                            Text("\(h) hrs. \(m) mins. \(s) sec.")
                                .font(size < 400 ? .caption2 : .caption).fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            
                            Spacer()
                        }
                        
                        HStack {
                            Spacer()
                            Text(prothese.prothese.prosthesisKindLineBreak).padding()
                                .font(size < 400 ? .body : .headline).fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .foregroundColor(currentTheme.text)
                            Spacer()
                        }
                    }
                    .padding()
                    .background(.ultraThinMaterial.opacity(0.4))
                    .cornerRadius(15)
                }
            }
 
        }
        .foregroundColor(currentTheme.text)
        .transaction { transaction in
            transaction.animation = nil
        }
        .padding(.horizontal)
        .padding(.top)
        .onAppear(perform: {
            self.allProthesis = getAllProthesesWearedToday(date: pain.date)
        })
    }
    
    private func extractImageNumber(imagePath: String) -> (dayOrNigh: String?, number: Int?) {
        // Trenne den String nach "/"
        let components = imagePath.components(separatedBy: "/")
        
        var number: Int?
        var dayOrNigh: String?
        // Die Bildnummer ist der letzte Bestandteil des Pfads
        if let lastComponent = components.last, let imageNumber = Int(lastComponent.split(separator: ".").first ?? "") {
            number = imageNumber
        }
        
        if components.contains("day") {
            dayOrNigh = "d"
        } else if components.contains("night") {
            dayOrNigh = "n"
        }
        
        return (dayOrNigh: dayOrNigh ?? nil, number: number ?? nil)
    }
    
    private func fetchWearingTimesForToday(date: Date) -> [WearingTimes] {
        var wearingTimes = [WearingTimes]()

        let fetchRequest: NSFetchRequest<WearingTimes> = WearingTimes.fetchRequest()

        // Heutiges Datum
        let today = Calendar.current.startOfDay(for: date)

        let predicate = NSPredicate(format: "(start >= %@) AND (start < %@ OR end <= %@)", today as NSDate, date as NSDate, date as NSDate)

        fetchRequest.predicate = predicate

        do {
            let context = PersistenceController.shared.container.viewContext
            wearingTimes = try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch wearing times: \(error.localizedDescription)")
        }

        return wearingTimes
    }
    
    private func getAllProthesesWearedToday(date: Date? = nil) -> [ProthesenTimes] {
        let wearingTimesForToday = self.fetchWearingTimesForToday(date: date ?? Date())
        var prothesen = [ProthesenTimes]()
        
        for wearingTime in wearingTimesForToday {
            let pro = wearingTime.prothese! as Prothese
            
            if !prothesen.contains(where: { $0.prothese == pro }) {
                
                let wearingTimesByProthese = wearingTimesForToday.filter({ $0.prothese! as Prothese == pro })
                
                let time = wearingTimesByProthese.count > 0 ? wearingTimesByProthese.map({ Int($0.duration) }).reduce(0, +) : 0
                
                prothesen.append(ProthesenTimes(prothese: pro, totalTime: time))
            }
        }
        
        print(prothesen)
        
        return prothesen
    }
}

struct ProthesenTimes {
    var id = UUID()
    var prothese: Prothese
    var totalTime: Int
}

struct PainChartData {
    var id = UUID()
    var avgPain: Int
    var reason: String
}

struct dynamicColor {
    var int: Int
    
    var render: some ShapeStyle {
        switch int {
            case 1: return Color.blue
            case 2: return Color.blue
            case 3: return Color.blue
            case 4: return Color.yellow
            case 5: return Color.yellow
            case 6: return Color.yellow
            case 7: return Color.orange
            case 8: return Color.orange
            case 9: return Color.red
            case 10: return Color.red
            default: return Color.black
        }
    }
}

struct BarView: View {
  var datum: Double
  var colors: [Color]

  var gradient: LinearGradient {
    LinearGradient(gradient: Gradient(colors: colors), startPoint: .top, endPoint: .bottom)
  }

  var body: some View {
    Rectangle()
      .fill(gradient)
      .opacity(datum == 0.0 ? 0.0 : 1.0)
  }
}

struct PainEntry_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Theme.blue.gradientBackground(nil).ignoresSafeArea()
            
            PainEntry()
                .environmentObject(MoodCalendar())
                .environmentObject(PainViewModel())
                .environmentObject(TabManager())
                .environmentObject(EntitlementManager())
                .colorScheme(.dark)
        }
    }
}









struct PainCorrelation {
    let id = UUID()
    let type: PainCorrelationType
    let variableName: String
    let comparison: String
    let correlationCoefficient: Double
}

enum PainCorrelationType {
    case step
    case tempF
    case tempC
    case pressure
    case waether
    case pain
    case times
}

