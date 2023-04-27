//
//  HeaderComponent.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 27.04.23.
//

import SwiftUI

struct HeaderComponent: View {
    var body: some View {
        HStack(){
            VStack {
                Text("Hallo \(AppConfig().username)")
                    .font(.title3)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Dein Tagesziel ist für heute \(AppConfig().targetSteps) Schritte")
                    .font(.callout)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            VStack(){
                Image(systemName: "info.circle")
                    .font(.largeTitle)
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
    }
}

struct HeaderComponent_Previews: PreviewProvider {
    static var previews: some View {
        HeaderComponent()
    }
}
