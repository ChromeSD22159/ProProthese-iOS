//
//  LiveViewExtensionBundle.swift
//  LiveViewExtension
//
//  Created by Frederik Kohler on 25.04.23.
//

import WidgetKit
import SwiftUI

@main
struct LiveViewExtensionBundle: WidgetBundle {
    var body: some Widget {
        LiveViewExtension()
        
        Prothesen_widgetLiveActivity()
        
        LiveActivity()
    }
}

