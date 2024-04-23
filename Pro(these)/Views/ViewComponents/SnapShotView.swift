//
//  SnapShotView.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 27.09.23.
//

import SwiftUI
import PhotosUI
import Charts
import CoreData


// SNAPSHOT VIEWS
struct SnapShotView: View {
    
    @EnvironmentObject var appConfig: AppConfig
    @EnvironmentObject var themeManager: ThemeManager
    @EnvironmentObject var adSheet: GoogleInterstitialAd
    @EnvironmentObject var handlerStates: HandlerStates
    
    @Environment(\.displayScale) var displayScale
    @Environment(\.managedObjectContext) var managedObjectContext
    
    init(isSheet: Binding<Bool>) {
        self._isSheet = isSheet
        
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(currentTheme.backgroundColor)
        UISegmentedControl.appearance().backgroundColor = UIColor(currentTheme.backgroundColor)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(currentTheme.hightlightColor)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(currentTheme.text)], for: .normal)
    }
    
    private var enviromentAppState: Bool {
        AppConfig.shared.hasPro ? true : false
    }
    
    private var currentTheme: Theme {
        return ThemeManager().currentTheme()
    }
    
    private var viewport: CGRect {
        UIScreen.main.bounds
    }
    
    private var images: [String] {
        var images: [String] = []
        for i in 1...5 {
            images.append("SnapShotV\(i)")
        }
        
        return images
    }
    
    var selectedBackgroundImageData: Data? {
        guard let fileName = self.selectedBackgroundImage else { return nil }
        
        guard fileName.contains("SnapShot") == false else { return nil }
        
        let fileURL = ImageFileHandler.fileUrl(for: fileName)
        
        return try? Data(contentsOf: fileURL)
    }
    
    @Binding var isSheet: Bool
    @State var isShopSheep: Bool = false
    
    @State var TL: SnapShot.SnapshotViews = .stepsToday
    @State var TR: SnapShot.SnapshotViews = .dateToday
    @State var BL: SnapShot.SnapshotViews = .logo
    @State var BR: SnapShot.SnapshotViews = .stepDistance
    
    @State var editView: SnapShot.SnapshotBackground = .background
    @State var contentEditView: SnapShot.SnapshotEdge = .topLeft
    
    @State var datePicker = Date()
    @State var dynamicSheet:CGSize = .zero
    
    @State var fontWeight: Font.Weight = .bold
    @State var textSizeSteps: Double = 30
    @State var textSizeDate: Double = 30
    @State var textSizeWeather: Double = 30
    
    @State var selectedBackgroundImage: String? = "SnapShotV1"
    @State var renderedImage: Image? = nil
    @State var renderedUIImage: UIImage? = nil
    @State var topGradient: Bool = true
    @State var topGradientOpacity = 0.1
    @State var bottomGradient: Bool = true
    @State var bottomGradientOpacity = 0.1
    @State var showLogo = true
    @State var temp: temp = .c
    @State var locationIcon = true
    @State var showBgOverlay = true
    @State var stepCount:Double = 0
    @State var stepDistance:Double = 0
    @State var weekStepData: [ChartDataSnapShotWeekCompair] = []
    
    @State var widgetSize:CGSize = .zero
    @State var saved = false
    @State var lazyVGridImages: CGSize = .zero
    @State var tabViewSize: CGSize = .zero
    @State var contentTabViewSize: CGSize = .zero
    
    // IMAGEPICKER
    @State var showingAddSnapshotConfirmation: Bool = false
    
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented: Bool = false
    
    
    @FetchRequest(
          sortDescriptors: [
              NSSortDescriptor(keyPath: \SnapshotImage.createdDate, ascending: true)
          ]
      ) private var imageEntities: FetchedResults<SnapshotImage>
    
    @State var longPress = false
    @State var ShakeState: Int = 0
    
    // CAmera
    @State var isCameraPresented: Bool = false
    @State var selectedImageFromCamera: UIImage? = nil
    
    var body: some View {
        
        VStack(spacing: 10) {
            
            SheetHeader(title: "SnapShot", action: {
                isSheet.toggle()
            })
            .padding(.top, 40)
            
            Spacer()

            ZStack {
                HStack {
                    Spacer()

                    ZStack {
                        Widget(size: 500)
                            .cornerRadius(20)
                            .saveSize(in: $widgetSize)
                            .opacity(saved ? 0 : 1)
                        
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(currentTheme.text)
                            .opacity(saved ? 1 : 0)
                            .modifier(Shake(animatableData: CGFloat(saved ? 1 : 0 )))
                    }
                    
                    Spacer()
                }
                
                HStack {
                    Spacer()

                    
                    IconList()
                        .frame(height: widgetSize.height)
                        .opacity(saved ? 0 : 1)
                        .padding(.trailing)
                }
            }
            
            Spacer()
            
            VStack {
                GeometryReader { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        Switcher(proxy: proxy)
                            .foregroundColor(currentTheme.textGray)
                    }
                    .frame(width: .infinity, height: proxy.size.height, alignment: .center)
                }
            }
            .padding(.bottom, 40)
            .padding()
            .background(currentTheme.text.ignoresSafeArea())
            .cornerRadius(25)
            
        }
        .frame(minWidth: viewport.width, minHeight: viewport.height)
        .onAppear {
            loadSteps()
            
            self.temp = appConfig.WidgetContentTemp
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                render(view: Widget(size: 500))
            })
            
            adSheet.requestInterstitialAds()
        }
        .onChange(of: datePicker, perform: { date in
            loadSteps()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                render(view: Widget(size: 500))
            })
        })
        .onDisappear(perform: {
            appConfig.WidgetContentTemp = self.temp
        })
    }
    
    @ViewBuilder func Widget(size: CGFloat) -> some View {
        ZStack {
            
            if let image = selectedBackgroundImage {
                if image.contains("SnapShot") {
                    Image(image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    if let imageData = selectedBackgroundImageData, let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: size / 2, height: size / 2, alignment: .center)
                            .clipped()
                    }
                }
            }
            
            if showBgOverlay {
                Image("SnapShotBGOverlay")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .blendMode(.plusLighter)
                    .opacity(0.5)
            }
            
            if topGradient {
                LinearGradient(colors: [.black.opacity(topGradientOpacity),.clear, .clear], startPoint: .top, endPoint: .bottom)
            }
            
            if bottomGradient {
                LinearGradient(colors: [.clear, .clear, .black.opacity(bottomGradientOpacity)], startPoint: .top, endPoint: .bottom)
            }

            VStack {
                
                HStack {
                    
                    SnapShotItem(view: TL, alignment: .topLeading, date: $datePicker, stepText: $textSizeSteps, stepDistance: $stepDistance, dateText: $textSizeDate, weatherText: $textSizeWeather, fontWeight: $fontWeight, weekStepData: $weekStepData, stepCount: $stepCount, locationIcon: $locationIcon, temp: $temp )
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                        .onTapGesture {
                            editView = .content
                            contentEditView = .topLeft
                        }
                    
                    SnapShotItem(view: TR, alignment: .topTrailing, date: $datePicker, stepText: $textSizeSteps, stepDistance: $stepDistance, dateText: $textSizeDate, weatherText: $textSizeWeather, fontWeight: $fontWeight, weekStepData: $weekStepData, stepCount: $stepCount, locationIcon: $locationIcon, temp: $temp )
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                        .onTapGesture {
                            editView = .content
                            contentEditView = .topRight
                        }
                }
                
                HStack {
                    SnapShotItem(view: BL, alignment: .bottomLeading, date: $datePicker, stepText: $textSizeSteps, stepDistance: $stepDistance, dateText: $textSizeDate, weatherText: $textSizeWeather, fontWeight: $fontWeight, weekStepData: $weekStepData, stepCount: $stepCount, locationIcon: $locationIcon, temp: $temp )
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
                        .onTapGesture {
                            editView = .content
                            contentEditView = .bottomLeft
                        }
                    
                    SnapShotItem(view: BR, alignment: .bottomTrailing, date: $datePicker, stepText: $textSizeSteps, stepDistance: $stepDistance, dateText: $textSizeDate, weatherText: $textSizeWeather, fontWeight: $fontWeight, weekStepData: $weekStepData, stepCount: $stepCount, locationIcon: $locationIcon, temp: $temp )
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
                        .onTapGesture {
                            editView = .content
                            contentEditView = .bottomRight
                        }
                }
                
                
            }
            .padding()
        }
        .background(.ultraThinMaterial)
        .frame(width: size / 2, height: size / 2)
    }
    
    @ViewBuilder func IconList() -> some View {
        VStack(spacing: 25) {
            Spacer()
            
            Button(action: {
                render(view: Widget(size: 500))
                
                if let img = renderedUIImage {
                    UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
                }
                
                withAnimation(.easeInOut(duration: 0.3)){
                    saved.toggle()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                    withAnimation(.easeOut.delay(1)) {
                        saved.toggle()
                    }
                })
            }, label: {
                VStack(spacing: 6) {
                    Image(systemName: "square.and.arrow.down")
                        .font(.title)
                    
                    Text("Save")
                        .font(.system(size: 8, weight: .bold))
                }
            })
            
            
            if InstagramSharingUtils.canOpenInstagramStories {
                Button(action: {
                    render(view: Widget(size: 500))
                    
                    if let img = renderedUIImage {
                        InstagramSharingUtils.shareToInstagramStories(img)
                    }
                    
                }) {
                    VStack(spacing: 6) {
                        Image("instagram")
                            .font(.title)
                            .scaleEffect(1.2)
                        
                        Text("Instagram")
                            .font(.system(size: 8, weight: .bold))
                    }
                }
            }
            
            Button(action: {
                render(view: Widget(size: 500))
            }) {
                if let img = renderedImage {
                    ShareLink(item: img, preview: SharePreview("My progress with the Pro Prosthesis App. https://www.prothese.pro/store", image: img), label: {
                        VStack(spacing: 6) {
                            Image(systemName: "square.and.arrow.up")
                                .font(.title)
                            
                            Text("Share")
                                .font(.system(size: 8, weight: .bold))
                        }
                    })
                }
            }
            .onChange(of: selectedBackgroundImage, perform: { _ in
                render(view: Widget(size: 500))
            })
            .onChange(of: TL, perform: { _ in
                render(view: Widget(size: 500))
            })
            .onChange(of: TR, perform: { _ in
                render(view: Widget(size: 500))
            })
            .onChange(of: BL, perform: { _ in
                render(view: Widget(size: 500))
            })
            .onChange(of: BR, perform: { _ in
                render(view: Widget(size: 500))
            })
            .onChange(of: topGradientOpacity, perform: { _ in
                render(view: Widget(size: 500))
            })
            .onChange(of: topGradientOpacity, perform: { _ in
                render(view: Widget(size: 500))
            })
            .onChange(of: bottomGradient, perform: { _ in
                render(view: Widget(size: 500))
            })
            .onChange(of: bottomGradientOpacity, perform: { _ in
                render(view: Widget(size: 500))
            })
            .onChange(of: bottomGradientOpacity, perform: { _ in
                render(view: Widget(size: 500))
            })
            .onChange(of: locationIcon, perform: { _ in
                render(view: Widget(size: 500))
            })
            .onChange(of: fontWeight, perform: { _ in
                render(view: Widget(size: 500))
            })
            .onChange(of: textSizeSteps, perform: { _ in
                render(view: Widget(size: 500))
            })
            .onChange(of: textSizeDate, perform: { _ in
                render(view: Widget(size: 500))
            })
            .onChange(of: textSizeWeather, perform: { _ in
                render(view: Widget(size: 500))
            })
        }.foregroundColor(currentTheme.text)
        .onSubmit {
            render(view: Widget(size: 500))
        }
    }
    
    @MainActor func render(view: some View) {
        let renderer = ImageRenderer(content: view )
        renderer.scale = displayScale
        if let uiImage = renderer.uiImage {
           renderedImage = Image(uiImage: uiImage)
            renderedUIImage = uiImage
        }
   }
    
    private func loadSteps() {
        print("[SnapShotView] LoadSteps")
        HealthStoreProvider().queryDayCountbyType(date: datePicker, type: .stepCount, completion: { stepCount in
            DispatchQueue.main.async {
                self.stepCount = stepCount
            }
        })
        
        HealthStoreProvider().queryDayCountbyType(date: datePicker, type: .distanceWalkingRunning, completion: { distance in
            DispatchQueue.main.async {
                stepDistance = distance
            }
        })

        
        for i in 0...4 {
            
            let newDate = Calendar.current.date(byAdding: .day, value: -i, to: datePicker)!
            
            HealthStoreProvider().queryDayCountbyType(date: newDate, type: .stepCount, completion: { stepCount in
                DispatchQueue.main.async {
                    weekStepData.append(ChartDataSnapShotWeekCompair(date: newDate, stepCount: stepCount))
                }
            })
        }
        
        
    }
}

