//
//  Mood.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 24.05.23.
//

import SwiftUI

struct Mood: Identifiable {
    var id = UUID().uuidString
    var image: String
    var name: String
    var color: Color
}

struct DateValue: Identifiable {
    var id = UUID().uuidString
    var day: Int
    var date: Date
}
