//
//  BackgroundBlurTop.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 12.05.23.
//

import SwiftUI

struct HeaderBackgroundBlurTop: View {
    var body: some View {
        // MARK: - Background Header blur
        VStack {
            HStack {
                Spacer()
            }
            .frame(height: 50)
            .background(Color(red: 5/255, green: 5/255, blue: 15/255))
            .blur(radius: 5, opaque: false)
            .offset(y: -60)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}
