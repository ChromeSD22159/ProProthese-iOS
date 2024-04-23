//
//  TabStack.swift
//  Pro Prothese
//
//  Created by Frederik Kohler on 23.04.23.
//

import SwiftUI
import WidgetKit

struct TabStack: View {
    @Namespace var TabbarAnimation
    @Environment(\.scenePhase) var scenePhase
    @EnvironmentObject private var tabManager: TabManager
    @EnvironmentObject var cal: MoodCalendar
    @EnvironmentObject var event: EventManager
    @EnvironmentObject var pain: PainViewModel
    @EnvironmentObject var wsvm: WorkoutStatisticViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var googleInterstitial: GoogleInterstitialAd
    @EnvironmentObject var handlerState: HandlerStates
    @EnvironmentObject var stateManager: StateManager
    
    @StateObject var stopWatchProvider = StopWatchProvider()
    @State private var protheseAlert = false
    @Binding var deepLink:URL?
    
    @Binding var activeTab:Tab
    @Binding var activeSubTab:SubTab
    @Binding var showSubTab:Bool

    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    
    var combinedProthesisStrings: [String] {
        var combinedProthesisStrings: [String] = []

        prothesis.allTypesForButton.forEach { proType in
            prothesis.allKindsForButton.forEach { proKind in
                if proType != "" {
                    combinedProthesisStrings.append("\( proType )&\(proKind)")
                }
            }
        }
        
        return combinedProthesisStrings
    }
    
    // ADDFEELING
    @State var isFeelingSheet = false
    @State var isPainSheet = false
    @State var isShopSheet = false
    
    @FetchRequest(sortDescriptors: []) var allProthesis: FetchedResults<Prothese>
    
