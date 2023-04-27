//
//  SettingToggleButton.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 27.04.23.
//

import SwiftUI

struct SettingToggleButton: View {
    var image:String
    var toggleDescrition:String
    var info: String
    @Binding var storeBinding: Bool
    
    var body: some View {
        HStack(){
            // Image
            VStack(){
                Image(systemName: image)
                    .frame(width: 20, height: 20)
                    .foregroundColor(AppConfig().foreground.opacity(0.5))
            }
            .padding(20)
            .background(AppConfig().background)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(AppConfig().foreground.opacity(0.5), lineWidth: 2)
            )
            .frame(maxWidth: 50)
            
            HStack{
                VStack(alignment: .leading){
                    Text(toggleDescrition)
                        .font(.body)
                        .fontWeight(.medium)
                        .padding(.bottom, 1)

                    Text(info)
                        .font(.caption2)
                        .foregroundColor(AppConfig().fontLight)
                }
            }
            .padding(.leading, 2)
            .frame(maxWidth: .infinity)
            
            VStack{
                Toggle("", isOn: $storeBinding)
                    .toggleStyle(SwitchToggleStyle(tint: .green))
            }
            .frame(maxWidth: 50)
            
        }
        .frame(maxWidth: .infinity ,alignment: .leading)
        .padding(.all, 15.0)
        .background(AppConfig().background.opacity(0.5))
        .cornerRadius(10)
    }
}

struct SettingToggleButton_Previews: PreviewProvider {
    static var previews: some View {
        SettingToggleButton(image: "info", toggleDescrition: "desc", info: "info", storeBinding: AppConfig().$ChartLineDistanceIsShowing)
    }
}
