//
//  AppVersion.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 17.10.23.
//

import SwiftUI
import Alamofire
import Foundation

struct AppVersionView: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    @State var changeLog: [AppVersionResponse]? = nil
    
    @State var isHideLoader: Bool = false
    @State var isHideChangeLog: Bool = true
    
    private var changeLogSorted: [AppVersionResponse] {
        let x = self.changeLog ?? []
        
        x.map({ $0.attributes.version.replacingOccurrences(of: "p", with: "") })

        return x.sorted(by: { $0.attributes.version > $1.attributes.version })
    }
    
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    
    var body: some View {
        ZStack {
            Background()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
 
                    Header("App changelog") 
                        .padding(.bottom)
                    
                    ForEach(changeLogSorted.sorted(by: { $0.attributes.version > $1.attributes.version }).indices, id: \.self) { index in
                        VStack(spacing: 0) {
                            AppVersionDisclosureGroup(build: changeLogSorted[index].attributes, open: index == 0 ? true : false)
                        }
                        .background(.ultraThinMaterial.opacity(0.4))
                        .cornerRadius(10)
                    }
                    
                    Spacer(minLength: 20)
                    
                }
                .padding(.horizontal)
            }
                .opacity(isHideChangeLog ? 0 : 1)
            
            LoaderView(tintColor: currentTheme.hightlightColor, scaleSize: 3.0).padding(.bottom,50)
                .opacity(isHideLoader ? 0 : 1)
                //.hidden(isHideLoader)
            
        }
        .onAppear {
            fetchChangeLog(appID: 1) { response in
                self.changeLog = response.data
                withAnimation(.easeInOut(duration: 0.3).delay(0.3)) {
                    isHideChangeLog = false
                }
                
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isHideLoader = true
                    }
                })
            }
        }
        .onDisappear {
            self.changeLog = []
        }
    }
    
    private func fetchChangeLog(appID: Int, completion: @escaping (AppAPIResponse) -> Void) {
        let currentLocale = Locale.current.language.languageCode
        
        let url = "https://api.frederikkohler.de/api/change-logs?locale=\(currentLocale ?? "en")&populate=*"

        AF.request(url).responseDecodable(of: AppAPIResponse.self) { response in
            switch response.result {
                case .success(let appVersionResponse):
                    if appVersionResponse.data.isEmpty {
                        self.fetchChangeLogWithDefaultLocale(completion: completion)
                    } else {
                        completion(appVersionResponse)
                    }
                case .failure(let error):
                    print("Fehler bei der Anfrage: \(error)")
            }
        }
    }
    
    private func fetchChangeLogWithDefaultLocale(completion: @escaping (AppAPIResponse) -> Void) {
        let defaultLocale = "en"
        let url = "https://api.frederikkohler.de/api/change-logs?locale=\(defaultLocale)&populate=*"

        AF.request(url).responseDecodable(of: AppAPIResponse.self) { response in
            switch response.result {
            case .success(let appVersionResponse):
                completion(appVersionResponse)
            case .failure(let error):
                print("Fehler bei der Anfrage: \(error)")
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
    
    @ViewBuilder func Background() -> some View {
        currentTheme.gradientBackground(nil)
            .ignoresSafeArea()
        
        CircleAnimationInBackground(delay: 0.3, duration: 2)
            .opacity(0.2)
            .ignoresSafeArea()
    }
}

struct LoaderView: View {
    var tintColor: Color = .blue
    var scaleSize: CGFloat = 1.0
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ProgressView()
                    .scaleEffect(scaleSize, anchor: .center)
                    .progressViewStyle(CircularProgressViewStyle(tint: tintColor))
                Spacer()
            }
            Spacer()
        }
    }
}






struct AppFeature: Codable {
    var id: Int
    var name: String
}

struct AppAttributes: Codable {
    var version: String
    var createdAt: String
    var updatedAt: String
    var publishedAt: String
    var locale: String
    var features: [AppFeature]
}

struct AppData: Codable {
    var id: Int
    var attributes: AppAttributes
}

struct AppLocalization: Codable {
    // Falls notwendig, können hier noch Eigenschaften hinzugefügt werden
}

struct AppVersionResponse: Codable {
    var id: Int
    var attributes: AppAttributes
    var app: AppData?
    var localizations: AppLocalization?
}

struct AppMeta: Codable {
    var pagination: Pagination
}

struct Pagination: Codable {
    var page: Int
    var pageSize: Int
    var pageCount: Int
    var total: Int
}

struct AppAPIResponse: Codable {
    var data: [AppVersionResponse]
    var meta: AppMeta
}
