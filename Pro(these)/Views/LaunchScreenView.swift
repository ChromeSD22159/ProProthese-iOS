//
//  LaunchScreenView.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 09.05.23.
//

import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        ZStack{
            Image("LaunchImage")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
                .ignoresSafeArea()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .ignoresSafeArea()
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
