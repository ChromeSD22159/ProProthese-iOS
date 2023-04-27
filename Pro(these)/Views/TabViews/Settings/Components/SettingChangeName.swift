//
//  SettingChangeName.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 27.04.23.
//

import SwiftUI

struct SettingChangeName: View {
    var image: String
    var info: String
    var body: some View {
        HStack(){
            VStack(){
                Image(systemName: image)
                    .frame(width: 20, height: 20)
                    .foregroundColor(.white)
            }
            .padding(20)
            .background(AppConfig().background)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.white, lineWidth: 2)
            )
           
            VStack(alignment: .leading){
                Text("Dein Name")
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundColor(AppConfig().fontColor)
                    .toggleStyle(SwitchToggleStyle(tint: .green))
                    .padding(.bottom, 5)
                
                TextField("Name", text: AppConfig().$username)
                   .foregroundColor(.white)
                   .textFieldStyle(RoundedBorderTextFieldStyle())
                   .font(.body)
                   .fontWeight(.medium)
                   .foregroundColor(Color.white)
                   .toggleStyle(SwitchToggleStyle(tint: .green))
                   .padding(.bottom, 5)
            }
            .padding(.leading)
            
        }
        .frame(maxWidth: .infinity ,alignment: .leading)
        .padding(.all, 15.0)
        .frame(maxWidth: .infinity)
        .background(AppConfig().background.opacity(0.5))
        .cornerRadius(10)
    }
}
