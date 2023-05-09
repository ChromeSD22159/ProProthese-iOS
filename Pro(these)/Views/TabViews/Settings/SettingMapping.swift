//
//  SettingMapping.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 27.04.23.
//

import SwiftUI
// MARK: DEV TESTING Items
struct MoreViewList: Identifiable {
    var id: String { titel }
    var titel: String
    var backgroundGradient: LinearGradient
    var foregroundColor: Color
    
    static let items = [
        MoreViewList(titel: "Schrittzähler", backgroundGradient: AppConfig().backgroundGradient, foregroundColor: AppConfig().foreground),
        MoreViewList(titel: "Terminplaner", backgroundGradient: AppConfig().backgroundGradient, foregroundColor: AppConfig().foreground),
        MoreViewList(titel: "Timer", backgroundGradient: AppConfig().backgroundGradient, foregroundColor: AppConfig().foreground),
        MoreViewList(titel: "Liner", backgroundGradient: AppConfig().backgroundGradient, foregroundColor: AppConfig().foreground),
        MoreViewList(titel: "Planer", backgroundGradient: AppConfig().backgroundGradient, foregroundColor: AppConfig().foreground),
    ]
}

// MARK: Settings Items
struct Settings: Identifiable {
    var id: String { titel }
    var titel: String
    var options: [Options]
    
    static var items = [
        Settings(
            titel: "Schritte",
            options: [
                Options(titel: "Tages Ziel in Chart", icon: "target", desc: "Zeige erfüllte Tagesziele an", info: "Zeigt den Record Button auch auf der Schrittüberischt an.", binding: AppConfig().$ChartBarIsShowing),
                Options(titel: "Schritte in Chart", icon:  "figure.walk", desc:  "Zeige Schritte", info: "Zeigt den Record Button auch auf der Schrittüberischt an.", binding: AppConfig().$ChartLineStepsIsShowing),
                Options(titel: "Distanz in Chart", icon:  "figure.walk.diamond", desc:  "Zeige Distance", info: "Zeigt den Record Button auch auf der Schrittüberischt an.", binding: AppConfig().$ChartLineDistanceIsShowing),
                Options(titel: "Durchschnittliche Schritte", icon: "waveform", desc: "Zeige Durchschnittliche Schritte", info: "Zeigt den Record Button auch auf der Schrittüberischt an.", binding: AppConfig().$stepRuleMark),
                Options(titel: "Mini StopWatch im Schrittzähler", icon: "stopwatch", desc: "Aktiviere eine mini StopWatch im Schrittzähler", info: "Aktiviere eine mini StopWatch im Schrittzähler", binding: AppConfig().$ShowRecordOnHomeView)
            ]
        ),
        
        Settings(
            titel: "StopWatch", options: [
                Options(titel: "Mini StopWatch im Schrittzähler", icon: "stopwatch", desc: "Aktiviere eine mini StopWatch im Schrittzähler", info: "Aktiviere eine mini StopWatch im Schrittzähler", binding: AppConfig().$ShowRecordOnHomeView),
                
                Options(titel: "Prozentuale Tragezeit zum Durchschnitt", icon: "stopwatch", desc: "Prozentuale Tragezeit zum Durchschnitt", info: "Zeige die Prozentuale Tragezeit im Vergleich zur Durchschnittlichen Tragezeit.", binding: AppConfig().$ShowToDayRecordingPercentageToAvg)
            ]),
        
        Settings(
            titel: "Terminplaner", options: [
                Options(titel: "Zeige abgelaufene Termine", icon: "stopwatch", desc: "Zeige alle abgelaufene Termine Sortiert an.", info: "Zeige alle abgelaufene Termine Sortiert an.", binding: AppConfig().$showPastEvents),
                Options(titel: "Zeige alle Termine", icon: "stopwatch", desc: "Zeige alle Termine Sortiert an.", info: "Zeige alle Termine Sortiert an.", binding: AppConfig().$showAllEvents)
            ])
    ]
    
}

struct Options : Identifiable {
    var id: String { titel }
    var titel: String
    let icon: String
    var desc: String
    var info: String
    var binding: Binding<Bool>
}
