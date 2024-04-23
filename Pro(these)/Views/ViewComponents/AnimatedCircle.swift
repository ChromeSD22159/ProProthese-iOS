//
//  AnimatedCircle.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 24.09.23.
//

import SwiftUI

struct AnimatedCircle: View {
    @State var animate = false
    var size: CGFloat
    var color: Color
    var duration: TimeInterval? = nil
    var body: some View {
        VStack {
            ZStack {
                Circle().fill(color.opacity(0.05)).frame(width: size * 2 / 3 * 5, height: size * 2 / 3 * 5).scaleEffect(self.animate ? 1 : 0)
                Circle().fill(color.opacity(0.15)).frame(width: size * 2 / 3 * 4, height: size * 2 / 3 * 4).scaleEffect(self.animate ? 1 : 0)
                Circle().fill(color.opacity(0.25)).frame(width: size * 2, height: size * 2).scaleEffect(self.animate ? 1 : 0)
                Circle().fill(color).frame(width: size, height: size)
            }
            .onAppear { self.animate = true }
            .animation(animate ? Animation.easeInOut(duration: duration ?? 1.0).repeatForever(autoreverses: true) : .default, value: animate)
        }
    }
}
