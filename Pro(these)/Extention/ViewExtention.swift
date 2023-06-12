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
    
    func blurredSheet<Content:View>(_ style: AnyShapeStyle, show: Binding<Bool>, onDismiss: @escaping ()->(), @ViewBuilder content: @escaping ()-> Content) -> some View { self
       .sheet(isPresented: show, onDismiss: onDismiss) {
           content()
               .background(RemoveBackgroundColor())
               .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
               .background(
                   Rectangle()
                       .fill(style)
                       .ignoresSafeArea(.container, edges: .all)
               )
       }
    }
    
    func blurredOverlaySheet<Content:View>(_ style: AnyShapeStyle, show: Binding<Bool>, onDismiss: @escaping ()->(), @ViewBuilder content: @escaping ()-> Content) -> some View { self
       .fullScreenCover(isPresented: show, onDismiss: onDismiss) {
           content()
               .background(RemoveBackgroundColor())
               .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
               .background(
                   Rectangle()
                       .fill(style)
                       .ignoresSafeArea(.container, edges: .all)
               )
       }
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

struct RemoveBackgroundColor: UIViewRepresentable {
    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            uiView.superview?.superview?.backgroundColor = .clear
        }
    }
    
    func makeUIView(context: Context) -> UIView {
        return UIView()
    }
}
