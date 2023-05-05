//
//  HeaderComponent.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 27.04.23.
//

import SwiftUI

struct HeaderComponent: View {
    @EnvironmentObject var appConfig: AppConfig
    @EnvironmentObject var tabManager: TabManager
    var body: some View {
        HStack(){
            VStack(spacing: 2) {
                Text(sayHallo(name: appConfig.username) )
                    .font(.title2)
                    .foregroundColor(appConfig.fontColor)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("Dein Tagesziel ist für heute \(appConfig.targetSteps) Schritte")
                    .font(.callout)
                    .foregroundColor(appConfig.fontLight)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            VStack(){
                Image(systemName: "gearshape")
                    .foregroundColor(appConfig.fontColor)
                    .onTapGesture {
                        tabManager.isSettingSheet.toggle()
                    }
            }
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
    }
    
    func sayHallo(name: String) -> String {
        //let hour = Calendar.current.component(.hour, from: Date())

        /*
         switch hour {
         case 0..<12 : return "Guten Morgen, \(name)!"
         case 12 : return "Guten Tag, \(name)!"
         case 13..<17 : return "Hallo \(name)!"
         case 17..<0 : return "Guten Abend, \(name)!"
         default: return "Hallo, \(name)!"
         }
         */
        return "Hallo, \(name)!"
    }
}

struct HeaderComponent_Previews: PreviewProvider {
    static var previews: some View {
        HeaderComponent()
    }
}
