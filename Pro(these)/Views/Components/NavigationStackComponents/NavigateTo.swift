//
//  NavigateTo.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 27.04.23.
//

import SwiftUI

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
            label: { link }
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
