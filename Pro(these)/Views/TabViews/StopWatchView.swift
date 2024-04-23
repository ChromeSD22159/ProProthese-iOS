//
//  WorkOutEntryView.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 19.05.23.
//

import SwiftUI
import CoreData

struct StopWatchView: View {
    @StateObject var stopWatchProvider = StopWatchProvider()
    @StateObject var tabManager = TabManager()
    @StateObject var workoutStatisticViewModel = WorkoutStatisticViewModel()
    
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var appConfig: AppConfig
    @EnvironmentObject var entitlementManager: EntitlementManager
    @EnvironmentObject var location: LocationProvider
    
    @State var ishasProFeatureSheet = false
    
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    
    private var viewport: CGRect {
        UIScreen.main.bounds
    }

    var body: some View {
        ZStack{
            currentTheme.radialBackground(unitPoint: nil, radius: nil).ignoresSafeArea()
            
            VStack(spacing: 20){
                GeometryReader { proxy in
                    ScrollView(.vertical, showsIndicators: false, content: {
                        VStack(spacing: 10) {
                            AnimatedHeader()
                            
                            TempLocaltionRow()
                                .padding(.top, 25)
                            
                            Spacer(minLength: viewport.height / 10 * 4.5)
                            
                            StopWatchRecordView()
                                .padding(.horizontal)
                                .environmentObject(stopWatchProvider)
                        }
                    })
                    .frame(maxWidth: .infinity, minHeight: proxy.size.height)
                    .coordinateSpace(name: "SCROLL")
                    .ignoresSafeArea(.container, edges: .vertical)
                    .fullScreenCover(isPresented: $ishasProFeatureSheet, content: {
                        ShopSheet(isSheet: $ishasProFeatureSheet)
                    })
                }
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

    @ViewBuilder func TempLocaltionRow() -> some View {
        HStack {
            if location.city != "" || location.city != "" {
                HStack {
                    Label(location.city, systemImage: "location.fill")
                        .font(.headline.bold())
                }
            }
          
            Spacer()
            
            if networkMonitor.isConnected {
                HStack(spacing: 5) {
                    let image = extractImageNumber(imagePath: HandlerStates.shared.weatherConditionIcon)
                    
                    if let day = image.dayOrNigh, let num = image.number {
                        Image("\(day)\(num)")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    
                    if AppConfig.shared.WidgetContentTemp == .c {
                        Text(HandlerStates.shared.weatherTempC.round(decimal: 0))
                            .font(.title.bold())
                            .italic()
                        
                        Text("°C")
                            .font(.footnote.bold())
                            .italic()
                            .offset(y: -5)
                    } else {
                        Text(HandlerStates.shared.weatherTempC.round(decimal: 0))
                            .font(.title.bold())
                            .italic()
                        
                        Text("°F")
                            .font(.footnote.bold())
                            .italic()
                            .offset(y: -5)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder func WelcomeHeader() -> some View {
        HStack(){
            VStack(spacing: 2) {
                sayHallo(name: AppConfig.shared.username)
                    .font(.title2)
                    .foregroundColor(currentTheme.text)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Your daily goal for today is \(AppConfig.shared.targetSteps) steps.")
                    .font(.caption2)
                    .foregroundColor(currentTheme.textGray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            HStack(spacing: 20){
                if !AppConfig.shared.hasPro {
                    Image(systemName: "trophy.fill")
                        .foregroundColor(currentTheme.text)
                        .font(.title3)
                        .onTapGesture {
                            DispatchQueue.main.async {
                                ishasProFeatureSheet.toggle()
                            }
                        }
                }

                NavigateTo({
                    Image(systemName: "circle.circle")
                        .foregroundColor(currentTheme.text)
                        .font(.title3)
                        .fontWeight(.bold)
                }, {
                    WorkOutEntryView()
                }, from: .stopWatch)
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 30)
        .frame(maxWidth: .infinity)
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
}

struct StopWatchRecordView: View {
    @EnvironmentObject var stopWatchProvider: StopWatchProvider
    @EnvironmentObject var tabViewManager: TabManager
    @EnvironmentObject var appConfig: AppConfig
    @EnvironmentObject var stateManager: StateManager
    @EnvironmentObject var googleInterstitial: GoogleInterstitialAd
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var motion: MotionManager
    
    
    @State var recorderState = false
    
    @State var protheseIcon = "rectangle.portrait.slash"
    
    @FetchRequest var allProthesis: FetchedResults<Prothese>
    
    init() {
        _allProthesis = FetchRequest<Prothese>(
            sortDescriptors: []
        )
    }
    
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    
    var viewport: CGRect {
        UIScreen.main.bounds
    }
    
    var body: some View {
        ZStack {

            VStack {
                
                Spacer()
                /*
                HStack {
                    Spacer()
                    Text("Floors: \(motion.floors)")
                    Spacer()
                    if motion.isWalking {
                       Text("Walking")
                    } else {
                       Text("Not walking")
                    }
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    Text("CurrentPage \(motion.currentPace)")
                    Spacer()
                    Text("AverageActivePace: \(motion.averageActivePace)")
                    Spacer()
                }
                 */
                
                HStack{
                    Spacer()
                    
                    
                    Text(AppConfig.shared.recorderTimer, style: .timer)
                        .font(.system(size: 50))
                        .italic()
                        .fontWeight(.bold)
                        .fontWeight(.medium)
                        .foregroundColor(currentTheme.text)
                        .opacity(AppConfig.shared.recorderState == .started ? 1 : 0)
                    
                    Spacer()
                }
          
                HStack(spacing: 15){
                    
                    LiveActivitySwitch()
                   
                    Text( AppConfig.shared.recorderState == .started ? "END" : "START" )
                        .font(Font.system(size: 20))
                        .italic()
                        .fontWeight(.bold)
                        .foregroundColor(currentTheme.textBlack)
                        .frame(width: 75, height: 75)
                        .background(
                           Circle()
                               .fill(currentTheme.hightlightColor)
                                .frame(width: 75, height: 75)
                        )
                        .onTapGesture {
                            stopWatchProvider.toggleTimer()
                        }
                    
                    ProthesesSwitch()
               }
                .padding(.bottom, 30)
            }
            .onAppear{                
                stateManager.paired = stateManager.session.isPaired
            }
            .onChange(of: stateManager.paired, perform: { state in
                if state == true {
                    print("watch is avaible")
                }
            })
            .onChange(of: stateManager.state, perform: { state in
                if state == false {
                    self.recorderState = false
                }
            })
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    @ViewBuilder func LiveActivitySwitch() -> some View {
        Menu(content: {
            Button(action: {
                appConfig.showLiveActivity = true
            }, label: {
                HStack {
                    Text("Show")
                    Spacer()
                    Image(systemName: "location")
                }
            })
            
            Button(action: {
                appConfig.showLiveActivity = false
            }, label: {
                HStack {
                    Text("Don't Show")
                    Spacer()
                    Image(systemName: "location.slash")
                }
            })
            
            Text("View your prosthesis timer on your lock screen and Dynamic Island.")
                .foregroundColor(currentTheme.textGray)
                .font(.system(size: 8))
        }, label: {
            Image(systemName: appConfig.showLiveActivity ? "location" : "location.slash")
                .font(.system(size: 25))
                .foregroundColor(currentTheme.textBlack)
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(currentTheme.hightlightColor)
                        .frame(width: 50, height: 50)
                )
        })
    }
    
    
    
    @ViewBuilder func ProthesesSwitch() -> some View {
        Menu(content: {
            ForEach(self.allProthesis.reversed()) { prothese in
                Button(action: {
                    AppConfig.shared.selectedProtheseString = prothese.prosthesisKind.localizedstring()
                    AppConfig.shared.selectedProtheseIcon = prothese.kind ?? ""
                    AppConfig.shared.selectedProtheseKind = prothese.kind ?? "" // Waterproof
                    AppConfig.shared.selectedProtheseType = prothese.type ?? "" // Below knee Prothesis
                }, label: {
                    Image(systemName: prosthesisKindIcon(string: prothese.kind ?? "") )
                    Text(prothese.prosthesisKind)
                })
            }
            
            Text("Select a prostheses for which you want to start the timer.")
                .foregroundColor(currentTheme.textGray)
                .font(.system(size: 8))
        }, label: {
            if appConfig.selectedProtheseString == "" {
                Image(systemName: "rectangle.portrait.slash")
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(currentTheme.textBlack)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(currentTheme.hightlightColor)
                            .frame(width: 50, height: 50)
                    )
            } else {
                
                ZStack {
                    Image(systemName: protheseIcon )
                        .font(.system(size: 25, weight: .bold))
                        .foregroundStyle(currentTheme.textBlack, currentTheme.textGray)
                        .flipHorizontal()
                }
                .frame(width: 50, height: 50)
                .background(
                    Circle()
                        .fill(currentTheme.hightlightColor)
                        .frame(width: 50, height: 50)
                )
                
            }
            
        })
        .onChange(of: AppConfig.shared.selectedProtheseIcon, perform: { new in
            print("newImage!!")
            protheseIcon = prosthesisKindIcon(string: new)
        })
        .onAppear{
            
            protheseIcon = prosthesisKindIcon(string: AppConfig.shared.selectedProtheseIcon)
            
            guard appConfig.selectedProtheseString == "" else {
                print("allProthesis already set")
                return
            }
            
            guard allProthesis.first?.prosthesisKind.localizedstring() != nil else {
                print("allProthesis first hast no kind")
                return
            }
            
            guard allProthesis.count != 0 else {
                print("allProthesis is empty")
                appConfig.selectedProtheseString = ""
                appConfig.selectedProtheseKind = ""
                appConfig.selectedProtheseType = ""
                return
            }
            
            appConfig.selectedProtheseString = (allProthesis.first?.kind)!
            appConfig.selectedProtheseKind = (allProthesis.first?.kind)!
            appConfig.selectedProtheseType = (allProthesis.first?.type)!
        }
    }
    
    private func prosthesisKindIcon(string: String) -> String {
        print("prosthesisKindIcon \(string)")
        switch string {
        case "Everyday" : return "sun.min"
        case "Waterproof" : return "drop.degreesign"
        case "Replacement" : return "arrow.triangle.2.circlepath"
        case "Sport" : return "figure.run"
        case "Sports" : return "figure.run"
        case "No Kind" : return "rectangle.portrait.slash"
        default:
            return "rectangle.portrait.slash"
        }
    }
}
