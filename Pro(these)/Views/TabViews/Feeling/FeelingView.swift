//
//  FeelingView.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 17.05.23.
//

import SwiftUI
import CoreData
import WidgetKit

struct FeelingView: View {
    @EnvironmentObject var appConfig: AppConfig
    @EnvironmentObject var googleInterstitial: GoogleInterstitialAd

    @EnvironmentObject var pushNotificationManager: PushNotificationManager
    @EnvironmentObject var cal: MoodCalendar
    @EnvironmentObject var tabManager: TabManager
    @EnvironmentObject var entitlementManager: EntitlementManager
    @Environment(\.managedObjectContext) var managedObjectContext
    @EnvironmentObject var themeManager: ThemeManager
    
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    
    @FetchRequest(sortDescriptors: [ SortDescriptor(\.date) ]) var listFeelings: FetchedResults<Feeling>
    
    @Namespace var bottomID
    @Namespace var dateID
    @Namespace var noneID
   
    @State var attempts: Int = 0
    @State var isScreenShotSheet = false
    @State var isFeelingSheet = false
    private var dateClosedRange: ClosedRange<Date> {
       let min = Calendar.current.date(byAdding: .year, value: -5, to: Date())!
       let max = Calendar.current.date(byAdding: .hour, value: 1, to: Date())!
       return min...max
    }
    
    @State var showTimePicker = false
   
    var body: some View {
        
        GeometryReader { proxy in
                
            ScrollViewReader { scrollProxy in
                
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack(spacing: 10) {
                        AnimatedHeader()
                        
                        GlockRow()
                        
                        FeelingCalendarView(feelings: listFeelings)
                            .background(
                                GeometryReader { proxy in
                                    Color.clear.onAppear { print("FeelingCalendarView \(proxy.size.height)") }
                                }
                            )
                    }
                    
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
                                       in: dateClosedRange,
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
                })
                .coordinateSpace(name: "SCROLL")
                .ignoresSafeArea(.container, edges: .vertical)
                .blur( radius: cal.showCalendarPicker ? 4 : 0)
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                        // scroll to Tapped Date
                        withAnimation(.easeInOut(duration: 2.5)){
                            scrollProxy.scrollTo(dateID)
                            
                        }
                        
                        // Shake to Date Item .modifier(Shake(animatableData: CGFloat(cal.isSameDay(d1: date, d2: cal.currentDate) ? attempts : 0 )))
                        withAnimation(.easeInOut(duration: 0.5).delay(0.5)){
                            self.attempts += 1
                        }
                    }
                }
                
            } // ScrollViewReader
            .onAppear {
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
    
    @ViewBuilder func AnimatedHeader() -> some View {
        
        /*
         ScrollView(.vertical, showsIndicators: false, content: {
             VStack(spacing: 10) {
                 AnimatedHeader()
                 
                 Settings()
                 
                 copyright(isAuthenticating: $isAuthenticating, showDebugField: $showDebugField, password: $password)
                     .padding(.vertical, 20)
             }
         })
         .coordinateSpace(name: "SCROLL")
         .ignoresSafeArea(.container, edges: .vertical)
         */
        
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
                Text("Document the feeling with your prosthesis.")
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
                
                /*
                Image(systemName: cal.isCalendar ? "calendar" : "list.bullet.below.rectangle")
                    .foregroundColor(currentTheme.text)
                    .font(.title3)
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.5)){
                            cal.isCalendar.toggle()
                        }
                    }

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
    
    @ViewBuilder func GlockRow() -> some View {
        HStack(spacing: 10) {
          
            CalendarControl()
            
            Spacer()
            
            HStack(spacing: 10) {
                Button(action: {
                    withAnimation(.easeInOut) {
                        if appConfig.hasPro {
                            appConfig.PushNotificationDailyMoodRemembering.toggle()
                        } else {
                            appConfig.PushNotificationDailyMoodRemembering = true
                        }
                    }
                }, label: {
                    Image(systemName: appConfig.PushNotificationDailyMoodRemembering ? "bell" : "bell.slash")
                        .padding(.vertical, 5)
                        .font(.title3)
                        .foregroundColor( appConfig.hasPro ? appConfig.PushNotificationDailyMoodRemembering ? currentTheme.hightlightColor : currentTheme.textGray : currentTheme.textGray)
                })
                .disabled(!appConfig.hasPro)
               
                
                if appConfig.PushNotificationDailyMoodRemembering {
                    Button {
                        withAnimation {
                            showTimePicker.toggle()
                        }
                    }  label: {
                        Text(appConfig.PushNotificationDailyMoodRememberingDate.dateFormatte(date: "", time: "HH:mm").time)
                            .padding(.vertical, 5)
                            .foregroundColor(currentTheme.text)
                    }
                    .offset(x: appConfig.PushNotificationDailyMoodRemembering ? 0 : 150)
                    .background(
                        DatePicker("", selection: $appConfig.PushNotificationDailyMoodRememberingDate, displayedComponents: .hourAndMinute)
                            .datePickerStyle(.wheel)
                            .frame(width: 200, height: 100)
                            .clipped()
                            .background(currentTheme.textGray.cornerRadius(10))
                            .opacity(showTimePicker ? 1 : 0 )
                            .offset(x: -65, y: 90)
                    )
                    .onChange(of: appConfig.PushNotificationDailyMoodRememberingDate, perform: { new in
                        showTimePicker.toggle()
                    })
                }

            }
        }
        .padding(.horizontal)
        .zIndex(1)
    }
    
    @ViewBuilder func CalendarControl() -> some View {
        HStack(spacing: 10) {
          if !cal.showCalendarPicker {
              
              Button(action: {
                  cal.selectedCalendarDate = Calendar.current.date(byAdding: .month, value: -1, to: cal.selectedCalendarDate)!
              }, label: {
                  Image(systemName: "chevron.left")
                      .font(.headline)
                      .foregroundColor(currentTheme.text)
                      .padding()
              })
              
              Button(action: {
                  withAnimation(.easeInOut){
                      cal.showCalendarPicker = true
                  }
              }, label: {
                  Text(cal.currentDate.dateFormatte(date: "MMM yyyy", time: "").date)
                      .foregroundColor(currentTheme.text)
              })
              
              Button(action: {
                  cal.selectedCalendarDate = Calendar.current.date(byAdding: .month, value: +1, to: cal.selectedCalendarDate)!
              }, label: {
                  Image(systemName: "chevron.right")
                      .font(.headline)
                      .foregroundColor(currentTheme.text)
                      .padding()
              })
              
              Spacer()
          }
        }
    }
    
}
