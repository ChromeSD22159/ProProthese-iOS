//
//  Step.swift
//  Pro Prothese
//
//  Created by Frederik Kohler on 23.04.23.
//

import SwiftUI

struct Step: Identifiable {
    let id = UUID()
    let count: Int
    let date: Date
    let dist : Double?
}

