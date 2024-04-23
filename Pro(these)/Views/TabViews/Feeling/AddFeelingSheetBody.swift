//
//  AddFeelingSheetBody.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 24.05.23.
//

import SwiftUI
import WidgetKit



struct AddFeelingSheetBody: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var cal: MoodCalendar
    @EnvironmentObject var appConfig: AppConfig
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var googleInterstitial: GoogleInterstitialAd
    @FetchRequest var allProthesis: FetchedResults<Prothese>
    
    @FetchRequest var allLiners: FetchedResults<Liner>
    
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    
    private  var dynamicGrid: Int {
        if allProthesis.count <= 3 {
            return allProthesis.count
        } else {
            return 3
        }
    }
    
    private var isEdit: Bool {
        return editFeeling != nil ? true : false
    }
    
    var newItem: Feeling {
        let new = Feeling(context: managedObjectContext)
        new.date = Date()
        new.name = "feeling_5"
        new.prothese = allProthesis.first ?? nil
        
        return new
    }
    
    var editFeeling: Feeling?

    var calDate: Date? = nil
    
    @State var feelingItem: Feeling?
    
    @State var date: Date = Date()
    
    @Binding var isFeelingSheet: Bool
    
    var entryDate: Date?

    init(editFeeling: Feeling? = nil, calDate: Date? = nil , isFeelingSheet: Binding<Bool>, entryDate: Date? = nil) {
        _allProthesis = FetchRequest<Prothese>(
            sortDescriptors: []
        )
        
        _allLiners = FetchRequest<Liner>(
            sortDescriptors: []
        )
        
        self._isFeelingSheet = isFeelingSheet
        
        self.calDate = calDate
        
        self.editFeeling = editFeeling
        
        self.entryDate = entryDate
    }
    
    var body: some View {
        GeometryReader { geo in
            
            if let currentFeeling = feelingItem {
                VStack {
                    
                    header(title: LocalizedStringKey("How are you doing?").localizedstring(), currentFeeling: currentFeeling)
                    
                    Spacer()
                    
                    VStack(spacing: 8){
                        Text(isEdit ? "Hey! Has anything\nchanged?" : "Hey! How are you\nfeeling today?")
                            .font(.system(size: 30, weight: .regular))
                            .multilineTextAlignment(.center)
                    }
                    
                    Spacer()
                    
                    DateButtonRow()
                    
                    Spacer()

                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: dynamicGrid), spacing: 10) {
                        ForEach(allProthesis, id: \.hashValue) { prothese in
                            
                            let activeProthese = feelingItem?.prothese == prothese
                            
                            Button {
                                feelingItem?.prothese = prothese
                            } label: {
                                VStack {
                                    Image(prothese.prosthesisIcon)
                                        .font(.title)
                                        .foregroundStyle(currentTheme.hightlightColor, currentTheme.textGray)
                                        .opacity(feelingItem?.prothese == prothese ? 1 : 0.5)
                                        .padding(.top)
                                    
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
                    .padding(.bottom, 20)
                    
                    LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 5), spacing: 10) {
                        ForEach(1...5, id: \.self) { int in
                            let activeFeeling = feelingItem?.name == "feeling_\(int)"
                            
                            Button {
                                feelingItem?.name = "feeling_\(int)"
                            } label: {
                                VStack {
                                    Image("feeling_\(int)")
                                        .font(.title2)
                                        .scaleEffect(2)
                                        .foregroundColor(currentTheme.hightlightColor)
                                        .opacity(activeFeeling ? 1 : 0.4)
                                }
                                .padding(10)
                                .overlay(
                                    Circle()
                                       .fill(.ultraThinMaterial.opacity(0.4).shadow(.drop(color: .gray, radius: activeFeeling ? 5 : 0)))
                                       .overlay{
                                           Circle()
                                               .stroke(.gray, lineWidth: activeFeeling ? 0 : 0)
                                       }
                                )
                            }
                        }
                    }

                    HStack {
                        Button("Cancel") {
                            cancel(currentFeeling)
                        }
                        
                        Spacer()
                        
                        Button(isEdit ? "Edit" : "Save") {
                            do {
                                 try? managedObjectContext.save()
                                 isFeelingSheet.toggle()
                                 WidgetCenter.shared.reloadAllTimelines()
                             }
                        }
                    }
                    .padding(.top, 20)
                    .padding(.horizontal)
                    
                    Spacer()
                }
                .padding()
                .presentationDragIndicator(.visible)
                .foregroundColor(currentTheme.text)
                
            }

        }
        .onAppear {
            googleInterstitial.requestInterstitialAds()
            
            if let item = editFeeling {
                self.feelingItem = item
                self.date = item.date ?? calDate ?? Date()
            } else {
                self.feelingItem = newItem
                
                if let date = calDate {
                    let calendar = Calendar.current
                    let dateComponents = calendar.dateComponents([.hour, .minute, .second], from: Date())
                    
                    if let updatedDate = calendar.date(bySettingHour: dateComponents.hour ?? 0, minute: dateComponents.minute ?? 0, second: dateComponents.second ?? 0, of: date) {
                            self.date = updatedDate
                    }
                }
            }
        }
        .onChange(of: date, perform: { newDate in
            self.feelingItem?.date = newDate
        })
    }
    
    private func cancel(_ currentFeeling: Feeling) {
        isFeelingSheet.toggle()
        
        if isEdit {
            feelingItem = editFeeling
        } else {
            managedObjectContext.delete(currentFeeling)
        }
    }
    
    @ViewBuilder func DateButtonRow() -> some View {
        HStack {
            Spacer()
            
            DateButton(date: $date, type: .date, alignment: .leading, font: .title3.bold())
               
            Spacer()
            
            DateButton(date: $date, type: .time, alignment: .trailing, font: .title3.bold())
            
            Spacer()
        }
        .zIndex(1)
    }

    @ViewBuilder func header(title:String, currentFeeling: Feeling) -> some View {
        HStack(alignment: .center) {
            
            Text(title)
                .foregroundColor(currentTheme.text)
                .padding(.leading)
            
            Spacer()
            
            HStack {
                Button(action: {
                    cancel(currentFeeling)
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
}


struct DateButton: View {
    
    @EnvironmentObject var themeManager: ThemeManager
    
    @State var size: CGSize = .zero
    
    @State var showTimePicker = false
    
    @Binding var date: Date
    
    var disable: Bool? = nil
    
    var type: DateButton.type? = .date
    
    var alignment: DateButton.alignment? = .trailing
    
    var font: Font? = .body
    
    var labelStyle: (any LabelStyle)? = .titleAndIcon
    
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    
    private var dateFormatted: String {
        let d = date.dateFormatte(date: "dd.MM.yy", time: "HH:mm")
        
        return self.type == .date ? d.date : d.time
    }
    
    private var pickerType: DatePickerComponents {
        return self.type == .date ? .date : .hourAndMinute
    }
    
    private var image: String {
        return self.type == .date ? "calendar" : "clock.badge"
    }
    
    var body: some View {
        dateButton()
    }
    
    @ViewBuilder func dateButton() -> some View {
        Button {
            withAnimation {
                showTimePicker.toggle()
            }
        }  label: {
            Label(dateFormatted, systemImage: image)
                .labelStyle(.titleAndIcon)
                .font(font)
                .foregroundColor(currentTheme.text)
                .padding(10)
                //.background(Material.ultraThinMaterial.opacity(0.4))
                //.cornerRadius(15)
        }
        .offset(x: disable ?? true ? 0 : 150)
        .background(
            DatePicker("", selection: $date, displayedComponents: pickerType)
                .datePickerStyle(.wheel)
                .saveSize(in: $size)
                //.frame(width: size.width + 10, height: size.height + 10)
                .clipped()
                .background(currentTheme.textGray.cornerRadius(10))
                .opacity(showTimePicker ? 1 : 0 )
                .offset(x: self.alignment == .leading ? size.width / 2 - 40 : -size.width / 2 + 20, y: size.height / 2 + 20)
        )
        .onChange(of: date, perform: { new in
            showTimePicker = false
        })
    }
    
    enum type {
        case date, time
    }
    
    enum alignment {
        case leading, trailing
    }
}
