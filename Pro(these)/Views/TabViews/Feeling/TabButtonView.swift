//
//  TabButtonView.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 18.05.23.
//

import SwiftUI

struct TabButtonView: View {
    var title: String
    var animation: Namespace.ID
    @Binding var currentTab: String
    
    var body: some View {
        Button(action: { currentTab = title }, label: {
            Text(title)
                .fontWeight(.bold)
                .foregroundColor(currentTab == title ? .white : .black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
               
                .background(
                    ZStack{
                        if currentTab == title {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.black)
                                .matchedGeometryEffect(id: "Tab", in: animation)
                        }
                    }
                )
        })
        
        
    }
}

