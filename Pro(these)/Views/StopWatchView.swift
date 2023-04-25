//
//  StopWatchView.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 25.04.23.
//

import SwiftUI

struct StopWatchView: View {
    @EnvironmentObject var stopWatchManager: StopWatchManager
    
    @State var selectedDetent: PresentationDetent = .large
    @State var isShowListSheet = false

    var body: some View {
        GeometryReader { proxy in
            VStack {
                ring()
                    .frame(width: (proxy.size.width/2))
                
                HStack {
                    ZStack {
                        Circle()
                            .fill(.white)
                            .frame(width: 60)
                        
                        Button(stopWatchManager.isRunning ? "Stop" : "Start"){
                            if stopWatchManager.isRunning {
                                stopWatchManager.stop()
                             } else {
                                 stopWatchManager.start()
                             }
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                   // EditButton()
                }
                ToolbarItem {
                    Button(action: { isShowListSheet.toggle() }) {
                        Label("", systemImage: "list.star")
                    }
                }
            }
            .sheet(isPresented: $isShowListSheet) {
                ListSheetContent()
                    .presentationDetents([.medium, .large], selection: $selectedDetent)
                    .presentationDragIndicator(.visible)
            }
            .fullSizeCenter()
        }
        .fullSizeCenter()
    }

    
    @ViewBuilder
    func ring() -> some View {
        let angleGradient = AngularGradient(colors: [.white.opacity(0.5), .blue.opacity(0.5)], center: .center, startAngle: .degrees(-90), endAngle: .degrees(360))
        
        ZStack {
            
            if stopWatchManager.isRunning {

                Text(stopWatchManager.fetchStartTime()!, style: .timer)
                   .font(.largeTitle)
                   .fontWeight(.medium)
                   .foregroundColor(.white)
                
            } else {
               Text("0:00")
                    .font(.system(size: 50))
            }
            
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 5))
                .foregroundStyle(.white)
                .overlay {
                    // Foreground ring
                    Circle()
                        .trim(from: 0, to: 0.5 )
                        .stroke(angleGradient, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                }
                .rotationEffect(.degrees(-90))
        }
        .padding(.bottom, 20)
        
        HStack{
            Spacer()
            VStack(alignment: .center){
                Text(stopWatchManager.totalProtheseTimeYesterday)
                    .font(.system(size: 35))
                Text("Gester")
                    .foregroundColor(.gray)
            }
            Spacer()
            VStack(alignment: .center){
                Text(stopWatchManager.totalProtheseTimeToday)
                    .font(.system(size: 35))
                Text("Heute")
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.bottom, 20)
    }
    
    @ViewBuilder
    func ListSheetContent() -> some View {
        List {
            HStack{
                Spacer()
                VStack(alignment: .center){
                    Text(stopWatchManager.totalProtheseTimeYesterday)
                        .font(.system(size: 35))
                    Text("Gester")
                        .foregroundColor(.gray)
                }
                Spacer()
                VStack(alignment: .center){
                    Text(stopWatchManager.totalProtheseTimeToday)
                        .font(.system(size: 35))
                    Text("Heute")
                        .foregroundColor(.gray)
                }
                Spacer()
            }
            .listRowBackground(Color.white.opacity(0.01))
            
            HStack{
                Text("Aufgezeichnete Zeit")
                Spacer()
                Text("Datum")
            }
            .listRowBackground(Color.white.opacity(0.2))

            
            ForEach(stopWatchManager.timesArray) { time in
                HStack {
                    Text(time.duration!)
                    Spacer()
                    Text("\(time.timestamp!.formatted(.dateTime.hour().minute())) Uhr -")
                    Text("\(time.timestamp!.formatted(.dateTime.day().month()))")
                    
                }
                .listRowBackground(Color.white.opacity(0.05))
            }
            .onDelete(perform: stopWatchManager.deleteItems)
            
        }
        .refreshable {
            do {
                stopWatchManager.refetchTimesData()
            }
        }
        .background{
            AppConfig().backgroundGradient
        }
        .ignoresSafeArea()
        .scrollContentBackground(.hidden)
        .foregroundColor(.white)
    }
    
}


struct StopWatchView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            AppConfig().backgroundGradient
                .ignoresSafeArea()
            
            StopWatchView()
        }
    }
}