    var body: some View {
        ZStack {
            // SubTab
            HStack(spacing: 20) {
                Image(systemName: SubTab.feeling.TabIcon())
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(activeSubTab == .feeling ? .yellow : .yellow.opacity(0.8))
                    .frame(width: 28, height: 28)
                    .onTapGesture{
                        haptic()
                        AddFeeling()
                    }
                
                Image(systemName: SubTab.stopWatch.TabIcon())
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(activeSubTab == .stopWatch ? .yellow : .yellow.opacity(0.8))
                    .frame(width: 28, height: 28)
                    .offset(y: -20)
                    .onTapGesture{
                        haptic()
                        self.showSubTab = false
                        self.activeTab = .stopWatch
                        stopWatchProvider.toggleTimer()
                    }
                
                Image(systemName: SubTab.pain.TabIcon())
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(activeSubTab == .pain ? .yellow : .yellow.opacity(0.8))
                    .frame(width: 28, height: 28)
                    .offset(y: -20)
                    .onTapGesture{
                        haptic()
                        AddPain()
                    }
                
                Image(systemName: SubTab.event.TabIcon())
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(activeSubTab == .event ? .yellow : .yellow.opacity(0.8))
                    .frame(width: 28, height: 28)
                    .onTapGesture{
                        haptic()
                        newEvent(eventManager: event, showSubTab: $showSubTab, activeTab: $activeTab)
                    }
            }
            .padding(.bottom)
            .opacity(showSubTab ? 1 : 0)
            .offset(y: showSubTab ? -70 : 100)
            
            // MainTab
            HStack(spacing: 6){
                ForEach(Tab.allCases, id: \.self){ tab in
                    
                    if tab != .ignore {
                        VStack {
                            if tab == .add {
                                ZStack{
                                    Circle()
                                        .fill(LinearGradient(colors: [currentTheme.text.opacity(1), currentTheme.text.opacity(0.15), currentTheme.text.opacity(0.05)], startPoint: .top, endPoint: .bottom))
                                        .background{
                                            
                                        }
                                        .frame(width: 45, height: 45)
                                    
                                    Circle()
                                        .fill(currentTheme.hightlightColor)
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: tab.TabIcon())
                                        .renderingMode(.template)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .foregroundColor(.black)
                                        .frame(width: 20, height: 20)
                                }
                                .offset(y: tab == .add ? -20 : 0 )
                            } else {
                                Image(systemName: tab.TabIcon())
                                    .renderingMode(.template)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .foregroundColor(activeTab == tab ? .white : .white.opacity(0.8))
                                    .frame(width: 20, height: 20)
                            }
                            
                            if activeTab == tab {
                                Circle()
                                    .fill(.white)
                                    .frame(width:5, height: 5)
                                    .offset(y: 10)
                                    .matchedGeometryEffect(id: "TAB", in: TabbarAnimation)
                            }
                        }
                        .onTapGesture {
                            haptic()
                            
                            // Add Button
                            if tab == .add {
                                withAnimation(.easeInOut(duration: 0.3)){
                                    showSubTab.toggle()
                                }
                            } else if tab == .home {
                                withAnimation(.easeInOut(duration: 0.3)){
                                    activeTab = tab
                                    showSubTab = false
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now()) {
                                    tabManager.workoutTab = .statistic
                                    cal.isCalendar = true
                                    wsvm.currentDay = Date()
                                }
                            } else {
                                withAnimation(.easeInOut(duration: 0.3)){
                                    activeTab = tab
                                    showSubTab = false
                                }
                            }
                            
                            
                            if googleInterstitial.tabGuard {
                                googleInterstitial.showAd()
                            }
                            
                        }
                    }
                    
                   
                }
                .frame(maxWidth: .infinity)
                
                NavigateTo({ EmptyView() }, { LinerOverview() }, from: .home , extern: true, isExtern: handlerState.$isLinerSheetPresentedByNotification)
                    .hidden()
                
            }
            .frame(maxWidth: .infinity)
            .padding(10)
        }
        .sheetModifier(isSheet: $isFeelingSheet, sheetContent: {
            AddFeelingSheetBody(editFeeling: nil, calDate: Date(), isFeelingSheet: $isFeelingSheet)
        }, dismissContent: {})
        .sheetModifier(isSheet: $isPainSheet, sheetContent: {
            PainAddSheet(isSheet: $isPainSheet, entryDate: Date())
        }, dismissContent: {})
        .sheetModifier(backgroundAnimation: false, isSheet: $isShopSheet, sheetContent: {
            ShopSheet(isSheet: $isShopSheet)
        }, dismissContent: {})
        
        
        .sheetModifier(isSheet:  handlerState.$isPainSheetPresentedByNotification, sheetContent: {
            PainAddSheet(isSheet: handlerState.$isPainSheetPresentedByNotification, entryDate: Date())
        }, dismissContent: {
            DispatchQueue.main.async {
                activeTab = .pain
                print("NEW TAB: \(activeTab)")
            }
        })
        .sheetModifier(isSheet: handlerState.$isMoodSheetPresentedByNotification, sheetContent: {
            AddFeelingSheetBody(editFeeling: nil, calDate: Date(), isFeelingSheet: handlerState.$isMoodSheetPresentedByNotification )
        }, dismissContent: {
            DispatchQueue.main.async {
                activeTab = .feeling
                print("NEW TAB: \(activeTab)")
            }
        })
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .inactive {
                self.showSubTab = false
                cal.isFeelingSheet = false
                pain.isPainAddSheet = false
            } else if newPhase == .background {
                self.showSubTab = false
                cal.isFeelingSheet = false
                pain.isPainAddSheet = false
            } else if newPhase == .active {
                if deepLink == nil {
                    // FIXME: ENTRY
                    //activeTab = AppConfig.shared.entrySite
                    //activeTab = .home
                    
                    //print("newPhase == .active || activeTab = .home")
                }
            }
        }
        .onChange(of: AppConfig.shared.recorderState) { state in
            if state == .notStarted {
                stopWatchProvider.endTimer()
            }
        }
        .onOpenURL(perform: { url in
            if let EntryLink = url.tabAction {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: {
                    
                    print("[tabstack] DeepLink: \(EntryLink)")
                    
                    if EntryLink == "showFeeling" {
                        withAnimation(.easeInOut(duration: 0.8)){
                            self.showSubTab = false
                            self.activeTab = .feeling
                        }
                    } else if EntryLink == "addFeeling" {
                        isFeelingSheet = true
                    } else if EntryLink == "addPain" {
                        AddPain()
                    } else if EntryLink == "stopWatch" {
                        if self.activeTab != .stopWatch {
                            self.showSubTab = false
                            self.activeTab = .stopWatch
                        }
                    } else if EntryLink == "stopWatchToggle" {
                        
                        stopWatchProvider.toggleTimer()
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            if activeTab != .stopWatch {
                                self.showSubTab = false
                                self.activeTab = .stopWatch
                            }
                        })
                    } else if EntryLink == "statisticSteps" || EntryLink == "statisticWorkout" {
                        withAnimation(.easeInOut(duration: 0.3)){
                            self.showSubTab = false
                            self.activeTab = .home
                        }
                    } else if EntryLink == "getPro" {
                        isShopSheet = true
                        self.showSubTab = false
                    }
                    
                    
                    
                    let _ = combinedProthesisStrings.map({ prothesisString in
                        if let (type, kind) = splitProthesisString(prothesisString) {
                            
                            if EntryLink == "\(formatProthesisStringAddUnderline(type))&\(formatProthesisStringAddUnderline(kind))" {
                                
                                print("BFC: \(AppConfig.shared.selectedProtheseIcon), \(kind)")
                                
                                if activeTab != .stopWatch {
                                    self.showSubTab = false
                                    self.activeTab = .stopWatch
                                }
                                
                                let found = allProthesis.filter { prothesis in
                                    prothesis.kind == isSportString( kind )  && prothesis.type == type
                                }.count
                                
                                if found != 0 {
                                    AppConfig.shared.selectedProtheseString = kind
                                    AppConfig.shared.selectedProtheseIcon = kind
                                    AppConfig.shared.selectedProtheseKind = kind
                                    AppConfig.shared.selectedProtheseType = type
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                        stopWatchProvider.toggleTimer()
                                    })
                                } else {
                                    protheseAlert.toggle()
                                }
                                
                                
                            }
                        }
                    })
                    
                })
            }
        })
        .alert("No prosthesis found", isPresented: $protheseAlert) {
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("The timer for your prosthesis could not be started!")
        }
        .borderGradient(
            width: 1,
            edges: [.top],
            linearGradient:
                LinearGradient(
                    colors: [currentTheme.text.opacity(0.5), currentTheme.text.opacity(0.05), currentTheme.text.opacity(0.05), currentTheme.text.opacity(0.5)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
        )
    }
    
    func parseProthesisString(_ prothesisString: String) -> (type: String, kind: String)? {
        // Trenne den String bei "&"
        let components = prothesisString.components(separatedBy: "&")
        
        // Überprüfe, ob die Komponenten vorhanden und in der erwarteten Anzahl sind
        guard components.count == 2 else {
            return nil
        }
        
        // Extrahiere die Teile und gib ein Tupel zurück
        let type = components[0]
        let kind = components[1]
        
        return (kind: kind, type: type)
    }
    
    func splitProthesisString(_ inputString: String) -> (type: String, kind: String)? {
        // Trenne den String bei "&"
        let components = inputString.components(separatedBy: "&")
        
        // Überprüfe, ob die Komponenten vorhanden und in der erwarteten Anzahl sind
        guard components.count == 2 else {
            return nil
        }
        
        // Extrahiere die Teile und gib ein Tupel zurück
        let type = components[0]
        let kind = components[1]
        
        return (type: type, kind: kind)
    }
    
    func formatProthesisStringAddUnderline(_ inputString: String) -> String {
        // Ersetze Leerzeichen durch Unterstriche
        let formattedString = inputString.replacingOccurrences(of: " ", with: "_")
        return formattedString
    }
    
    func prosthesisKindIcon(string: String) -> String {
        switch string {
        case "Everyday" : return "sun.max"
        case "Waterproof" : return "drop.degreesign"
        case "Replacement" : return "arrow.triangle.2.circlepath"
        case "Sport" : return "figure.run"
        case "Sports" : return "figure.run"
        case "No Kind" : return "rectangle.portrait.slash"
        default:
            return "rectangle.portrait.slash"
        }
    }
    
    func isSportString(_ inputString: String) -> String {
        return inputString.lowercased() == "sport" || inputString.lowercased() == "sports" ? "Sport" : inputString
    }
    
    /* NEW TESTED WORKS*/ private func AddFeeling() {
        withAnimation(.easeInOut(duration: 0.8)){
            self.showSubTab = false
            self.activeTab = .feeling
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            isFeelingSheet = true
        }
    }
    
    /* NEW */ private func AddPain() {
        withAnimation(.easeInOut(duration: 0.8)){
            self.showSubTab = false
            self.activeTab = .pain
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            isPainSheet = true
        }
    }

    /* OLD */ func newFeeling(moodCalendar: MoodCalendar, tabManager: TabManager, showSubTab: Binding<Bool>, activeTab: Binding<Tab>){
        tabManager.workoutTab = .feelings
        withAnimation(.easeInOut(duration: 0.8)){
            self.showSubTab = false
            self.activeTab = .feeling
            moodCalendar.isCalendar = true
            moodCalendar.addFeelingDate = Date()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            moodCalendar.isFeelingSheet = true
        }
    }
    
    /* OLD */ func newPain(painViewModel: PainViewModel, showSubTab: Binding<Bool>, activeTab: Binding<Tab>) {
        withAnimation(.easeInOut(duration: 0.8)){
            self.showSubTab = false
            self.activeTab = .pain
            painViewModel.showList = true
            painViewModel.addPainDate = Date()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            painViewModel.isPainAddSheet = true
        }
    }
    
    /* OLD */ func newEvent(eventManager: EventManager, showSubTab: Binding<Bool>, activeTab: Binding<Tab>){
        withAnimation(.easeInOut(duration: 0.8)){
            self.showSubTab = false
            self.activeTab = .event
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            eventManager.isAddEventSheet = true
            eventManager.addEventStarDate = Date()
        }
    }
    
    public func haptic() {
        if AppConfig.shared.hapticFeedback {
            let impactMed = UIImpactFeedbackGenerator(style: .heavy)
                impactMed.impactOccurred()
        }
    }
}

