//
//  PushNotifications.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 25.04.23.
//

import SwiftUI

class PushNotifications {
    
    var ComeBack:[String: String] = [
        "identifier" : "PROTHESE_COMEBACK_REMINDER",
        "titel": "Wir haben dich heute noch nicht gesehen 😢",
        "body": "Komm bald wieder vorbei, es wird Spannend ✌️",
        "triggerTimer": "20"
    ]
    
    var MoodReminder:[String: String] = [
        "identifier" : "PROTHESE_MOOD_REMINDER",
        "titel": "Erzähle mir von deinem Tag 🦾 🦾 ",
        "body": "Hinterlasse keine leere Seite in deinem Prothesentagebuch. ✌️",
        "triggerHour": "20",
        "triggerMinute": "30",
        "repeater": "true"
    ]
    
    var GoodMorning:[String: String] = [
        "identifier" : "PROTHESE_MOOD_GOOD_MORNING",
        "titel": "Starte gut in den Tag 🦾 🦾",
        "body": "Denke an dein Prothesentagebuch und träge brav deine Zeit. ✌️",
        "triggerHour": "7",
        "triggerMinute": "30",
        "repeater": "true"
    ]
    
}
