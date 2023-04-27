//
//  HomeView.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 27.04.23.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 20){
            
            Header(name: AppConfig().username, target: AppConfig().targetSteps)
            
            GeometryReader { proxy in
                carusell(screenSize: proxy)
            }
            
            Text(NSUserName())
            
            Text(NSFullUserName())
            
            Spacer()
            
        }
    }
        
    @ViewBuilder
        func Header(name: String, target: Int) -> some View {
            HStack(){
                VStack {
                    Text("Hallo \(AppConfig().username)")
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Dein Tagesziel ist für heute \(target) Schritte")
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
    
    @ViewBuilder
    func carusell(screenSize: GeometryProxy) -> some View {
        let screenSize = screenSize.size
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 20){
                ForEach(ScrollItem.sampleItems){ item in
                    SliderItem(titel: item.titel, size: screenSize.width)
                }
            }
        }
        .frame(height: 300)
    }
    
    @ViewBuilder
    func SliderItem(titel:String, size: CGFloat) -> some View {
        ZStack {
            VStack(){
                Text(titel)
                    .foregroundColor(.white)
            }
            .frame(width: 300, height: 300)
            .background(.red)
        }
        .frame(width: size)
    }
}

struct ScrollItem: Identifiable {
    var id: String { titel }
    let titel: String
    var bg: Color
    
    static let sampleItems = [
        ScrollItem(titel: "asd", bg: .red),
        ScrollItem(titel: "eer", bg: .orange),
    ]
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
