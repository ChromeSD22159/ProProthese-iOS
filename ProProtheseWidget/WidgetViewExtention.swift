//
//  ViewExtention.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 19.09.23.
//

import SwiftUI

extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
            if #available(iOSApplicationExtension 17.0, *) {
                return containerBackground(for: .widget) {
                    backgroundView
                }
            } else {
                return background(backgroundView)
            }
        }
}
