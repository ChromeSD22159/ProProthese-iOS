//
//  SettingsOverView.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 27.04.23.
//

import SwiftUI

struct SettingsDeteilsView: View {
    var titel: String
    var Options:[Options]
    var body: some View {
        ZStack {
            AppConfig().backgroundGradient
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20){
                    HStack{
                        Text(titel)
                            .foregroundColor(.white)
                    }
                    
                    ForEach(Options, id: \.id){ s in
                        SettingToggleButton(image:  s.icon, toggleDescrition: s.desc, info: s.info, storeBinding: s.binding)
                    }
                }
                .padding(.top, 80)
            }
            .ignoresSafeArea()
            .padding(.horizontal)
        }
    }
    
    @ViewBuilder
    func Link(buttonText: String, foregroundColor: Color) -> some View {
        HStack {
            HStack{
                Text(buttonText)
                    .foregroundColor(foregroundColor)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(AppConfig().backgroundLabel)
            .overlay(
                   RoundedRectangle(cornerRadius: 10)
                   .stroke(lineWidth: 2)
                   .stroke(foregroundColor)
           )
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 50)
    }
}


