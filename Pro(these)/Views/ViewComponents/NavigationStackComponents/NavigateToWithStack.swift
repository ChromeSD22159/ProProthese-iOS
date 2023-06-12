//
//  NavigateToWithStack.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 27.04.23.
//

import SwiftUI

struct NavigateToWithStack<Link: View, DetailView: View>: View {
    @State private var isShowingNavigation = false
    @State private var isShowingButton = true
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
            destination: detailViewBody(isActive: $isShowingNavigation)
                .navigationBarBackButtonHidden(true),
            isActive: $isShowingNavigation,
            label: { link }
        )
    }
    
    @ViewBuilder
    func detailViewBody(isActive: Binding<Bool>) -> some View {
        ZStack {
            AppConfig().backgroundGradient
                .ignoresSafeArea()

            NavigationView {
                ZStack {
                    AppConfig().backgroundGradient
                        .ignoresSafeArea()
                    
                    VStack{
                        
                        ZStack{
                            HStack {
                                Spacer()
                                HStack{
                                    Text("Einstellungen")
                                        .foregroundColor(.white)
                                }
                                Spacer()
                            }
                            .ignoresSafeArea()
                            HStack(){
                                BackBTN(size: 30, foreground: .white, background: .black)
                                    .onTapGesture {
                                        isShowingNavigation = false
                                    }
                                
                                Spacer()
                            }
                            .ignoresSafeArea()
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                    
                    
                    detailView
                }
            }
        }
    }
    
}