extension SnapShotView {
    @ViewBuilder func Switcher(proxy: GeometryProxy, width: CGFloat? = nil) -> some View {
        VStack {

            Picker("", selection: $editView) {
                ForEach(SnapShot.SnapshotBackground.allCases, id: \.self) { edge in
                    Text(edge.rawValue).tag(edge)
                }
           }
           .pickerStyle(.segmented)
            
            TabView(selection: $editView, content: {
                BackgroundEdit()
                    .tag(SnapShot.SnapshotBackground.background)
                    .saveSize(in: $tabViewSize)
                
                ContentEdit()
                    .tag(SnapShot.SnapshotBackground.content)
                    .saveSize(in: $tabViewSize)
            })
            .frame(height: tabViewSize.height + 20)
           
        }
        .padding(.horizontal)
    }

    @ViewBuilder func BackgroundEdit() -> some View {
       
        VStack(spacing: 15) {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 3), spacing: 10) {
                ForEach(images, id: \.self) { image in
                    Button(action: {
                        withAnimation(.easeInOut) {
                            
                            selectedBackgroundImage = image
                            
                        }
                    }, label: {
                        
                        Image(image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .overlay(Color.white.opacity(selectedBackgroundImage == image ? 0 : 0.7))
                            .border(currentTheme.hightlightColor, width: selectedBackgroundImage == image ? 2 : 0)
                            .saveSize(in: $lazyVGridImages)
                            .animation(.easeInOut, value: selectedBackgroundImage)
                        
                    })
                    .simultaneousGesture(LongPressGesture(minimumDuration: 0.5)
                        .onEnded { _ in
                            
                            longPress = true
                            
                            UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                        
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                                self.ShakeState += 1
                            })
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                                self.ShakeState += 0
                            })
                        }
                    )
                }
                
                ForEach(imageEntities) { image in
                    
                    if let imageData = image.data,
                       let uiImage = UIImage(data: imageData) {
                        Button(action: {
                            withAnimation(.easeInOut) {
                                
                                if longPress {
                                    
                                } else {
                                    selectedBackgroundImage = image.fileName
                                }
                                
                                
                            }
                        }, label: {
                            
                            Image(uiImage: uiImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .overlay(Color.white.opacity(selectedBackgroundImage == image.fileName ? 0 : 0.7))
                                .overlay {
                                    VStack(alignment: .center) {
                                        Image(systemName: "minus.circle.fill")
                                            .font(.largeTitle)
                                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                                            .foregroundStyle(.white, .red)
                                        
                                    }
                                    .onTapGesture(perform: {  deleteImage(snapshotImage: image) })
                                    .background(currentTheme.textGray.opacity(0.5))
                                    .show(longPress)
                                }
                                .frame(width: lazyVGridImages.width, height: lazyVGridImages.height, alignment: .center)
                                .clipped()
                                .border(currentTheme.hightlightColor, width: selectedBackgroundImage == image.fileName ? 2 : 0)
                                .animation(.easeInOut, value: selectedBackgroundImage)
                            
                        })
                        .modifier(Shake(animatableData: CGFloat(ShakeState)))
                        .simultaneousGesture(LongPressGesture(minimumDuration: 0.5)
                            .onEnded { _ in
                                
                                longPress = true
                                
                                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                                    self.ShakeState += 1
                                })
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                                    self.ShakeState += 0
                                })
                            }
                        )
                        .onChange(of: selectedBackgroundImage, perform: { _ in
                            if ShakeState > 0 {
                                ShakeState = 0
                                longPress = false
                            }
                        })
                        
                    }
                    
                    
                }
                
                Button(action: {
                    withAnimation(.easeInOut) {
                        longPress = false
                        showingAddSnapshotConfirmation.toggle()
                    }
                }, label: {
                    VStack(alignment: .center) {
                        Image(systemName: "plus.square.dashed")
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                            .foregroundColor(currentTheme.text)
                    }
                    .frame(width: lazyVGridImages.width, height: lazyVGridImages.height, alignment: .center)
                    .background(currentTheme.textGray.opacity(0.7))
                })
            }
            
            ToggleRow(text: "Darken the upper background", state: $topGradient, slider: true, value: $topGradientOpacity, decimal: 1, sliderText: "\( topGradientOpacity, specifier: "%.1f") Darkness")
            
            ToggleRow(text: "Darken the bottom background", state: $bottomGradient, slider: true, value: $bottomGradientOpacity, decimal: 1, sliderText: "\( topGradientOpacity, specifier: "%.1f") Darkness")
            
            ToggleRow(text: "Background Overlay", state: enviromentAppState ? $showBgOverlay : .constant(true) , slider: false, value: .constant(0))
            
            Spacer()
        }
        .background(currentTheme.text)
        .onTapGesture(perform: {
            longPress = false
        })
        .sheet(
            isPresented: $isImagePickerPresented,
            onDismiss: { saveImageToAppFolderAndCoreData(image: selectedImage) },
            content: { ImagePickerView(selectedImage: $selectedImage) }
        )
        .sheet(
            isPresented: $isCameraPresented,
            onDismiss: { saveImageToAppFolderAndCoreData(image: selectedImage) },
            content: {
                
                ZStack {
                    Color.black.ignoresSafeArea()
                    
                    CameraProvider(image: $selectedImage)
                    
                }
                
            }
        )
        .confirmationDialog("Choose option", isPresented: $showingAddSnapshotConfirmation) {
            Button("Choose an image") { isImagePickerPresented.toggle() }
            Button("Take a picture") {
                requestCameraPermission { isAuthorized in
                    if isAuthorized {
                        isCameraPresented.toggle()
                    }
                }
            }
        } message: {
            Text("Choose option")
        }
        
    }
    
    @ViewBuilder func ContentEdit() -> some View {
        VStack(spacing: 15) {
            Picker("", selection: $contentEditView) {
                ForEach(SnapShot.SnapshotEdge.allCases, id: \.self) { edge in
                    Text(edge.rawValue).tag(edge)
                }
            }
            .pickerStyle(.segmented)
            
            TabView(selection: $contentEditView, content: {
                
                VStack(spacing: 15) {
                    let edge = TL
                    
                    ViewSwitcher(state: "TL", disable: false)
                    
                    FontSizePicker(state: edge, contains: [.stepsToday, .dateToday])
                    
                    DatePickerRow(state: edge, contains: [.stepsToday, .dateToday])
                    
                    StepsTodayTextSize(state: edge, contains: [.stepsToday])
                    
                    DateTodayTextSize(state: edge, contains: [.dateToday])
                    
                    WeatherTextSize(state: edge, contains: [.waether])
                    
                    LocationRow(state: edge, contains: [.location])
                    
                    Spacer()
                }
                .tag(SnapShot.SnapshotEdge.topLeft)
                .background(currentTheme.text)
                //.saveSize(in: $contentTabViewSize)
                
                VStack(spacing: 15) {
                    let edge = TR
                    
                    ViewSwitcher(state: "TR", disable: false)
                    
                    FontSizePicker(state: edge, contains: [.stepsToday, .dateToday])
                    
                    DatePickerRow(state: edge, contains: [.stepsToday, .dateToday])
                    
                    StepsTodayTextSize(state: edge, contains: [.stepsToday])
                    
                    DateTodayTextSize(state: edge, contains: [.dateToday])
                    
                    WeatherTextSize(state: edge, contains: [.waether])
                    
                    LocationRow(state: edge, contains: [.location])
                    
                    Spacer()
                }
                .tag(SnapShot.SnapshotEdge.topRight)
                .background(currentTheme.text)
                //.saveSize(in: $contentTabViewSize)
                
                ZStack {
                    VStack(spacing: 15) {
                        let edge = BL
                        
                        ViewSwitcher(state: "BL", disable: AppConfig.shared.hasPro ? false : true)
                            .blur(radius: enviromentAppState ? 0 : 2)
                        
                        FontSizePicker(state: edge, contains: [.stepsToday, .dateToday])
                            .blur(radius: enviromentAppState ? 0 : 2)
                        DatePickerRow(state: edge, contains: [.stepsToday, .dateToday])
                            .blur(radius: enviromentAppState ? 0 : 2)
                        StepsTodayTextSize(state: edge, contains: [.stepsToday])
                            .blur(radius: enviromentAppState ? 0 : 2)
                        DateTodayTextSize(state: edge, contains: [.dateToday])
                            .blur(radius: enviromentAppState ? 0 : 2)
                        WeatherTextSize(state: edge, contains: [.waether])
                            .blur(radius: enviromentAppState ? 0 : 2)
                        LocationRow(state: edge, contains: [.location])
                            .blur(radius: enviromentAppState ? 0 : 2)
                        
                        Spacer()
                    }
                    .padding(enviromentAppState ? 0 : 2)
                    
                   
                    Button(action: {
                        isShopSheep.toggle()
                    }, label: {
                        TextBadge(padding: 15, text: "Get Pro", font: .title3.bold())
                    })
                    .sheetModifier(showAds: false, isSheet: $isShopSheep, sheetContent: {
                        ShopSheet(isSheet: $isShopSheep)
                    }, dismissContent: {})
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                    .show(!enviromentAppState)
                  
                        
                }
                .tag(SnapShot.SnapshotEdge.bottomLeft)
                .background(currentTheme.text)
                //.saveSize(in: $contentTabViewSize)
                
                VStack(spacing: 15) {
                    let edge = BR
                    
                    ViewSwitcher(state: "BR", disable: false)

                    FontSizePicker(state: edge, contains: [.stepsToday, .dateToday])
                    
                    DatePickerRow(state: edge, contains: [.stepsToday, .dateToday])
                    
                    StepsTodayTextSize(state: edge, contains: [.stepsToday])
                    
                    DateTodayTextSize(state: edge, contains: [.dateToday])
                    
                    WeatherTextSize(state: edge, contains: [.waether])
                    
                    LocationRow(state: edge, contains: [.location])
                    
                    Spacer()
                }
                .tag(SnapShot.SnapshotEdge.bottomRight)
                .background(currentTheme.text)
                //.saveSize(in: $contentTabViewSize)
                
            })
            
            
        }
        .background(currentTheme.text)
    }
    
    @ViewBuilder func ViewSwitcher(state: String, disable: Bool? = nil) -> some View {
        let steps = SnapShot.SnapshotViews.stepsToday
        let stepDistance = SnapShot.SnapshotViews.stepDistance
        let stepsWeek = SnapShot.SnapshotViews.stepsWeek
        let date = SnapShot.SnapshotViews.dateToday
        let logo = SnapShot.SnapshotViews.logo
        let location = SnapShot.SnapshotViews.location
        let weather = SnapShot.SnapshotViews.waether
        let none = SnapShot.SnapshotViews.none
        
        HStack {
            Text("Data type:").font(.body.bold())
            
            Spacer()
            
            Menu(content: {
                Button(steps.rawValue, action: {
                    switch state {
                        case "TL": self.TL = steps
                        case "TR": self.TR = steps
                        case "BL": self.BL = steps
                        case "BR": self.BR = steps
                        default: return
                    }
                })
         
                Button(stepsWeek.rawValue, action: {
                    switch state {
                        case "TL": self.TL = stepsWeek
                        case "TR": self.TR = stepsWeek
                        case "BL": self.BL = stepsWeek
                        case "BR": self.BR = stepsWeek
                        default: return
                    }
                })
                
                Button(stepDistance.rawValue, action: {
                    switch state {
                        case "TL": self.TL = stepDistance
                        case "TR": self.TR = stepDistance
                        case "BL": self.BL = stepDistance
                        case "BR": self.BR = stepDistance
                        default: return
                    }
                })
                
                Button(location.rawValue, action: {
                    switch state {
                        case "TL": self.TL = location
                        case "TR": self.TR = location
                        case "BL": self.BL = location
                        case "BR": self.BR = location
                        default: return
                    }
                })
                
                Button(weather.rawValue, action: {
                    switch state {
                        case "TL": self.TL = weather
                        case "TR": self.TR = weather
                        case "BL": self.BL = weather
                        case "BR": self.BR = weather
                        default: return
                    }
                })
                
                Button(date.rawValue, action: {
                    switch state {
                        case "TL": self.TL = date
                        case "TR": self.TR = date
                        case "BL": self.BL = date
                        case "BR": self.BR = date
                        default: return
                    }
                })
                
                Button(logo.rawValue, action: {
                    switch state {
                        case "TL": self.TL = logo
                        case "TR": self.TR = logo
                        case "BL": self.BL = logo
                        case "BR": self.BR = logo
                        default: return
                    }
                })
                
                Button(none.rawValue, action: {
                    switch state {
                        case "TL": self.TL = none
                        case "TR": self.TR = none
                        case "BL": self.BL = none
                        case "BR": self.BR = none
                        default: return
                    }
                })
            }, label: {
                
                switch state {
                    case "TL": Text(self.TL.rawValue).font(.body.bold()).foregroundColor(currentTheme.text)
                    case "TR": Text(self.TR.rawValue).font(.body.bold()).foregroundColor(currentTheme.text)
                    case "BL": Text(self.BL.rawValue).font(.body.bold()).foregroundColor(currentTheme.text)
                    case "BR": Text(self.BR.rawValue).font(.body.bold()).foregroundColor(currentTheme.text)
                    default: Text("NONE")
                }
 
            })
            .disabled(disable ?? false ? true : false )
            .padding(10)
            .background(currentTheme.backgroundColor)
            .cornerRadius(15)
        }
    }
    
    @ViewBuilder func DatePickerRow(state: SnapShot.SnapshotViews , contains: [SnapShot.SnapshotViews]) -> some View {
        ForEach(contains, id: \.hashValue) { item in // Steps, Date
            if state == SnapShot.SnapshotViews(rawValue: item.rawValue) {
                HStack {
                    Text("Date").font(.body.bold())
                    Spacer()
                    DatePicker("", selection: $datePicker, displayedComponents: .date)
                        .background(currentTheme.backgroundColor)
                        .font(.body)
                        .cornerRadius(10)
                        .labelsHidden()
                }
            }
        }
        
    }
    
    @ViewBuilder func StepsTodayTextSize(state: SnapShot.SnapshotViews , contains: [SnapShot.SnapshotViews]) -> some View {
        ForEach(contains, id: \.hashValue) { item in // Steps, Date
            if state == SnapShot.SnapshotViews(rawValue: item.rawValue) {
                VStack {
                    Slider(value: $textSizeSteps, in: 20...50, step: 5)
                    Text("Fontsize: \( textSizeSteps, specifier: "%.0f") px")
                }
            }
        }
        
    }
    
    @ViewBuilder func DateTodayTextSize(state: SnapShot.SnapshotViews , contains: [SnapShot.SnapshotViews]) -> some View {
        ForEach(contains, id: \.hashValue) { item in // Steps, Date
            if state == SnapShot.SnapshotViews(rawValue: item.rawValue) {
                VStack {
                    Slider(value: $textSizeDate, in: 20...50, step: 5)
                    Text("Fontsize: \( textSizeDate, specifier: "%.0f") px")
                }
            }
        }
        
    }
    
    @ViewBuilder func WeatherTextSize(state: SnapShot.SnapshotViews , contains: [SnapShot.SnapshotViews]) -> some View {
        ForEach(contains, id: \.hashValue) { item in // Steps, Date
            if state == SnapShot.SnapshotViews(rawValue: item.rawValue) {
                
                HStack {
                    
                    Text("Temperatures").font(.body.bold())
                    
                    Spacer()
                    
                    Menu(content: {
                        Button("Celsius", action: {
                            self.temp = .c
                        })
                        Button("Fahrenheit", action: {
                            self.temp = .f
                        })
                    }, label: {
                        
                        switch self.temp {
                            case .c: Text("Celsius").font(.body.bold()).foregroundColor(currentTheme.text)
                            case .f: Text("Fahrenheit").font(.body.bold()).foregroundColor(currentTheme.text)
                        }
         
                    })
                    .padding(10)
                    .background(currentTheme.backgroundColor)
                    .cornerRadius(15)
                }
                
                VStack {
                    Slider(value: $textSizeWeather, in: 20...50, step: 5)
                    Text("Fontsize: \( textSizeWeather, specifier: "%.0f") px")
                }
            }
        }
        
    }
    
    @ViewBuilder func FontSizePicker(state: SnapShot.SnapshotViews , contains: [SnapShot.SnapshotViews]) -> some View {
        
        ForEach(contains, id: \.hashValue) { item in // Steps, Date
            if state == SnapShot.SnapshotViews(rawValue: item.rawValue) {
                HStack {
                    Text("Font Weigt").font(.body.bold())
                    
                    Spacer()
                    
                    Menu(content: {
                        Button("Thin", action: {
                            fontWeight = .thin
                        })
                        Button("Regular", action: {
                            fontWeight = .regular
                        })
                        Button("Bold", action: {
                            fontWeight = .bold
                        })
                    }, label: {
                        
                        switch fontWeight {
                            case .thin: Text("Thin").font(.body.bold()).foregroundColor(currentTheme.text)
                            case .regular: Text("Regular").font(.body.bold()).foregroundColor(currentTheme.text)
                            case .bold: Text("Bold").font(.body.bold()).foregroundColor(currentTheme.text)
                            default: Text("Unknown").font(.body.bold()).foregroundColor(currentTheme.text)
                        }
         
                    })
                    .padding(10)
                    .background(currentTheme.backgroundColor)
                    .cornerRadius(15)
                }
            }
        }
        
    }
    
    @ViewBuilder func LocationRow(state: SnapShot.SnapshotViews , contains: [SnapShot.SnapshotViews]) -> some View {
        
        ForEach(contains, id: \.hashValue) { item in // Steps, Date
            if state == SnapShot.SnapshotViews(rawValue: item.rawValue) {
                HStack {
                    ToggleRow(text: "Location Icon", state: $locationIcon, slider: false, value: .constant(0))
                }
            }
        }
        
        
    }
    
    @ViewBuilder func ToggleRow(text: LocalizedStringKey, state: Binding<Bool>, slider: Bool? = nil, value: Binding<Double>, decimal: Int? = nil, sliderText: LocalizedStringKey? = nil) -> some View {
        VStack {
            Toggle(text, isOn: state)
            
            if slider ?? false {
                if state.wrappedValue {
                    VStack {
                        Slider(value: value, in: 0.1...0.6)
                        Text(sliderText ?? "").font(.footnote)
                    }
                }
            }
        }.padding(.horizontal, 2)
    }
    
    private func saveImageToAppFolderAndCoreData(image: UIImage?) {
            guard let image = image else { return }

            // Save image to app folder
            guard let fileName = saveImageToAppFolder(image: image) else { return }

            // Save image reference to Core Data
            saveImageReferenceToCoreData(fileName: fileName)
    }
    
    private func saveImageToAppFolder(image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 1.0) else {
            print("Could not get valid image data.")
            return nil
        }

        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = "\(UUID().uuidString).jpg"
        let fileURL = documentsURL.appendingPathComponent(fileName)

        do {
            try imageData.write(to: fileURL)
            print("Image saved to: \(fileURL.absoluteString)")
            return fileName
        } catch {
            print("Error saving image: \(error.localizedDescription)")
            return nil
        }
    }
    
    private func saveImageReferenceToCoreData(fileName: String) {
        let newImage = SnapshotImage(context: managedObjectContext)
        newImage.createdDate = Date()
        newImage.fileName = fileName

        do {
            try managedObjectContext.save()
            print("Image reference saved to Core Data")
        } catch {
            print("Error saving image reference to Core Data: \(error.localizedDescription)")
        }
    }
    
    private func deleteImage(snapshotImage: SnapshotImage) {

        let fileURL = ImageFileHandler.fileUrl(for: snapshotImage.fileName ?? "")
        
        // Delete the image file from the app directory
        do {
            try FileManager.default.removeItem(at: fileURL)
            print("Image file deleted: \(fileURL)")
        } catch {
            print("Error deleting image file: \(error.localizedDescription)")
        }

        // Delete the image entity from Core Data
        managedObjectContext.delete(snapshotImage)

        do {
            try managedObjectContext.save()
            print("Image entity deleted from Core Data")
        } catch {
            print("Error saving Core Data after deletion: \(error.localizedDescription)")
        }
        
        selectedBackgroundImage = images.first
        
        ShakeState = 0
        longPress = false
    }
    
    private func requestCameraPermission(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .video) { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
}
// SNAPSHOT VIEWS







