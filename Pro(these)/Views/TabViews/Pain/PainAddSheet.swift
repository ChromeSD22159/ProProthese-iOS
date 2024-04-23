//
//  PainAddSheet.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 26.05.23.
//

import SwiftUI
import CoreData

struct PainAddSheet: View {
    @EnvironmentObject var vm: PainViewModel
    @EnvironmentObject var appConfig: AppConfig
    @EnvironmentObject var weatherModel: WeatherModel
    @EnvironmentObject var networkMonitor: NetworkMonitor
    private let persistenceController = PersistenceController.shared
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name, order: .reverse)]) private var PainReasons: FetchedResults<PainReason>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.name, order: .reverse)]) private var PainDrugs: FetchedResults<PainDrug>
    
    @EnvironmentObject var themeManager: ThemeManager
    
    @Binding var isSheet: Bool
    
    @FetchRequest var allLiners: FetchedResults<Liner>
    
    @State var date: Date = Date()
    
    var entryDate: Date?
    
    @State var allProthesis:[Prothese] = []
    
    @State var showProthesis: PainAddSheet.showProthesisType = .all
    
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    
    private var dynamicGrid: Int {
        if allProthesis.count <= 3 {
            return allProthesis.count
        } else {
            return 3
        }
    }
    
    init(isSheet:  Binding<Bool>, entryDate: Date? = nil) {
        _allLiners = FetchRequest<Liner>(
            sortDescriptors: []
        )
        
        self._isSheet = isSheet
        
        self.entryDate = entryDate ?? nil
    }
    
    var body: some View {
        GeometryReader { geo in
            
            if let pain = vm.editPain {  // EDIT ENTRIE
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 30) {
                        // close
                        
                        header(title: LocalizedStringKey("Edit pain entry").localizedstring())
                        
                        Spacer(minLength: 20)
                        
                        if currentStep == 1 {
                            EditStepViewDatePain(geo: geo)
                        }
                        
                        if currentStep == 2 {
                            EditStepViewProtheseReasonDrug(pain: pain, spacing: 30)
                        }
                    }
                    .padding()
                    .presentationDragIndicator(.visible)
                    .foregroundColor(currentTheme.text)
                    .onAppear{
                        vm.addPainDate = pain.date ?? Date()
                        date = pain.date ?? Date()
                        vm.showDatePicker.toggle()
                        vm.selectedPain = Int(pain.painIndex)
                        vm.selectedReason = pain.painReasons
                        vm.selectedDrug = pain.painDrugs
                        vm.prothese = pain.prothese
                        
                        let wearedProthesesToday = getAllProthesesWearedToday(date: pain.date ?? Date())
                        
                        if wearedProthesesToday.count == 0 {
                            self.allProthesis = getAllProtheses()
                            self.showProthesis = PainAddSheet.showProthesisType.all
                        } else {
                            self.allProthesis = wearedProthesesToday
                            self.showProthesis = PainAddSheet.showProthesisType.todayWeared
                        }
                    }
                    .onChange(of: date, perform: { newDate in
                        updateProtheses(date: newDate)
                    })
                }
            } else { // NEW ENTRIE
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 30) {
                        // close
                        
                        header(title: LocalizedStringKey("Do you feel any pain?").localizedstring())
                        
                        Spacer(minLength: 20)

                        if currentStep == 1 {
                            StepViewDatePain(geo: geo)
                        }
                        
                        if currentStep == 2 {
                            StepViewProtheseReasonDrug(spacing: 30)
                        }
                    }
                    .padding()
                    .presentationDragIndicator(.visible)
                    .foregroundColor(currentTheme.text)
                }
                .onAppear(perform: {
                    if let d = entryDate {
                        date = d
                    }
                    
                })
            }
            
            
        }
    }
    
    @ViewBuilder func header(title:String) -> some View {
        HStack(alignment: .center) {
            
            Text(title)
                .foregroundColor(currentTheme.text)
                .padding(.leading)
            
            Spacer()
            
            HStack {
                Button(action: {
                    withAnimation(.easeInOut) {
                        isSheet.toggle()
                        vm.isPainAddSheet = false
                        vm.selectedPain = 0
                        vm.painReason = ""
                        vm.AddPainReasonText = ""
                        vm.painDrug = ""
                        vm.AddPainDrugText = ""
                        vm.showPainReasonPicker = false
                        vm.showPainDrugPicker = false
                        vm.showDatePicker = false
                    }
                }, label: {
                    HStack {
                        Spacer()
                        ZStack{
                            Image(systemName: "xmark")
                                .font(.title2)
                                .padding()
                                .foregroundColor(currentTheme.text)
                        }
                    }
                })
            }

        }
    }
    
    @ViewBuilder func PainPicker(screen: CGSize) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 10) {
            ForEach(1...10 , id: \.self) { pain in
                let activePain = vm.selectedPain == pain
                ZStack{
                    Text("\(pain)")
                        .padding()
                }
                .frame(width: screen.width / 7.5, height: screen.width / 7.5 )
                .background {
                      RoundedRectangle(cornerRadius: 15)
                          .fill(.ultraThinMaterial.opacity(0.4).shadow(.drop(color: .gray, radius: activePain ? 5 : 0)))
                          .overlay{
                             RoundedRectangle(cornerRadius: 15)
                                  .stroke(.gray, lineWidth: activePain ? 1 : 0)
                          }
                }
                .onTapGesture(perform: {
                    if vm.selectedPain == pain {
                        vm.selectedPain = 0
                    } else {
                        vm.selectedPain = pain
                    }
                })
                
            }
        }
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder func Reason() -> some View {
        VStack{
            Button {
                withAnimation {
                    vm.showPainReasonPicker.toggle()
                }
            }  label: {
                HStack(spacing: 10){
                    Image(systemName: "figure.walk")
                    Text((vm.selectedReason == nil ? LocalizedStringKey("Choose") : LocalizedStringKey(vm.selectedReason?.name ?? "") ) )
                        .font(.caption2)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(currentTheme.textGray)
                )
            }
            .background(
                Picker("Cause of pain", selection: $vm.selectedReason) {
                    
                    ForEach(PainReasons, id: \.id) { reason in
                        Text(LocalizedStringKey(reason.name!)).tag(Optional<PainReason>(reason))
                    }
                    Text("other reason").tag(Optional<PainReason>(nil))
                }
                .pickerStyle(.inline)
                .frame(width: 200, height: 100)
                .clipped()
                .background(currentTheme.textBlack.cornerRadius(10))
                .opacity(vm.showPainReasonPicker ? 1 : 0 )
                .offset(x: 0, y: 90)
            )
            .frame(maxWidth: .infinity)
            .onChange(of: vm.selectedReason) { newValue in
               withAnimation {
                   vm.selectedReason = newValue
                   vm.showPainReasonPicker = false
               }
            }// ReasonPicker
            
            if vm.selectedReason?.name == nil && vm.showPainReasonPicker == false {
                HStack(spacing: 20){
                    Image(systemName: "figure.walk")
                        .font(.title3)
                    
                    TextField( "e.g.: weather, cold, heat...", text: $vm.AddPainReasonText, onEditingChanged: { (isChanged) in
                        if !isChanged {
                            if vm.AddPainReasonText == "" {
                                vm.isPainReasonValid = false
                            } else {
                                vm.isPainReasonValid = true
                            }
                       }
                    })
                    .padding(.horizontal)
                }
                .padding()
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(currentTheme.textGray)
                )
                .padding(.vertical)
            }
        }
    }
    
    @ViewBuilder func Drugs() -> some View {
        VStack{
            Button {
                withAnimation {
                    vm.showPainDrugPicker.toggle()
                }
            }  label: {
                HStack(spacing: 10){
                    Image(systemName: "pills")
                    Text((vm.selectedDrug == nil ? LocalizedStringKey("Choose") : LocalizedStringKey(vm.selectedDrug?.name ?? "")) )
                        .font(.caption2)
                        .frame(maxWidth: .infinity)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(currentTheme.textGray)
                )
            }
            .background(
                    Picker("Painkiller", selection: $vm.selectedDrug) {
                        ForEach(PainDrugs, id: \.id) { drug in
                            
                            // Text(translateReasons(drug.name!)).tag(Optional<PainDrug>(drug))
                            Text(LocalizedStringKey(drug.name!)).tag(Optional<PainDrug>(drug))
                        }
                        
                        Text("other painkillers").tag(Optional<PainDrug>(nil))
                    }
                    .pickerStyle(.inline)
                    .frame(width: 200, height: 100)
                    .clipped()
                    .background(currentTheme.textBlack.cornerRadius(10))
                    .opacity(vm.showPainDrugPicker ? 1 : 0 )
                    .offset(x: 0, y: 90)
            )
            .frame(maxWidth: .infinity)
            .onChange(of: vm.selectedDrug) { newValue in
               withAnimation {
                   vm.selectedDrug = newValue
                   vm.showPainDrugPicker = false
               }
            }// ReasonPicker
            
            if vm.selectedDrug?.name == nil && vm.showPainDrugPicker == false {
                HStack(spacing: 20){
                    Image(systemName: "pills")
                        .font(.title3)
                    TextField( "E.g.: Ibuprofen, Tillidin, Pregabalin...", text: $vm.AddPainDrugText, onEditingChanged: { (isChanged) in
                        if !isChanged {
                             if vm.AddPainDrugText == "" {
                                 vm.isPainDrugValid = false
                             } else {
                                 vm.isPainDrugValid = true
                             }
                       }
                    })
                    .padding(.horizontal)
                }
                .padding()
                .padding(.horizontal)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(currentTheme.textGray)
                )
                .padding(.vertical)
            }
        }
    }
    
    @ViewBuilder func DateButtonRow() -> some View {
        HStack {
            Spacer()
            
            DateButton(date: $date, type: .date, alignment: .leading, font: .title3)
               
            Spacer()
            
            DateButton(date: $date, type: .time, alignment: .trailing, font: .title3.bold())
            
            Spacer()
        }
        .zIndex(1)
    }
    
    private func fetchWearingTimesForToday(date: Date) -> [WearingTimes] {
        var wearingTimes = [WearingTimes]()

        let fetchRequest: NSFetchRequest<WearingTimes> = WearingTimes.fetchRequest()

        // Heutiges Datum
        let today = Calendar.current.startOfDay(for: date)

        let predicate = NSPredicate(format: "(start >= %@ AND start < %@) OR (end >= %@ AND end < %@)",
                                      today as NSDate, today.addingTimeInterval(24*60*60) as NSDate,
                                      today as NSDate, today.addingTimeInterval(24*60*60) as NSDate)
        
        fetchRequest.predicate = predicate

        do {
            let context = PersistenceController.shared.container.viewContext
            wearingTimes = try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch wearing times: \(error.localizedDescription)")
        }

        return wearingTimes
    }
    
    private func getAllProthesesWearedToday(date: Date? = nil) -> [Prothese] {
        let wearingTimesForToday = self.fetchWearingTimesForToday(date: date ?? Date())
        var prothesen = [Prothese]()
        
        for wearingTime in wearingTimesForToday {
            
           
            if let pro = wearingTime.prothese as Prothese? {
                if !prothesen.contains(pro) {
                    prothesen.append(pro)
                }
            }
                
                
        }
        
        return prothesen
    }
    
    private func getAllProtheses() -> [Prothese] {
        var prothesen = [Prothese]()

        let fetchRequest: NSFetchRequest<Prothese> = Prothese.fetchRequest()

        do {
            let context = PersistenceController.shared.container.viewContext
            prothesen = try context.fetch(fetchRequest)
        } catch {
            print("Failed to fetch Protheses: \(error.localizedDescription)")
        }
        
        return prothesen
    }
    
    private func toggleProtheses(date: Date? = nil) {
        allProthesis.removeAll()
        
        if self.showProthesis == .all {
            self.showProthesis = .todayWeared
            self.allProthesis = self.getAllProthesesWearedToday(date: date)
        } else {
            self.showProthesis = .all
            self.allProthesis = self.getAllProtheses()
        }
        
    }
    
    private func updateProtheses(date: Date? = nil) {
        allProthesis.removeAll()
        
        let fetched = self.getAllProthesesWearedToday(date: date)
        let all = self.getAllProtheses()
        
        if self.showProthesis == .todayWeared {
            if fetched.count > 0 {
                self.allProthesis = fetched
                self.showProthesis = .todayWeared
            } else {
                self.allProthesis = all
                self.showProthesis = .all
            }
        } else {
            self.allProthesis = all
            self.showProthesis = .all
        }
        
    }
    
    enum showProthesisType {
        case all, todayWeared
    }
    
    
    
    @State private var currentStep = 1
    
    @ViewBuilder func StepViewDatePain(geo: GeometryProxy) -> some View {
        VStack(spacing: 30) {
            VStack(spacing: 8){
                Text("Hey! Describe\nyour pain!")
                    .font(.system(size: 30, weight: .regular))
            }
            
            DateButtonRow()
            
            PainPicker(screen: geo.size)
                        
            HStack{
                Button("Cancel"){
                    isSheet.toggle()
                    
                    vm.resetStates()
                    vm.prothese = nil
                    
                    vm.editPain = nil
                    vm.resetStates()
                    
                    
                }
                .frame(maxWidth: .infinity)
                .padding()
                .textCase(.uppercase)
                .background(currentTheme.text.opacity(0.05))
                .foregroundColor(currentTheme.text)
                .cornerRadius(10)
                
                Button("further"){
                    currentStep += 1
                }
                .frame(maxWidth: .infinity)
                .padding()
                .textCase(.uppercase)
                .background(currentTheme.text.opacity(0.05))
                .foregroundColor(currentTheme.text)
                .cornerRadius(10)
            }
        }
    }
    
    @ViewBuilder func StepViewProtheseReasonDrug(spacing: CGFloat) -> some View {
        VStack(spacing: spacing) {
            VStack(spacing: 8){
                Text("What prosthesis\ndid you wear?")
                    .font(.system(size: 30, weight: .regular))
            }
            
            // Prothese
            VStack(spacing: 10) {
                HStack {
                    Spacer()
                    
                    Text(showProthesis == .all ? "View dentures worn today" :  "Show all prostheses")
                        .font(.caption2.bold())
                        .onTapGesture {
                            toggleProtheses(date: date)
                        }
                }
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: dynamicGrid), spacing: 10) {
                    ForEach(allProthesis, id: \.hashValue) { prothese in
                        let activeProthese = vm.prothese == prothese
                        
                        Button {
                            vm.prothese = prothese
                        } label: {
                            VStack {
                                Image(prothese.prosthesisIcon)
                                    .font(.title)
                                    .foregroundStyle(currentTheme.hightlightColor, currentTheme.textGray)
                                
                                Text(prothese.prosthesisKindLineBreak).padding()
                                    .font(.caption2.bold())
                                    .foregroundColor(currentTheme.text)
                            }
                            .padding(10)
                            .background {
                                  RoundedRectangle(cornerRadius: 15)
                                    .fill(.ultraThinMaterial.opacity(0.4).shadow(.drop(color: .gray, radius: activeProthese ? 5 : 0)))
                                      .overlay{
                                         RoundedRectangle(cornerRadius: 15)
                                              .stroke(.gray, lineWidth: activeProthese ? 1 : 0)
                                      }
                            }
                        }
                    }
                }
            }
            
            // ReasonDrug
            HStack(alignment: .top, spacing: 8) {
                Reason()
                
                Drugs()
            }
            .zIndex(1)
            
            HStack{
                Button("previous"){
                    currentStep -= 1
                }
                .frame(maxWidth: .infinity)
                .padding()
                .textCase(.uppercase)
                .background(currentTheme.text.opacity(0.05))
                .foregroundColor(currentTheme.text)
                .cornerRadius(10)
                
                Button("Save"){
                    let newPain = Pain(context: persistenceController.container.viewContext)
                    newPain.date = date
                    newPain.painIndex = Int16(vm.selectedPain)
                    newPain.painReasons = vm.selectedReason
                    newPain.painDrugs = vm.selectedDrug
                    newPain.stepCount = vm.currentStepCountToday
                    
                    if networkMonitor.isConnected {
                        newPain.tempC = HandlerStates.shared.weatherTempC
                        newPain.tempF = HandlerStates.shared.weatherTempF
                        newPain.condition = HandlerStates.shared.weatherCondition
                        newPain.conditionIcon = HandlerStates.shared.weatherConditionIcon
                        newPain.pressureMb = HandlerStates.shared.weatherPressureMb
                    }
                    
                   
                    newPain.wearingAllProtheses = Int16(vm.wearingTimeTotal)
                    
                    if vm.AddPainReasonText != "" {
                        let newPainReason = PainReason(context: persistenceController.container.viewContext)
                        newPainReason.name = vm.AddPainReasonText
                       // newPainReason.date = vm.addPainDate
                        newPainReason.date = Date()
                        newPain.painReasons = newPainReason
                    }
                    
                    if vm.AddPainDrugText != "" {
                        let newPainDrug = PainDrug(context: persistenceController.container.viewContext)
                        newPainDrug.name = vm.AddPainDrugText
                        newPainDrug.date = vm.addPainDate
                        newPain.painDrugs = newPainDrug
                    }
                    
                    if let pro = vm.prothese {
                        newPain.prothese = pro
                        vm.prothese?.addToPains(newPain)
                    }

                    do {
                        try? persistenceController.container.viewContext.save()
                        
                        isSheet.toggle()
                        
                        // reset
                        vm.resetStates()
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .textCase(.uppercase)
                .background(currentTheme.text.opacity(0.05))
                .foregroundColor(currentTheme.text)
                .cornerRadius(10)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 10)
            .onAppear(perform: {
                vm.fetchCurrentStepCountToday()
                vm.fetchWearingTimesAllProthesesToday()
                
                let wearedProthesesToday = getAllProthesesWearedToday()
                
                if wearedProthesesToday.count == 0 {
                    self.allProthesis = getAllProtheses()
                    self.showProthesis = PainAddSheet.showProthesisType.all
                } else {
                    self.allProthesis = wearedProthesesToday
                    self.showProthesis = PainAddSheet.showProthesisType.todayWeared
                }
                
            })
            .onChange(of: date, perform: { newDate in
                updateProtheses(date: newDate)
            })
        }
    }
    
    @ViewBuilder func EditStepViewDatePain(geo: GeometryProxy) -> some View {
        VStack(spacing: 30) {
            VStack(spacing: 8){
                Text("Hey! Describe\nyour pain!")
                    .font(.system(size: 30, weight: .regular))
            }
            
            DateButtonRow()
            
            PainPicker(screen: geo.size)
            
            HStack{
                Button("Cancel"){
                    isSheet.toggle()
                    
                    vm.resetStates()
                    vm.prothese = nil
                    
                    vm.editPain = nil
                    vm.resetStates()
                    
                    
                }
                .frame(maxWidth: .infinity)
                .padding()
                .textCase(.uppercase)
                .background(currentTheme.text.opacity(0.05))
                .foregroundColor(currentTheme.text)
                .cornerRadius(10)
                
                Button("further"){
                    currentStep += 1
                }
                .frame(maxWidth: .infinity)
                .padding()
                .textCase(.uppercase)
                .background(currentTheme.text.opacity(0.05))
                .foregroundColor(currentTheme.text)
                .cornerRadius(10)
            }
        }
    }
    
    @ViewBuilder func EditStepViewProtheseReasonDrug(pain: Pain, spacing: CGFloat) -> some View {
        VStack(spacing: spacing) {
            VStack(spacing: 8){
                Text("What prosthesis")
                    .font(.system(size: 30, weight: .regular))
                Text("did you wear?")
                    .font(.system(size: 30, weight: .regular))
            }
            
            // Prothese
            VStack(spacing: 10) {
                HStack {
                    Spacer()
                    
                    Text("Show all prostheses")
                        .font(.caption2.bold())
                        .onTapGesture {
                            toggleProtheses(date: date)
                        }
                }
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: dynamicGrid), spacing: 10) {
                    ForEach(allProthesis, id: \.hashValue) { prothese in
                        let activeProthese = vm.prothese == prothese
                        
                        Button {
                            vm.prothese = prothese
                        } label: {
                            VStack {
                                Image(prothese.prosthesisIcon)
                                    .font(.title)
                                    .foregroundStyle(currentTheme.hightlightColor, currentTheme.textGray)
                                
                                Text(prothese.prosthesisKindLineBreak).padding()
                                    .font(.caption2.bold())
                                    .foregroundColor(currentTheme.text)
                            }
                            .padding(10)
                            .background {
                                  RoundedRectangle(cornerRadius: 15)
                                      .fill(.ultraThinMaterial.opacity(0.4).shadow(.drop(color: .gray, radius: activeProthese ? 5 : 0)))
                                      .overlay{
                                         RoundedRectangle(cornerRadius: 15)
                                              .stroke(.gray, lineWidth: activeProthese ? 1 : 0)
                                      }
                            }
                        }
                    }
                }
            }
            
            // ReasonDrug
            HStack(alignment: .top, spacing: 8) {
                Reason()
                
                Drugs()
            }
            .zIndex(1)
            
            HStack{
                Button("Previous"){
                    currentStep -= 1
                }
                .frame(maxWidth: .infinity)
                .padding()
                .textCase(.uppercase)
                .background(currentTheme.text.opacity(0.05))
                .foregroundColor(currentTheme.text)
                .cornerRadius(10)
                
                Button("Change"){
                    let newPain = pain
                    
                    newPain.date = date
                    newPain.painIndex = Int16(vm.selectedPain)
                    newPain.painReasons = vm.selectedReason
                    newPain.painDrugs = vm.selectedDrug
                    
                    if vm.AddPainReasonText != "" {
                        let newPainReason = pain.painReasons
                        newPainReason?.name = vm.AddPainReasonText
                        newPainReason?.date = vm.addPainDate
                        newPain.painReasons = newPainReason
                    }
                    
                    if vm.AddPainDrugText != "" {
                        let newPainDrug = pain.painDrugs
                        newPainDrug?.name = vm.AddPainDrugText
                        //newPainDrug?.date = vm.addPainDate
                        newPainDrug?.date = Date()
                        newPain.painDrugs = newPainDrug
                    }

                    if let pro = vm.prothese {
                        newPain.prothese = pro
                        vm.prothese?.addToPains(newPain)
                    }
                    
                    do {
                        
                        isSheet.toggle()
                        
                        try? persistenceController.container.viewContext.save()
                        
                        // reset
                        vm.resetStates()
                        
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .textCase(.uppercase)
                .background(currentTheme.text.opacity(0.05))
                .foregroundColor(currentTheme.text)
                .cornerRadius(10)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom, 10)
        }
    }
}

struct TabEualView: View {
    private var currentTheme: Theme {
        return ThemeManager().currentTheme()
    }
    
    @State private var tabSize: CGSize = .zero
    @State private var tab = 0
    @State private var tabContentHeights: [CGFloat] = [CGFloat]()
    
    var content: [AnyView]
    
    var equalHeight: Bool
    
    init(content: [AnyView], equalHeight: Bool? = nil) {
        UITabBar.appearance().backgroundColor = UIColor.clear
        UITabBar.appearance().isTranslucent = true
        self.content = content
        self.equalHeight = equalHeight ?? false
    }

    var body: some View {
        TabView(selection: $tab) {
            ForEach(content.indices, id: \.self) { co in
                VStack {
                    AnyView(content[co])
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(20)
                        .tag(co)
                        .padding(.horizontal)
                        .saveSize(in: $tabSize)
                    Spacer()
                }
            }
        }
        .onAppear(perform: { tab = 0 })
        .onDisappear(perform: { tab = 0 })
        .frame(height: tabSize.height + 80)
        .tabViewStyle(.page)
        .padding(.vertical, -20)
    }
}
