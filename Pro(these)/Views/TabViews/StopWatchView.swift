//
//  WorkOutEntryView.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 19.05.23.
//

import SwiftUI

struct StopWatchView: View {
    @StateObject var stopWatchProvider = StopWatchProvider()
    @StateObject var tabManager = TabManager()
    @StateObject var workoutStatisticViewModel = WorkoutStatisticViewModel()
    
    var body: some View {
        GeometryReader { screen in
           
            ZStack{
                RadialGradient(gradient: Gradient(colors: [
                    Color(red: 5/255, green: 5/255, blue: 15/255).opacity(0.7),
                    Color(red: 5/255, green: 5/255, blue: 15/255).opacity(1)
                ]), center: .center, startRadius: 50, endRadius: 300)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    HeaderComponent()
                        .padding(.top, 20)
                    
                    StopWatchRecordView().padding(.horizontal).environmentObject(stopWatchProvider)
                    
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            
        }
    }
}

struct StopWatchRecordView: View {
    @EnvironmentObject var stopWatchProvider: StopWatchProvider
    @EnvironmentObject var tabViewManager: TabManager
    var body: some View {
        ZStack {

            VStack {
                
                Spacer()
                
                HStack{
                    Spacer()
                    if stopWatchProvider.recorderState == .started {
                        
                        Text(stopWatchProvider.recorderStartTime!, style: .timer)
                            .font(.system(size: 50))
                            .italic()
                            .fontWeight(.bold)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                        
                    }
                    if stopWatchProvider.recorderState == .notStarted {
                        Text("")
                            .font(.system(size: 50))
                    }
                    Spacer()
                }
                
                HStack(spacing: 15){
                   Image(systemName: "gear")
                       .font(.system(size: 20))
                       .foregroundColor(.black)
                       .frame(width: 50, height: 50)
                       .background(
                           Circle()
                               .fill(Color.yellow)
                               .frame(width: 50, height: 50)
                       )
                       .onTapGesture {
                           tabViewManager.isSettingSheet.toggle()
                       }
                   
                    Text( stopWatchProvider.recorderState == .started ? "END" : "START" )
                        .font(Font.system(size: 20))
                        .italic()
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .frame(width: 75, height: 75)
                        .background(
                           Circle()
                               .fill(Color.yellow)
                                .frame(width: 75, height: 75)
                        )
                        .onTapGesture {
                            switch stopWatchProvider.recorderState {
                            case .started : stopWatchProvider.stopRecording()
                            case .notStarted:  stopWatchProvider.startRecording()
                            case .finished:
                                break
                            }
                           
                        }
                   
                   
                   Image(systemName: "music.note")
                       .font(.system(size: 20))
                       .foregroundColor(.black)
                        .frame(width: 50, height: 50)
                       .background(
                           Circle()
                               .fill(Color.yellow)
                               .frame(width: 50, height: 50)
                       )
               }
                .padding(.bottom, 30)
            }
            .onAppear{
                if stopWatchProvider.recorderFetchStartTime() != nil {
                    stopWatchProvider.recorderState = .started
                    stopWatchProvider.recorderStartTime = stopWatchProvider.recorderFetchStartTime()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