// WIDGETCONTENTVIEW
struct SnapShotItem: View {
    private var currentTheme: Theme {
        return ThemeManager().currentTheme()
    }

    var view: SnapShot.SnapshotViews
    var alignment: Alignment
    @Binding var date: Date
    @Binding var stepText: Double
    @Binding var stepDistance: Double
    @Binding var dateText: Double
    @Binding var weatherText: Double
    @Binding var fontWeight: Font.Weight
    @Binding var weekStepData: [ChartDataSnapShotWeekCompair]
    @Binding var stepCount: Double
    @Binding var locationIcon: Bool
    @Binding var temp: temp
    var body: some View {
        switch view {
            case .stepsToday: WidgetContentStepsStringView(font: .system(size: CGFloat(stepText / 2)), fontWeight: fontWeight, date: $date, stepCount: stepCount)
            case .stepDistance: WidgetContentStepDistanceStringView(font: .system(size: CGFloat(stepText / 2)), stepDistance: stepDistance)
            case .stepsWeek: WidgetContentSnapShotWeek(weekStepData: weekStepData)
            case .dateToday: WidgetContentDateStringView(font: .system(size: CGFloat(dateText / 2)), fontWeight: fontWeight, date: $date)
            case .logo: WidgetContentLogoView(alignment: alignment)
            case .waether: WidgetContentWeather(font: .system(size: CGFloat(weatherText / 2)), fontWeight: fontWeight, temp: temp)
            case .location: WidgetLocationStringView(font: .system(size: CGFloat(dateText / 2)), fontWeight: fontWeight, locationIcon: $locationIcon)
            case .none: Text("").opacity(0)
        }
    }
}

