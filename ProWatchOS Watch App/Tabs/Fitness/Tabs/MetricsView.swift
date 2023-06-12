//
//  MetricsView.swift
//  ProWatchOS Watch App
//
//  Created by Frederik Kohler on 10.05.23.
//

import SwiftUI

struct MetricsView: View {

    @EnvironmentObject private var workoutManager: WorkoutManager

    var body: some View {
        VStack(alignment: .leading) {

            // MARK: TIMELINE VIEW, Timer
            TimelineView(
                MetricsTimelinesSchedule(from: workoutManager.builder?.startDate ?? Date())) { context in
                    VStack(alignment: .leading) {
                        TimerView(
                            elapsedTime: workoutManager.builder?.elapsedTime ?? 0,
                            showSubseconds: context.cadence == .live
                        )
                        .foregroundColor(.yellow)
                    }
                } //TimelineView
            
            HStack{
                // x bpm
                Text( Measurement( value: workoutManager.distance,  unit: UnitLength.meters )
                    .formatted( .measurement(width: .abbreviated,  usage: .road) )
                )
                
                Spacer()
                
                // xx km/h
                Text( Measurement( value: workoutManager.avgSpeed, unit: UnitSpeed.kilometersPerHour )
                    .formatted( .measurement(width: .abbreviated, usage: .asProvided) )
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.body)
            
            HStack{
                // x bpm
                Text( workoutManager.heartRate .formatted( .number .precision( .fractionLength(0) ) ) +  " bpm" )
                
                Spacer()
                
                Text( workoutManager.heartRate .formatted( .number .precision( .fractionLength(0) ) ) +  " bpm" )
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .font(.body)
            
            
        } //: VSTACK - PAGE WRAPPER
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(
            .system(.title, design: .rounded)
                .monospacedDigit()
                .lowercaseSmallCaps()
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        .ignoresSafeArea(edges: .bottom)
        .scenePadding()
    }
}

struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsView()
    }
}

// MARK: TIMELINE SCHEDULE FOR TIMER
private struct MetricsTimelinesSchedule: TimelineSchedule {

    var startDate: Date
    init(from startDate: Date) {
        self.startDate = startDate
    }

    func entries(from startDate: Date, mode: TimelineScheduleMode) -> PeriodicTimelineSchedule.Entries {
        PeriodicTimelineSchedule(
            from: self.startDate,
            by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0)
        )
            .entries(
                from: startDate,
                mode: mode
            )
    }

}
