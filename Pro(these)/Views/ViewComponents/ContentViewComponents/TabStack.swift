//
//  TabStack.swift
//  Pro Prothese
//
//  Created by Frederik Kohler on 23.04.23.
//

import SwiftUI

struct TabStack: View {
    @Namespace var TabbarAnimation
    
    @EnvironmentObject private var tabManager: TabManager
    @EnvironmentObject var cal: MoodCalendar
    @EnvironmentObject var event: EventManager
    @EnvironmentObject var pain: PainViewModel
    @EnvironmentObject var wsvm: WorkoutStatisticViewModel
    
    @StateObject var stopWatchProvider = StopWatchProvider()
    
    @Binding var activeTab:Tab
    @Binding var activeSubTab:SubTab
    @Binding var showSubTab:Bool
    
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
                        withAnimation(.easeInOut(duration: 0.3)){
                            showSubTab = false
                            activeTab = .healthCenter
                            cal.isCalendar = true
                            cal.addFeelingDate = Date()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            cal.isFeelingSheet = true
                            tabManager.workoutTab = .feelings
                        }
                    }
                
                Image(systemName: SubTab.stopWatch.TabIcon())
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(activeSubTab == .stopWatch ? .yellow : .yellow.opacity(0.8))
                    .frame(width: 28, height: 28)
                    .offset(y: -20)
                    .onTapGesture{
                        if stopWatchProvider.recorderState != .started {
                            stopWatchProvider.recorderState = .started
                            stopWatchProvider.startRecording()
                        }
                        
                        withAnimation(.easeInOut(duration: 0.3))   {
                            showSubTab = false
                            activeTab = .stopWatch
                        }
                        
                    }
                
                Image(systemName: SubTab.pain.TabIcon())
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(activeSubTab == .pain ? .yellow : .yellow.opacity(0.8))
                    .frame(width: 28, height: 28)
                    .offset(y: -20)
                    .onTapGesture{
                        withAnimation(.easeInOut(duration: 0.3)){
                            showSubTab = false
                            activeTab = .pain
                            pain.showList = true
                            pain.addPainDate = Date()
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            pain.isPainAddSheet = true
                        }
                    }
                
                Image(systemName: SubTab.event.TabIcon())
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(activeSubTab == .event ? .yellow : .yellow.opacity(0.8))
                    .frame(width: 28, height: 28)
                    .onTapGesture{
                        withAnimation(.easeInOut(duration: 0.3))   {
                            showSubTab = false
                            activeTab = .event
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            event.isAddEventSheet = true
                            event.addEventStarDate = Date()
                        }
                    }
            }
            .padding(.bottom)
            .opacity(showSubTab ? 1 : 0)
            .offset(y: showSubTab ? -70 : 100)
            
            // MainTab
            HStack(spacing: 10){
                ForEach(Tab.allCases, id: \.self){ tab in
                    VStack {
                        if tab == .add {
                            ZStack{
                                Circle()
                                    .fill(.yellow)
                                    .frame(width: 50, height: 50)
                                
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
                                .frame(width: 28, height: 28)
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
                        // Add Button
                        if tab == .add {
                            withAnimation(.easeInOut(duration: 0.3)){
                                showSubTab.toggle()
                            }
                        } else if tab == .healthCenter {
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
                        
                    }
                   
                }
                .frame(maxWidth: .infinity)
                
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(AppConfig().backgroundLabel.opacity(0.1))
        }
    }
}
/*
struct TabStack_Previews: PreviewProvider {
    static var previews: some View {
        TabStack(activeTab: .constant(.event), activeSubTab: .constant(.stopWatch))
    }
}
*/