struct WidgetContentStepsStringView: View {
    private var currentTheme: Theme {
        return ThemeManager().currentTheme()
    }
    
    var font: Font? = nil
    var fontWeight: Font.Weight? = nil
    var color: Color? = nil
    @Binding var date: Date
    
    var stepCount: Double
    
    var body: some View {
        Text(String(format: NSLocalizedString("%.0f Steps", comment: ""), stepCount))
            .font( font ?? .system(size: 20 / 2) )
            .fontWeight(fontWeight ?? .regular)
            .foregroundColor(color ?? currentTheme.text)
    }
}

struct WidgetLocationStringView: View {
    private var currentTheme: Theme {
        return ThemeManager().currentTheme()
    }
    
    var font: Font? = nil
    var fontWeight: Font.Weight? = nil
    var color: Color? = nil
    @Binding var locationIcon: Bool
    
    var body: some View {
        if locationIcon {
            Label(HandlerStates.shared.locationCity, systemImage: "location.fill")
                .labelStyle(.titleAndIcon)
                .font( font ?? .system(size: 20 / 2) )
                .fontWeight(fontWeight ?? .regular)
                .foregroundColor(color ?? currentTheme.text)
        } else {
            Text(HandlerStates.shared.locationCity)
                .font( font ?? .system(size: 20 / 2) )
                .fontWeight(fontWeight ?? .regular)
                .foregroundColor(color ?? currentTheme.text)
        }
        
       
    }
}

