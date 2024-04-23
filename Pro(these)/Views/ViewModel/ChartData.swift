//
//  ChartData.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 13.10.23.
//

import SwiftUI

struct ChartData: Identifiable, Hashable {
    var id = UUID()
    var date: Date
    var value: Double
}
