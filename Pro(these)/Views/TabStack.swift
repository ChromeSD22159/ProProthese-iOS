//
//  TabStack.swift
//  Pro Prothese
//
//  Created by Frederik Kohler on 23.04.23.
//

import SwiftUI

struct TabStack: View {
    @Namespace var TabbarAnimation
    
    @EnvironmentObject private var tabManager: TabManager
    
    var body: some View {
        HStack(spacing: 10){
            ForEach(Tab.allCases, id: \.self){ tab in
                VStack {
                    if tab == .timer {
                        Image(tab.TabIcon())
                            .imageScale(.large)
                            .font(Font.system(size: 28, weight: .regular))
                            .foregroundColor(tabManager.currentTab == tab ? .white : .white.opacity(0.8))
                            .frame(width: 28, height: 28)
                    } else {
                        Image(systemName: tab.TabIcon())
                            .renderingMode(.template)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(tabManager.currentTab == tab ? .white : .white.opacity(0.8))
                            .frame(width: 28, height: 28)
                    }
                    
                    if tabManager.currentTab == tab {
                        Circle()
                            .fill(.white)
                            .frame(width:5, height: 5)
                            .offset(y: 10)
                            .matchedGeometryEffect(id: "TAB", in: TabbarAnimation)
                    }
                }
                .onTapGesture {
                    withAnimation(.easeInOut){
                        tabManager.currentTab = tab
                    }
                }
            }
            .frame(maxWidth: .infinity)
            
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(AppConfig().backgroundLabel.opacity(0.1))
    }
}

struct TabStack_Previews: PreviewProvider {
    static var previews: some View {
        TabStack()
    }
}