struct WidgetContentStepDistanceStringView: View {
    private var currentTheme: Theme {
        return ThemeManager().currentTheme()
    }
    
    var font: Font? = nil
    var fontWeight: Font.Weight? = nil
    var color: Color? = nil
    
    var stepDistance: Double
    
    var body: some View {
        if stepDistance < 1000.0 {
            Text( "\(String(format: "%.0f", stepDistance )) m")
                .font( .system(size: 40 / 2) )
                .fontWeight(.bold)
                .foregroundColor(color ?? currentTheme.text)
        } else {
            Text("\( String(format: "%.1f", stepDistance / 1000) ) km")
                .font( .system(size: 40 / 2) )
                .fontWeight(.bold)
                .foregroundColor(color ?? currentTheme.text)
        }
    }
}

struct WidgetContentDateStringView: View {
    private var currentTheme: Theme {
        return ThemeManager().currentTheme()
    }
    
    var font: Font? = nil
    var fontWeight: Font.Weight? = nil
    var color: Color? = nil
    @Binding var date: Date
    
    var body: some View {
        Text(date.dateFormatte(date: "dd.MM.yyyy", time: "").date)
            .font( font ?? .system(size: 20 / 2) )
            .fontWeight(fontWeight ?? .regular)
            .foregroundColor(color ?? currentTheme.text)
    }
}

