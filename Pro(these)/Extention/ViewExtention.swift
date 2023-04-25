//
//  ViewExtention.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 25.04.23.
//

import SwiftUI

extension View {
    func fullSizeTop() -> some View {
        modifier(FullSizeTop())
    }
    
    func fullSizeCenter() -> some View {
        modifier(FullSizeCenter())
    }
}

struct FullSizeTop: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
}

struct FullSizeCenter: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }
}
