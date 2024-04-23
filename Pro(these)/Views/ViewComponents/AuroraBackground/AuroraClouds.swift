//
//  AuroraClouds.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 21.09.23.
//

import SwiftUI

struct AuroraClouds: View {
    
    @StateObject var provider = CloudProvider()
    @State var move = false
    let proxy: GeometryProxy
    @Binding var color: Color
    var colorOpacity: Double
    let rotationStart: Double
    let duration: Double
    let alignment: Alignment
    let timerDuration = 1.0
    let timer = Timer.publish(every: 1.0, on: .main, in: .common).autoconnect()
    
    var randomScale: Double {
        Double.random(in: 1.0...2.4)
    }
    
    var body: some View {
        Circle()
            .fill(color.opacity(colorOpacity))
            .frame(height: proxy.size.height /  provider.frameHeightRatio)
            .offset(provider.offset)
            .rotationEffect(.init(degrees: move ? rotationStart : rotationStart + 360) )
        
            .animation(Animation.linear(duration: duration).repeatForever(autoreverses: false), value: move)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
            .opacity(AppConfig.shared.AuroraOpacity)
            .onAppear {
                move.toggle()
            }
        
    }
}

class CloudProvider: ObservableObject {
    let offset: CGSize
    let frameHeightRatio: CGFloat
    init() {
        frameHeightRatio = CGFloat.random(in: 0.7 ..< 1.4)
        offset = CGSize(
            width: CGFloat.random(in: -150 ..< 150),
            height: CGFloat.random(in: -150 ..< 150)
        )
    }
}

struct FloatingClouds: View {
    @EnvironmentObject var appConfig: AppConfig
    var currentTheme: Theme
    
    @State var hightlightColor: Color
    
    var blur: Double
    var speed: Double
    var opacity: Double
    var show: [showClouds]
    
    init(blur: Double? = nil, speed: Double? = nil, opacity: Double? = nil, show: [showClouds]? = nil, currentTheme: Theme ) {
        self.blur = blur ?? 1.0
        self.speed = speed ?? 1.0
        self.opacity = opacity ?? 1.0
        self.show = show ?? [.topTrailing, .topLeading, .bottomTrailing, .bottomLeading]
        self.currentTheme = currentTheme
        self.hightlightColor = currentTheme.hightlightColor
    }
    
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                
                AuroraClouds(proxy: proxy,
                    color: $hightlightColor,
                    colorOpacity: 1,
                    rotationStart: 0,
                    duration: 60 * speed,
                    alignment: .bottomTrailing
                )
                .opacity(show.filter( { $0 == .bottomTrailing }).count > 0 ? opacity : 0)
                
                AuroraClouds(proxy: proxy,
                     color: $hightlightColor,
                     colorOpacity: 0.5,
                     rotationStart: 240,
                     duration: 50 * speed,
                     alignment: .topTrailing
                )
                .opacity(show.filter( { $0 == .topTrailing }).count > 0 ? opacity : 0)
                
                
                AuroraClouds(proxy: proxy,
                     color: $hightlightColor,
                     colorOpacity: 0.5,
                     rotationStart: 120,
                     duration: 80 * speed,
                     alignment: .bottomLeading
                )
                .opacity(show.filter( { $0 == .bottomLeading }).count > 0 ? opacity : 0)
                
                AuroraClouds(proxy: proxy,
                     color: $hightlightColor,
                     colorOpacity: 1.0,
                     rotationStart: 180,
                     duration: 70 * speed,
                     alignment: .topLeading
                )
                .opacity(show.filter( { $0 == .topLeading }).count > 0 ? opacity : 0)
            }
            .blur(radius: 60 * blur)
            .ignoresSafeArea()
            .onAppear {
                hightlightColor = getTheme().hightlightColor
            }.onChange(of: appConfig.currentTheme) { new in
                hightlightColor = getTheme().hightlightColor
            }
        }
    }
    
    func getTheme() -> Theme {
        switch appConfig.currentTheme {
            case "blue" : return .blue
            case "green" : return .green
            case "orange" : return .orange
            case "pink" : return .pink
            default: return .blue
        }
    }
}

enum showClouds {
    case topTrailing
    case topLeading
    case bottomTrailing
    case bottomLeading
    case all
}
