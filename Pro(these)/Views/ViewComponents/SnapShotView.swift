//
//  SnapShotView.swift
//  Pro(these)
//
//  Created by Frederik Kohler on 30.05.23.
//

import SwiftUI


struct SnapShotView: View {
    @Environment(\.displayScale) var displayScale
    @State private var renderedImage = Image("SnapShotV1")
    
    @Binding var sheet: Bool
    
    var steps: String
    var distance: String
    var date: Date
    
    @State var saved = false
    
    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width - 40
            VStack {
                
                HStack {
                    Spacer()
                    ZStack{
                        Image(systemName: "xmark")
                            .font(.title2)
                            .padding()
                    }
                    .onTapGesture{
                        withAnimation(.easeInOut) {
                            sheet.toggle()
                        }
                    }
                }
                .padding()
                
                Spacer()
                
                ZStack{
                    
                    // background
                    renderedImage
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: width, height: width)
                        .cornerRadius(20)
                        .opacity(saved ? 0 : 1)
                    
                    // button
                    CaptureButton(screen: width)
                        .offset(y: -35)
                        .opacity(saved ? 0 : 1)
                    
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 50))
                        .foregroundColor(.white)
                        .opacity(saved ? 1 : 0)
                        .modifier(Shake(animatableData: CGFloat(saved ? 1 : 0 )))
                    
                }
                .frame(width: width, height: width)
                  
                
                Spacer()
            }
            .padding(.horizontal)
            .background(.ultraThinMaterial)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            .onAppear {
                render(width: width, steps: steps, distance: distance, date: date)
            }
        }
    }
    
    
    @ViewBuilder
    func CaptureButton(screen: CGFloat) -> some View {
        ZStack {
            VStack(alignment: .leading){
                HStack(alignment:.top) {
                    Image(systemName: "camera.fill")
                        .foregroundColor(.black)
                        .font(.system(size: screen / 12, design: .default))
                        .background(
                            Circle()
                                .fill(.white)
                                .frame(width:screen / 6, height: screen / 6)
                        )
                        .onTapGesture {
                            let image = renderedImage.asImage()

                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)

                            withAnimation(.easeInOut(duration: 0.3)){
                                saved.toggle()
                            }
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                                withAnimation(.easeOut.delay(0.5)) {
                                    sheet.toggle()
                                }
                            })
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                                withAnimation(.easeOut.delay(1)) {
                                    saved.toggle()
                                }
                            })
                        }
                    
                    Spacer()
                }
                Spacer()
            }
        }
        .frame(width: screen, height: screen)
    }
    
    
    // Reander View to an Image when the App Appear
    @MainActor func render(width: CGFloat, steps: String, distance: String, date: Date) {
        let renderer = ImageRenderer(content: renderView(width: width, steps: steps,distance: distance, date: date))

           // make sure and use the correct display scale for this device
           renderer.scale = displayScale

           if let uiImage = renderer.uiImage {
               renderedImage = Image(uiImage: uiImage)
           }
       }
}


// Generate the Image for the Screenshot 
struct renderView: View {
    var width: CGFloat
    var steps: String
    var distance: String
    var date: Date
    var body: some View {
        ZStack{
            
            // background
            Image("SnapShotV1")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: width, height: width)
            
            VStack{
                HStack{
                    Text("\(steps) Schritte")
                    
                    Spacer()
                    
                    Text("\(distance)")
                }
                .foregroundColor(.white)
                .font(.title2.bold())
                
                HStack{
                     let d = date.dateFormatte(date: "dd.MM.yyyy", time: "HH:mm")
                     Text("\(d.date) \(d.time)Uhr")
                    
                    Spacer()
                    
                    Text("Distanz")
                }
                .foregroundColor(.gray)
                .font(.caption)
            }
            .padding(20)
            .frame(width: width, height: width, alignment: .top)
            
        }
        .frame(width: width, height: width)
    }
}
