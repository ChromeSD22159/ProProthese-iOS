//
//  Events.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 01.05.23.
//

import SwiftUI
import CoreData
import Charts


struct Events: View {
    @EnvironmentObject var appConfig: AppConfig
    @EnvironmentObject var eventManager: EventManager
    @EnvironmentObject var tabManager: TabManager
    @EnvironmentObject var cal: MoodCalendar
    @EnvironmentObject var entitlementManager: EntitlementManager
    @EnvironmentObject var googleInterstitial: GoogleInterstitialAd
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FocusState var focusedTask: EventTasks?
    @FetchRequest(sortDescriptors: [ SortDescriptor(\.startDate) ]) var events: FetchedResults<Event>
    
    @EnvironmentObject var themeManager: ThemeManager
    
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    
    private var dateClosedRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .year, value: -5, to: Date())!
        let max = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
        return min...max
    }
    
    var SortedContacts: [Contact] {
        return eventManager.contacts.sorted(by: { $0.name ?? "" < $1.name ?? "" })
    }
    
    var body: some View {
        GeometryReader { g in
            ZStack {
                
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack(spacing: 10) {
                        AnimatedHeader()

                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(alignment: .center, spacing: 5) {
                                
                                ForEach(Array(SortedContacts.enumerated()), id: \.1) { (index, contact) in
                                    GeometryReader { geo in
                                        NavigateTo({
                                            ImageView(image: eventManager.getImage(contact.titel ?? "noImage") , name: contact.name ?? "Unbekannter Name", titel: contact.titel ?? "Unbekannter Titel" != "other" ? contact.titel ?? "Unbekannter Titel" : "Sonstiges"  )
                                                .rotation3DEffect(.degrees(-geo.frame(in: .global).minX) / 20, axis: (x: 0, y: 1, z: 0))
                                                .frame(width: 160, height: 200)
                                                .shadow(color: currentTheme.textBlack.opacity(0.5), radius: 10, x: 5, y: 5)
                                                .offset(y: -18)
                                        }, {
                                            ContactDetailView(contact: contact, iconColor: currentTheme.hightlightColor)
                                        }, from: .event)
                                    }
                                    .padding(.vertical, 40)
                                    .frame(width: 160, height: 230)
                                }
                                
                                AddContact()
                                    .frame(width: 160, height: 230)
                                    .padding(.leading, 10)
                                    .shadow(color: currentTheme.textBlack.opacity(0.5), radius: 10, x: 5, y: 5)
                                   
                                    
                            }
                            .padding(10)
                        }
                        .offset(y: -15)
                        //.listRowBackground(currentTheme.text.opacity(0.001))
                        
                        if !appConfig.hasPro {
                            AdBannerView()
                                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                                .padding(.vertical, 10)
                        }
                        
                        if appConfig.EventShowCalendar {
                            EventCalendar(events: events)
                        } else {
                            VStack {
                                
                                RowAddEventBTN()
                                
                                EventSection(type: .thisWeek, viewType: .diclosure, isExtended: true)
                                
                                EventSection(type: .nextWeek, viewType: .diclosure, isExtended: true)
                                
                                EventSection(type: .thisMonth, viewType: .diclosure, isExtended: true)
                                
                                EventSection(type: .nextMonth, viewType: .diclosure, isExtended: true)

                                EventSection(type: .lastWeek, viewType: .diclosure, isExtended: appConfig.showAllPastEventsIsExtended)
                                    .show(appConfig.showAllPastEvents)
                                
                                EventSection(type: .past, viewType: .diclosure, isExtended: appConfig.showPastWeekEventsIsExtended)
                                    //.listRowInsets(EdgeInsets(top: 15, leading: 15, bottom: 15, trailing: 15))
                                    .show(appConfig.showPastWeekEvents)
                            }
                            .padding(.horizontal)
                            .foregroundColor(currentTheme.text)
                            /*.refreshable {
                                eventManager.fetchContacts()
                            }*/
                        }
                    }
                    .foregroundColor(currentTheme.text)
                    .fullSizeTop()

                })
                .coordinateSpace(name: "SCROLL")
                .ignoresSafeArea(.container, edges: .vertical)
                .blur( radius: cal.showCalendarPicker ? 4 : 0)
                
                if cal.showCalendarPicker {
                   VStack {
                       ZStack {
                           currentTheme.textBlack.opacity(0.5).ignoresSafeArea()
                           
                           VStack(spacing: 20) {
                               Spacer()
                               
                               HStack {
                                   Spacer()
                                   
                                   Button(action: {
                                       withAnimation(.easeInOut) {
                                           cal.showCalendarPicker = false
                                       }
                                   }, label: {
                                       Image(systemName: "xmark")
                                           .foregroundColor(currentTheme.text)
                                   })
                               }
                               .padding(.horizontal, 50)
                               
                               DatePicker(
                                   "",
                                   selection: $cal.selectedCalendarDate,
                                   //in: dateClosedRange,
                                   displayedComponents: .date
                               )
                               .labelsHidden()
                               .datePickerStyle(.wheel)
                               .background(.ultraThinMaterial)
                               .cornerRadius(20)
                               .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                               
                               Spacer()
                           }
                       }
                       
                       
                       Spacer()
                   }
                   
               }
            }
            .blurredOverlaySheet(.init(Material.ultraThinMaterial), show: $eventManager.isAddEventSheet, onDismiss: {
                // Show InterstitialSheet if not Pro
                googleInterstitial.showAd()
            }, content: {
                
                ZStack(content: {
                    currentTheme.gradientBackground(nil).ignoresSafeArea()
                    
                    FloatingClouds(speed: 1.0, opacity: 0.5, currentTheme: currentTheme)
                        .opacity(0.5)
                    
                    EventAddSheetBoby(titel: "Create an appointment")
                        .presentationDetents([.large])
                        .presentationDragIndicator(.visible)
                })
                
            })
            .onAppear {
                eventManager.fetchContacts()
                
                cal.selectedCalendarDate = Date()
                cal.currentDate = Date()
                cal.currentDates = cal.extractMonth()
            }
            .onChange(of: cal.selectedCalendarDate, perform: { (value) in
                cal.selectedCalendarDate = value
                cal.currentDate = value
                cal.currentDates = cal.extractMonthByDate()
                withAnimation(.easeInOut){
                    cal.showCalendarPicker = false
                }
            })
             
        }
        
    }
}

