//
//  ControlView.swift
//  ProWatchOS Watch App
//
//  Created by Frederik Kohler on 10.05.23.
//

import SwiftUI

struct ControlView: View {
    
    @EnvironmentObject var workoutManager: WorkoutManager
    
    var body: some View {
        VStack(alignment: .center, spacing: 20){
            Spacer()
            
            HStack{
                VStack {
                    Button {
                       workoutManager.endWorkout()
                    } label: {
                       Image(systemName: "xmark")
                    } //: BUTTON
                    .tint(.red)
                } //: VSTACK
                
                VStack {
                    Button {
                        workoutManager.togglePuase()
                    } label: {
                        Image(systemName: workoutManager.running ? "pause" : "play")
                    } //: BUTTON
                    .tint(.yellow)
                } //: VSTACK

            } //: HSTACK
            
            Spacer()
        } //:VSTACK
    }
}

struct ControlView_Previews: PreviewProvider {
    static var previews: some View {
        ControlView()
            .environment(\.locale, Locale(identifier: "de"))
    }
}
