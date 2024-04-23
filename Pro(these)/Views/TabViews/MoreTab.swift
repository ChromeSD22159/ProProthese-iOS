//
//  MoreTab.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 21.09.23.
//

import SwiftUI
import StoreKit

struct MoreTab: View {
    @EnvironmentObject var appConfig: AppConfig
    @Environment(\.requestReview) var requestReview
    @EnvironmentObject var tabManager: TabManager
    @EnvironmentObject var themeManager: ThemeManager
    
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
        
    @State var notes: [UNNotificationRequest] = []
    
    // not in use
    @State private var isAuthenticating = false
    @State private var showDebugField = false
    @State private var password = ""

    var body: some View {
        
        NavigationView {
            ZStack {
                currentTheme.gradientBackground(nil).ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false, content: {
                    VStack(spacing: 10) {
                        AnimatedHeader()
                        
                        Settings()
                        
                        copyright(isAuthenticating: $isAuthenticating, showDebugField: $showDebugField, password: $password)
                            .padding(.vertical, 20)
                    }
                })
                .coordinateSpace(name: "SCROLL")
                .ignoresSafeArea(.container, edges: .vertical)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onChange(of: appConfig.PushNotificationGoodMorning) { state in
            if state == false {
                AppNotifications.removeNotifications(keyworks: ["MOOD_GOOD_MORNING"], notes: notes)
            }
        }
        .onChange(of: appConfig.PushNotificationComebackReminder) { state in
            if state == false {
                AppNotifications.removeNotifications(keyworks: ["COMEBACK_REMINDER"], notes: notes)
            }
        }
        .onChange(of: appConfig.PushNotificationDailyMoodRemembering) { state in
            if state == false {
                AppNotifications.removeNotifications(keyworks: ["MOOD_REMINDER"], notes: notes)
            }
        }
        .onChange(of: appConfig.PushNotificationReports) { state in
            let identifier = ReportNotification.shared.randomNotification.identifier
            if state {
                AppNotifications.setPushNotificationWeeklyReport(notes: notes, debug: true)
            } else {
                if AppNotifications.isNotification(identfier: identifier, notes: notes) {
                    AppNotifications.removeNotifications(keyworks: [identifier], notes: notes)
                }
            }
        }
        .onAppear {
            loadNotifications()
        }
        
    }
    
   
    
    @ViewBuilder func AnimatedHeader() -> some View {
        GeometryReader { proxy in
            
            let minY = proxy.frame(in: .named("SCROLL")).minY
            let size = proxy.size
            let height = (size.height + minY)
            
            Rectangle()
                .fill(currentTheme.gradientBackground(nil))
                .frame(width: size.width, height: max(0, height), alignment: .top)
                .overlay(content: {
                    ZStack {
                        
                        currentTheme.gradientBackground(nil)
                        
                        FloatingClouds(speed: 1.0, opacity: 0.8, currentTheme: currentTheme)
                        
                        LinearGradient(
                            colors: [
                                .clear,
                                currentTheme.backgroundColor
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    }
                    
                     AnimatedHeaderContent()
                        .blur(radius: abs(minY / 100 * 2))
                        .offset(y: minY.sign == .minus ? minY * 1.5 : 0)
                        //.opacity(calcOpacity(minY))
                    
                })
                .cornerRadius(20)
                .offset(y: -minY)
            
        }
        .frame(height: 250)
    }
    
    @ViewBuilder func AnimatedHeaderContent() -> some View {
        VStack {
            Spacer()
            
            sayHallo(name: appConfig.username)
                .font(.title2.bold())
                .foregroundColor(currentTheme.text)
            
            Spacer()
        }
    }
    
    @ViewBuilder func Settings() -> some View {
        
        VStack(alignment: .leading, spacing: 25) {
            Spacer(minLength: 0.01)
            
            if !appConfig.hasPro {
                Button(action: {
                    DispatchQueue.main.async {
                        tabManager.ishasProFeatureSheet = true
                        tabManager.isSettingSheet = false
                    }
                }, label: {
                    GetProCard()
                })
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Color scheme")
                    .font(.footnote.bold())
                    .foregroundColor(currentTheme.textGray)
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 10) {
                    ForEach(Theme.allCases, id: \.name) { theme in
                        
                        Button(action: {
                            withAnimation(.easeInOut) {
                                appConfig.currentTheme = theme.rawValue
                            }
                        }, label: {
                            VStack {
                                Image(theme.previewImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .animation(.easeInOut, value: appConfig.currentTheme)
                                    .cornerRadius(15)
                                    .overlay(RoundedRectangle(cornerRadius: 15)
                                        .stroke(currentTheme.hightlightColor, lineWidth: appConfig.currentTheme == theme.rawValue ? 2 : 0))
                                
                                
                                Text(LocalizedStringKey(theme.name))
                                    .font(.footnote)
                                    .foregroundColor(currentTheme.text)
                            }
                        })
                        
                        
                    }
                }
            }
            .padding(.horizontal, 20)
            
            
            VStack(alignment: .leading, spacing: 10) {
                Text("App Settings")
                    .font(.footnote.bold())
                    .foregroundColor(currentTheme.textGray)
                    .padding(.horizontal, 20)
                
                // MARK: - Personal Settings
                NavigateTo( {
                    StackLink(systemIcon: "person.crop.circle", buttonText: "Personal Settings", foregroundColor: currentTheme.accentColor)
                }, {
                    PersonalDeteilsView(titel: LocalizedStringKey("Personal Settings"), username: appConfig.$username, amputationDate: appConfig.$amputationDate, prosthesisDate: appConfig.$prosthesisDate, targetSteps: appConfig.$targetSteps, targetFloors: appConfig.$targetFloors)
                }, from: .ignore)
                
                // MARK: - Mapped Settings
                ForEach(Pro_these_.Settings.items, id: \.id) { setting in
                    
                    NavigateTo( {
                        StackLink(systemIcon: setting.icon, buttonText: setting.titel, foregroundColor: currentTheme.accentColor)
                    }, {
                        SettingsDeteilsView(titel: setting.titel, Options: setting.options)
                    }, from: .ignore)
                    
                }
                
                // MARK: - More Settings
                NavigateTo( {
                    // List Preview
                    StackLink(systemIcon: "ellipsis", buttonText: LocalizedStringKey("More settings"), foregroundColor: currentTheme.accentColor)
                }, {
                    // List Detail
                    MoreDeteilsView(titel: LocalizedStringKey("More settings"))
                }, from: .ignore)
                
                // MARK: - Manage Prostheses and Liners
                NavigateTo( {
                    // List Preview
                    StackLink(customIcon: "prothese.above", flipIcon: true, buttonText: LocalizedStringKey("Manage Prostheses and Liners"), foregroundColor: currentTheme.accentColor)
                }, {
                    // List Detail
                    LinerOverview()
                }, from: .ignore)
                
                NavigateTo( {
                    // List Preview
                    StackLink(systemIcon: "dot.radiowaves.left.and.right", flipIcon: true, buttonText: LocalizedStringKey("NFC settings and management"), foregroundColor: currentTheme.accentColor)
                }, {
                    // List Detail
                    NFCOverview()
                }, from: .ignore)
            }
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Pro Prothese v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")")
                    .font(.footnote.bold())
                    .foregroundColor(currentTheme.textGray)
                    .padding(.horizontal, 20)
                
                // MARK: - Review
                HStack {
                    Button(action: {
                        requestReview()
                    }, label: {
                        HStack(spacing: 10){
                            VStack {
                                Image(systemName: "star.bubble")
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(currentTheme.text)
                            }
                            .padding(6)
                            .background(currentTheme.text.opacity(0.1))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(currentTheme.text, lineWidth: 1)
                                
                            )
                            
                            Text("Rate the app")
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .foregroundColor(currentTheme.text)
                        .background(currentTheme.primary.opacity(0.5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                                .stroke(currentTheme.text.opacity(0.05))
                        )
                        .cornerRadius(10)
                    })
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                
                // MARK: - Verbesserungsvorschlag
                if appConfig.hasProduct.hasProduct(.developer) {
                    WebSheetButton(titel: "Suggestion for improvement", image: "questionmark.bubble", link: "https://www.prothese.pro/verbesserungsvorschlag/", color: currentTheme.primary, disable: false)
                        .padding(.horizontal, 20)
                }
                
                // MARK: - Einrichtung
                HStack {
                    Button(action: {
                        tabManager.isSetupSheet.toggle()
                    }, label: {
                        HStack(spacing: 10){
                            VStack {
                                Image(systemName: "slider.horizontal.3")
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(currentTheme.text)
                            }
                            .padding(6)
                            .background(currentTheme.text.opacity(0.1))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(currentTheme.text, lineWidth: 1)
                                
                            )
                            
                            Text(LocalizedStringKey("Setup Assistant"))
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .foregroundColor(currentTheme.text)
                        .background(currentTheme.primary.opacity(0.5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(lineWidth: 2)
                                .stroke(currentTheme.text.opacity(0.05))
                        )
                        .cornerRadius(10)
                    })
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
            }

            VStack(alignment: .leading, spacing: 10) {
                Text("Follow on social media")
                    .font(.footnote.bold())
                    .foregroundColor(currentTheme.textGray)
                    .padding(.horizontal, 20)
                
                HStack {
                    Button(action: {
                        openInstagram("protheseapp")
                    }, label: {
                        HStack(spacing: 10){
                            VStack {
                                Image("instagram")
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(currentTheme.text)
                            }
                            .padding(6)
                            .background(currentTheme.text.opacity(0.1))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(currentTheme.text, lineWidth: 1)
                                    
                            )
                            
                            Text("Pro Prosthesis on Instagram")
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .foregroundColor(currentTheme.text)
                        .background(currentTheme.primary.opacity(0.5))
                        .overlay(
                               RoundedRectangle(cornerRadius: 10)
                               .stroke(lineWidth: 2)
                               .stroke(currentTheme.text.opacity(0.05))
                       )
                        .cornerRadius(10)
                    })
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                
                HStack {
                    Button(action: {
                        openInstagram("frederik_kohler")
                    }, label: {
                        HStack(spacing: 10){
                            VStack {
                                Image("instagram")
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(currentTheme.text)
                            }
                            .padding(6)
                            .background(currentTheme.text.opacity(0.1))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(currentTheme.text, lineWidth: 1)
                                    
                            )
                            
                            Text("The developer")
                                .multilineTextAlignment(.leading)
                            
                            Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .padding(12)
                        .foregroundColor(currentTheme.text)
                        .background(currentTheme.primary.opacity(0.5))
                        .overlay(
                               RoundedRectangle(cornerRadius: 10)
                               .stroke(lineWidth: 2)
                               .stroke(currentTheme.text.opacity(0.05))
                       )
                        .cornerRadius(10)
                    })
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
            }
            
            
            NavigateTo({
                HStack(spacing: 10){
                    VStack {
                        Image("instagram")
                            .frame(width: 20, height: 20)
                            .foregroundColor(currentTheme.text)
                    }
                    .padding(6)
                    .background(currentTheme.text.opacity(0.1))
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(currentTheme.text, lineWidth: 1)
                            
                    )
                    
                    Text("App changelog")
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .padding(12)
                .foregroundColor(currentTheme.text)
                .background(currentTheme.primary.opacity(0.5))
                .overlay(
                       RoundedRectangle(cornerRadius: 10)
                       .stroke(lineWidth: 2)
                       .stroke(currentTheme.text.opacity(0.05))
               )
                .cornerRadius(10)
                .padding(.horizontal, 20)
            }, {
                AppVersionView()
            }, from: .more).show(appConfig.showChangeLog)
        }
        
    }
    
    private func openInstagram(_ string: String) {
        guard let url = URL(string: "https://instagram.com/\(string)") else { return }
        
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
                
    }
    
    @ViewBuilder func NFCOverview() -> some View {
        ZStack {
            currentTheme.gradientBackground(nil).ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    // MARK: - Page Header
                    Header("NFC settings and management")
                        .padding(.bottom)
                    
                    
                    
                    nfcWriterButton()
                }
            }
        }
    }
    
    @ViewBuilder func Header(_ text: LocalizedStringKey) -> some View {
        HStack{
            Spacer()
            
            Text(text)
                .foregroundColor(currentTheme.text)
            
            Spacer()
        }
        .padding(.top, 25)
        .padding(.horizontal)
    }
    
    @ViewBuilder func Link(buttonText: String, foregroundColor: Color) -> some View {
        HStack {
            HStack{
                Text(buttonText)
                    .foregroundColor(foregroundColor)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(currentTheme.labelBackground(nil))
            .overlay(
                   RoundedRectangle(cornerRadius: 10)
                   .stroke(lineWidth: 2)
                   .stroke(foregroundColor)
           )
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 50)
    }

    @ViewBuilder func StackLink(systemIcon: String? = nil, customIcon: String? = nil, flipIcon: Bool? = false, buttonText: LocalizedStringKey, foregroundColor: Color) -> some View {
        let flip = flipIcon ?? false
        
        HStack {
            HStack(spacing: 10){
                VStack(){
                    if systemIcon != nil {
                        Image(systemName: systemIcon!)
                            .frame(width: 20, height: 20)
                            .foregroundColor(currentTheme.text)
                    }
                    
                    if customIcon != nil {
                        Image(customIcon!)
                            .frame(width: 20, height: 20)
                            .foregroundColor(currentTheme.text)
                            .scaleEffect(x: flip ? -1 : 0, y: flip ? 1 : 0)
                    }
                }
                .padding(6)
                .background(currentTheme.text.opacity(0.1))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(currentTheme.text, lineWidth: 1)
                        
                )
                
                Text(buttonText)
                    .multilineTextAlignment(.leading)
                    
                Spacer()
                
                Image(systemName: "chevron.right")
                    .frame(width: 20, height: 20)
                    .foregroundColor(currentTheme.text)
            }
            .frame(maxWidth: .infinity)
            .padding(12)
            .foregroundColor(currentTheme.text)
            .background(currentTheme.primary.opacity(0.5))
            .overlay(
                   RoundedRectangle(cornerRadius: 10)
                   .stroke(lineWidth: 2)
                   .stroke(currentTheme.text.opacity(0.05))
           )
            .cornerRadius(10)
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 20)
    }
    
    @ViewBuilder func GetProCard() -> some View {
        HStack(alignment: .center, spacing: 20) {
            Image(systemName: "sparkles")
                .font(.largeTitle)
            
            VStack {
                HStack {
                    Text("Even more functions")
                        .font(.headline.bold())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Spacer()
                }
                
                HStack {
                    Text("Update to unlock all Pro functionality")
                        .font(.footnote)
                        .multilineTextAlignment(.leading)
                    
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity)
        }
        .foregroundColor(currentTheme == Theme.orange ? currentTheme.text : currentTheme.primary)
        .padding(.vertical, 6)
        .padding(.horizontal)
        .background(currentTheme.hightlightColor.gradient)
        .cornerRadius(10)
        .padding(.horizontal, 20)
    }
    
    private func calculatePercentage(value:Double,percentageVal:Double)->Double{
        return 100.0 / value * percentageVal
    }
    
    func calcOpacity(_ int: CGFloat) -> Double {
        let imput = Double(int)
        
        guard imput.sign == .minus else {
            return 1
        }
        
        guard imput <= -150.0 else {
            return 1
        }
        
        let result = 100 / -150 *  imput
        
        return result / 100
    }
    
    func loadNotifications() {
        PushNotificationManager().getAllPendingNotifications(debug: false) { note in
            DispatchQueue.main.async {
                notes.append(note)
            }
        }
    }
    
    func sayHallo(name: String) -> LocalizedStringKey {
        let hour = Calendar.current.component(.hour, from: Date())
        
        var string: LocalizedStringKey = ""
        
        var nameString = ""
        if name != "" {
            nameString = ", \(name)"
        }

        switch hour {
            case 6..<12 : string = LocalizedStringKey("Good morning\(nameString)!")
            case 12 : string = LocalizedStringKey("Hello\(nameString)!")
            case 13..<17 :  string = LocalizedStringKey("Hello\(nameString)!")
            case 17..<22 : string = LocalizedStringKey("Good evening\(nameString)!")
            default: string = LocalizedStringKey("Hello\(nameString)!")
        }
        
        return string
    }
}

#Preview {
    MoreTab()
}