// MARK: Event ViewItems
extension Events {
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
                sayHallo(name: appConfig.username)
                    .font(.title2)
                    .foregroundColor(currentTheme.text)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Your appointments and notes at a glance.")
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
                
                Image(systemName: appConfig.EventShowCalendar ? "calendar" : "list.bullet.below.rectangle")
                    .foregroundColor(currentTheme.text)
                    .font(.title3)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.5)){
                            appConfig.EventShowCalendar.toggle()
                        }
                    }
                
                /*
                 Image(systemName: "gearshape")
                     .foregroundColor(currentTheme.text)
                     .font(.title3)
                     .onTapGesture {
                         tabManager.isSettingSheet.toggle()
                     }
                 */
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 30)
        .frame(maxWidth: .infinity)
    }
    
    @ViewBuilder func RowAddEventBTN() -> some View {
        HStack {
            Spacer()
            
            Button(
                action: {
                    eventManager.openAddEventSheet(date: Date())
                }, label: {
                    Label("Add", systemImage: "plus")
                        .font(.caption2)
                        .fontWeight(.medium)
                        .padding(
                        )
                })
        }
    }
}


struct AddContact: View {
    @EnvironmentObject var appConfig: AppConfig
    @EnvironmentObject var eventManager: EventManager
    @EnvironmentObject var themeManager: ThemeManager
    
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    var body: some View {
        
        NavigateTo({
            VStack(spacing: 10){
                Image(systemName: "plus")
                    .multilineTextAlignment(.center)
                Text("Add \n Contact")
                    .multilineTextAlignment(.center)
            }
        }, {
            AuroraBackground(content: {
                ContentAddSheetBoby(isAddContactSheet: $eventManager.isAddContactSheet, titel:  "New contact", contact: nil)
            })
        }, from: .event)
        .foregroundColor(currentTheme.text)
        .frame(width: 160, height: 210)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(currentTheme.text, lineWidth: 2)
        )
    }
}

struct ImageView: View {
    var image: String
    var name: String
    var titel: String
    @EnvironmentObject var themeManager: ThemeManager
    
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    var body: some View {
        
        VStack(alignment: .center) {
            
            VStack {
                Image(image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            }
            .frame(width: 160, height: 120)
            
            VStack{
                Text(name)
                    .font(.footnote.bold())
                    .fixedSize(horizontal: false, vertical: false)
                    .multilineTextAlignment(.center)
                
                Text(LocalizedStringKey(titel))
                    .font(.caption2)
                    .fixedSize(horizontal: false, vertical: false)
                    .multilineTextAlignment(.center)
                    .foregroundColor(currentTheme.textGray)
            }
            .padding(.top)
            .padding()
        }
        .background(.ultraThinMaterial)
        .cornerRadius(20)
    }
}


