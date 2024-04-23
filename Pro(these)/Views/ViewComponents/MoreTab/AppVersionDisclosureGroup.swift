//
//  AppVersionDisclosureGroup.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 24.10.23.
//

import SwiftUI

struct AppVersionDisclosureGroup: View {
    @EnvironmentObject var themeManager: ThemeManager
    
    private var currentTheme: Theme {
        return self.themeManager.currentTheme()
    }
    
    @State private var isExpanded: Bool = false

    var build: AppAttributes
    
    var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    var open: Bool
    
    var body: some View {
        DisclosureGroup(
            isExpanded: $isExpanded,
            content: {
                VStack(spacing: 15) {
                    ForEach(build.features, id: \.id) { feature in
                        HStack {
                            Text("+ " + feature.name)
                            Spacer()
                        }
                    }
                }
                .padding(.vertical, 10)
            },
            label: {
                HStack(alignment: .center, spacing: 10) {
                    
                    Image(systemName: "v.square")
                        .font(screenWidth < 400 ? .title3.bold() : .title3.bold())
                        .foregroundColor(currentTheme.text)
                    
                    HStack {
                        
                        Text(build.version.replacingOccurrences(of: "p", with: ""))
                            .font(screenWidth < 400 ? .body.bold() : .headline.bold())
                            .foregroundColor(currentTheme.text)

                        Spacer()

                        let buildDate = convertStringToDate(build.createdAt)
                        
                        if let date = buildDate {
                            Text(date.dateFormatte(date: "dd.MM.yy", time: "").date)
                                .font(.caption2)
                                .foregroundColor(currentTheme.textGray)
                        }
                       
                    }
                }
            }
        )
        .accentColor(currentTheme.text)
        .padding()
        .onAppear(perform: {
            isExpanded = open
        })
    }
    
    private func convertStringToDate(_ dateString: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        return dateFormatter.date(from: dateString)
    }
}