//

extension View {
    func sheetModifier<SheetContent: View>(
        backgroundAnimation: Bool? = true,
        backgroundOpacity: Double? = nil,
        showAds: Bool? = true,
        isSheet: Binding<Bool>,
        @ViewBuilder sheetContent: @escaping () -> SheetContent,
        dismissContent: @escaping () -> Void
    ) -> some View {
        return self.modifier(SheetModifierView(backgroundAnimation: backgroundAnimation, backgroundOpacity: backgroundOpacity, showAds: showAds, isSheet: isSheet, sheetContent: sheetContent, dismissContent: dismissContent))
    }
}

struct SheetModifierView<SheetContent: View>: ViewModifier { // <SheetContent: View>
    @EnvironmentObject var googleInterstitial: GoogleInterstitialAd
    @EnvironmentObject var themeManager: ThemeManager
    
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    
    @Binding var isSheet: Bool
    
    var sheetContent: () -> SheetContent
    
    let dismissContent: () -> Void
    
    var backgroundAnimation: Bool
    
    var backgroundOpacity: Double
    
    var ads: Bool
    
    init(backgroundAnimation: Bool?, backgroundOpacity: Double? = nil, showAds: Bool?, isSheet: Binding<Bool> , @ViewBuilder sheetContent: @escaping () -> SheetContent, dismissContent: @escaping () -> Void) {
        self._isSheet = isSheet
        self.sheetContent = sheetContent
        self.backgroundAnimation = backgroundAnimation ?? true
        self.ads = showAds ?? true
        self.backgroundOpacity = backgroundOpacity ?? 1.0
        self.dismissContent = dismissContent
    }
    
    func body(content: Content) -> some View {
        content
           .fullScreenCover(isPresented: $isSheet, onDismiss: {
               dismissContent()
               
               guard ads else {
                   return
               }
               
               guard googleInterstitial.interstitial != nil else {
                   return
               }
               
               guard HandlerStates.shared.LastLaunchDate < Calendar.current.date(byAdding: .minute, value: -3, to: Date())! else {
                   return print("[SHEET MODIFIER] Appstart is less them 3mins")
               }
               
               DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { // Show InterstitialSheet if not Pro
                   googleInterstitial.showAd()
               })
               
               
            }, content: {
                ZStack(content: {
                    currentTheme.gradientBackground(nil).ignoresSafeArea()
                    
                    if backgroundAnimation {
                        FloatingClouds(speed: 1.0, opacity: 0.5, currentTheme: currentTheme)
                            .opacity(backgroundOpacity)
                    }
                    
                    sheetContent()

                })
            })
    }
}

extension String: Identifiable {
    public typealias ID = Int
    public var id: Int {
        return hash
    }
}
