//
//  NavigateTo.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 27.04.23.
//

import SwiftUI

struct NavigateTo<Link: View, DetailView: View>: View {
    @State private var isShowingNavigation = false
    @Binding var isExternBinding: Bool
    var extern: Bool
    let link:           Link
    let detailView:     DetailView
    let from: Tab
    @EnvironmentObject var themeManager: ThemeManager
    
    @EnvironmentObject var appConfig: AppConfig
    
    @EnvironmentObject var googleInterstitial: GoogleInterstitialAd
    
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    
    init(
        @ViewBuilder _ link:            () -> Link,
        @ViewBuilder _ detailView:      () -> DetailView,
        from: Tab,
        extern: Bool,
        isExtern: Binding<Bool>
    ) {
        self.link           = link()
        self.detailView     = detailView()
        self.from = from
        self.extern = extern
        _isExternBinding = isExtern
    }
    
    init(
        @ViewBuilder _ link:            () -> Link,
        @ViewBuilder _ detailView:      () -> DetailView,
        from: Tab
    ) {
        self.link           = link()
        self.detailView     = detailView()
        self.from = from
        self.extern = false
        _isExternBinding = .constant(false)
    }
    
    var body: some View {
        if extern {
            NavigationLink(
                destination: detailViewBody()
                    .navigationBarBackButtonHidden(true),
                isActive: $isExternBinding,
                label: { link }
            )
        } else {
            NavigationLink(
                destination: detailViewBody()
                    .navigationBarBackButtonHidden(true),
                isActive: $isShowingNavigation,
                label: { link }
            )
        }
    }
    
    @ViewBuilder func detailViewBody() -> some View {
        ZStack{
            VStack {
                detailView
            }
            
            VStack{
                HStack(){
                    BackBTN(size: 30, foreground: currentTheme.text, background: currentTheme.textBlack)
                        .onTapGesture {
                            if extern {
                                isExternBinding = false
                            } else {
                                isShowingNavigation = false
                            }
                            
                            appConfig.dismissNavigationLink = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                                googleInterstitial.showAd()
                            })
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

extension NavigateTo {
    
}