struct WidgetContentSnapShotWeek: View {
    
    private var currentTheme: Theme {
        return ThemeManager().currentTheme()
    }
    
    var weekStepData: [ChartDataSnapShotWeekCompair]
    
    var body: some View {
        Chart() {
            ForEach(weekStepData.sorted(by: {$0.date > $1.date}), id: \.id) { day in
                LineMark(x: .value("Date", day.date), y: .value("Steps", day.stepCount))
                   .interpolationMethod(.catmullRom)
                   .foregroundStyle(currentTheme.text.opacity(0.5))
                   .lineStyle(StrokeStyle(lineWidth: 2))
                   .symbol {
                       
                       if Calendar.current.isDate(day.date, inSameDayAs: Date()) {
                           ZStack {
                               Circle()
                                   .strokeBorder(currentTheme.hightlightColor, lineWidth: 2)
                                   .frame(width: 20)
                               
                               
                               Circle()
                                   .frame(width: 10)
                                   .foregroundColor(currentTheme.hightlightColor)
                           }
                       } else {
                           Circle()
                               .frame(width: 6)
                               .foregroundColor(currentTheme.text)
                       }
                   }
            }
            
        }
        .chartYScale(range: .plotDimension(padding: 10))
        .chartXScale(range: .plotDimension(padding: 20))
        .chartLegend(.hidden)
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .frame(height: 50)
    }
}

struct WidgetContentWeather: View {
    
    private var currentTheme: Theme {
        return ThemeManager().currentTheme()
    }

    var font: Font? = nil
    var fontWeight: Font.Weight? = nil
    var color: Color? = nil
    var temp: temp
    
    var temperatur: Int {
        return Int(temp == .c ? HandlerStates.shared.weatherTempC : HandlerStates.shared.weatherTempF )
    }
    
    var body: some View {
        if temp == .c {
            Label("\(temperatur) °C", systemImage: "location.fill")
                .labelStyle(.titleOnly)
                .font( font ?? .system(size: 20 / 2) )
                .fontWeight(fontWeight ?? .regular)
                .foregroundColor(color ?? currentTheme.text)
        } else {
            Label("\(temperatur) °F", systemImage: "location.fill")
                .labelStyle(.titleOnly)
                .font( font ?? .system(size: 20 / 2) )
                .fontWeight(fontWeight ?? .regular)
                .foregroundColor(color ?? currentTheme.text)
        }
        
    }
}

struct WidgetContentLogoView: View {
    var alignment: Alignment
    
    var body: some View {
        Image("SnapShotLogo")
            .resizable()
            .scaledToFit()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: alignment)
    }
}
// WIDGETCONTENTVIEW

