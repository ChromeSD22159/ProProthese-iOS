//
//  NavigationStackView.swift
//  Pro Prothese
//
//  Created by Frederik Kohler on 23.04.23.
//

import SwiftUI

let ListStacks = [
    MoreListStaks(title: "Schrittzähler", backgroundColor: AppConfig().background, foregroundColor: AppConfig().foreground),
    MoreListStaks(title: "Terminplaner", backgroundColor: AppConfig().background, foregroundColor: AppConfig().foreground),
    MoreListStaks(title: "Timer", backgroundColor: AppConfig().background, foregroundColor: AppConfig().foreground),
    MoreListStaks(title: "Liner", backgroundColor: AppConfig().background, foregroundColor: AppConfig().foreground),
    MoreListStaks(title: "Planer", backgroundColor: AppConfig().background, foregroundColor: AppConfig().foreground),
    MoreListStaks(title: "Einstellungen", backgroundColor: AppConfig().background, foregroundColor: AppConfig().foreground)
  ]

struct NavigationStackView: View {
    @EnvironmentObject var app: AppConfig
    @EnvironmentObject private var tabManager: TabManager
    
    var body: some View {
        ZStack {
           
            AppConfig().backgroundGradient
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    Spacer()
                    
                    ForEach(ListStacks, id: \.self) { stack in
                        NavigateTo( {
                            Link(buttonText: stack.title, foregroundColor: stack.foregroundColor)
                        }, {
                            DetailView(title: stack.title, backgroundColor: AppConfig().backgroundGradient, foregroundColor: stack.foregroundColor)
                        })
                    }
                    
                    NavigateTo( {
                        Link(buttonText: "Eigenbau Test", foregroundColor: AppConfig().foreground)
                    }, {
                        ZStack {
                            AppConfig().backgroundGradient
                                .ignoresSafeArea()
                            
                            ScrollView(showsIndicators: false) {
                                VStack(spacing: 20){
                                    HStack{
                                        Text("Eigenbau Test")
                                            .foregroundColor(.white)
                                    }
                                    
                                    HStack{}
                                    .frame(height: 200)
                                    .frame(maxWidth: .infinity)
                                    .background(.red)
                                    
                                    HStack{}
                                    .frame(height: 200)
                                    .frame(maxWidth: .infinity)
                                    .background(.red)
                                    
                                    HStack{}
                                    .frame(height: 200)
                                    .frame(maxWidth: .infinity)
                                    .background(.red)
                                    
                                    HStack{}
                                    .frame(height: 200)
                                    .frame(maxWidth: .infinity)
                                    .background(.red)
                                }
                                .padding(.top, 80)
                            }
                            .ignoresSafeArea()
                            .padding(.horizontal)
                        }
                    })
                
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    @ViewBuilder
    func DetailView(title: String, backgroundColor: LinearGradient, foregroundColor: Color) -> some View {
        ZStack {
            backgroundColor
                .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20){
                    HStack{
                        Text(title)
                            .foregroundColor(.white)
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


struct NavigateTo<Link: View, DetailView: View>: View {
    @State private var isShowingNavigation = false
    
    let link:           Link
    let detailView:     DetailView
    
    init(
        @ViewBuilder _ link:            () -> Link,
        @ViewBuilder _ detailView:      () -> DetailView
    ) {
        self.link           = link()
        self.detailView     = detailView()
    }
    
    var body: some View {
        NavigationLink(
            destination: detailViewBody()
                .navigationBarBackButtonHidden(true),
            isActive: $isShowingNavigation,
            label: {
                link
            }
        )
    }
    
    @ViewBuilder
    func detailViewBody() -> some View {
        ZStack{
            VStack {
                detailView
            }
            
            VStack{
                HStack(){
                    BackBTN(size: 30, foreground: .white, background: .black)
                        .onTapGesture {
                            isShowingNavigation = false
                        }
                    Spacer()
                }
                .ignoresSafeArea()
                Spacer()
            }
            .padding()
        }
    }
}

struct BackBTN: View {
    var size: CGFloat
    var foreground: Color?
    var background: Color?
    
    var body: some View {
        ZStack{
            ZStack {
                Image(systemName: "chevron.left.circle")
                    .foregroundColor(foreground ?? .white)
                    .font(.system(size: size))
                
            }.background(
                GlassBackGround(width: size, height: size, color: background ?? .black)
                    .shadow(color: .black, radius: size, x: 2, y: 2)
            )
            
            
        }
    }
}

struct GlassBackGround: View {

    let width: CGFloat
    let height: CGFloat
    let color: Color

    var body: some View {
        ZStack{
            RadialGradient(colors: [.clear, color],
                           center: .center,
                           startRadius: 1,
                           endRadius: 100)
                .opacity(0.6)
            Rectangle().foregroundColor(color)
        }
        .opacity(0.2)
        .blur(radius: 2)
        .cornerRadius(10)
        .frame(width: width, height: height)
    }
}

struct NavigationStackView_Previews: PreviewProvider {
    static var previews: some View {
       
        VStack{
            NavigationStackView()
        }
    }
}

