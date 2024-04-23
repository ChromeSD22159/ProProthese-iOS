import Foundation
#if canImport(AppKit)
import AppKit
#endif
#if canImport(UIKit)
import UIKit
#endif
#if canImport(SwiftUI)
import SwiftUI
#endif
#if canImport(DeveloperToolsSupport)
import DeveloperToolsSupport
#endif

#if SWIFT_PACKAGE
private let resourceBundle = Foundation.Bundle.module
#else
private class ResourceBundleClass {}
private let resourceBundle = Foundation.Bundle(for: ResourceBundleClass.self)
#endif

// MARK: - Color Symbols -

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
extension ColorResource {

}

// MARK: - Image Symbols -

@available(iOS 11.0, macOS 10.7, tvOS 11.0, *)
extension ImageResource {

    /// The "AppLogoTransparent" asset catalog image resource.
    static let appLogoTransparent = ImageResource(name: "AppLogoTransparent", bundle: resourceBundle)

    /// The "Develper" asset catalog image resource.
    static let develper = ImageResource(name: "Develper", bundle: resourceBundle)

    /// The "Doctor" asset catalog image resource.
    static let doctor = ImageResource(name: "Doctor", bundle: resourceBundle)

    /// The "GetProProthese" asset catalog image resource.
    static let getProProthese = ImageResource(name: "GetProProthese", bundle: resourceBundle)

    /// The "GetProProthesePNG" asset catalog image resource.
    static let getProProthesePNG = ImageResource(name: "GetProProthesePNG", bundle: resourceBundle)

    /// The "Hospital" asset catalog image resource.
    static let hospital = ImageResource(name: "Hospital", bundle: resourceBundle)

    /// The "Illustration" asset catalog image resource.
    static let illustration = ImageResource(name: "Illustration", bundle: resourceBundle)

    /// The "LaunchImage_blueV1" asset catalog image resource.
    static let launchImageBlueV1 = ImageResource(name: "LaunchImage_blueV1", bundle: resourceBundle)

    /// The "LaunchImage_blueV2" asset catalog image resource.
    static let launchImageBlueV2 = ImageResource(name: "LaunchImage_blueV2", bundle: resourceBundle)

    /// The "LaunchImage_blueV3" asset catalog image resource.
    static let launchImageBlueV3 = ImageResource(name: "LaunchImage_blueV3", bundle: resourceBundle)

    /// The "LaunchImage_greenV1" asset catalog image resource.
    static let launchImageGreenV1 = ImageResource(name: "LaunchImage_greenV1", bundle: resourceBundle)

    /// The "LaunchImage_greenV2" asset catalog image resource.
    static let launchImageGreenV2 = ImageResource(name: "LaunchImage_greenV2", bundle: resourceBundle)

    /// The "LaunchImage_greenV3" asset catalog image resource.
    static let launchImageGreenV3 = ImageResource(name: "LaunchImage_greenV3", bundle: resourceBundle)

    /// The "LaunchImage_orangeV1" asset catalog image resource.
    static let launchImageOrangeV1 = ImageResource(name: "LaunchImage_orangeV1", bundle: resourceBundle)

    /// The "LaunchImage_orangeV2" asset catalog image resource.
    static let launchImageOrangeV2 = ImageResource(name: "LaunchImage_orangeV2", bundle: resourceBundle)

    /// The "LaunchImage_orangeV3" asset catalog image resource.
    static let launchImageOrangeV3 = ImageResource(name: "LaunchImage_orangeV3", bundle: resourceBundle)

    /// The "LaunchImage_pinkV1" asset catalog image resource.
    static let launchImagePinkV1 = ImageResource(name: "LaunchImage_pinkV1", bundle: resourceBundle)

    /// The "LaunchImage_pinkV2" asset catalog image resource.
    static let launchImagePinkV2 = ImageResource(name: "LaunchImage_pinkV2", bundle: resourceBundle)

    /// The "LaunchImage_pinkV3" asset catalog image resource.
    static let launchImagePinkV3 = ImageResource(name: "LaunchImage_pinkV3", bundle: resourceBundle)

    /// The "Physio" asset catalog image resource.
    static let physio = ImageResource(name: "Physio", bundle: resourceBundle)

    /// The "ProWidgetPreview1" asset catalog image resource.
    static let proWidgetPreview1 = ImageResource(name: "ProWidgetPreview1", bundle: resourceBundle)

    /// The "ProWidgetPreview2" asset catalog image resource.
    static let proWidgetPreview2 = ImageResource(name: "ProWidgetPreview2", bundle: resourceBundle)

    /// The "ProWidgetPreview3" asset catalog image resource.
    static let proWidgetPreview3 = ImageResource(name: "ProWidgetPreview3", bundle: resourceBundle)

    /// The "ProWidgetPreview4" asset catalog image resource.
    static let proWidgetPreview4 = ImageResource(name: "ProWidgetPreview4", bundle: resourceBundle)

    /// The "SnapShotBGOverlay" asset catalog image resource.
    static let snapShotBGOverlay = ImageResource(name: "SnapShotBGOverlay", bundle: resourceBundle)

    /// The "SnapShotLogo" asset catalog image resource.
    static let snapShotLogo = ImageResource(name: "SnapShotLogo", bundle: resourceBundle)

    /// The "SnapShotV1" asset catalog image resource.
    static let snapShotV1 = ImageResource(name: "SnapShotV1", bundle: resourceBundle)

    /// The "SnapShotV2" asset catalog image resource.
    static let snapShotV2 = ImageResource(name: "SnapShotV2", bundle: resourceBundle)

    /// The "SnapShotV3" asset catalog image resource.
    static let snapShotV3 = ImageResource(name: "SnapShotV3", bundle: resourceBundle)

    /// The "SnapShotV4" asset catalog image resource.
    static let snapShotV4 = ImageResource(name: "SnapShotV4", bundle: resourceBundle)

    /// The "SnapShotV5" asset catalog image resource.
    static let snapShotV5 = ImageResource(name: "SnapShotV5", bundle: resourceBundle)

    /// The "Stetoskop" asset catalog image resource.
    static let stetoskop = ImageResource(name: "Stetoskop", bundle: resourceBundle)

    /// The "ThemePreview_blue" asset catalog image resource.
    static let themePreviewBlue = ImageResource(name: "ThemePreview_blue", bundle: resourceBundle)

    /// The "ThemePreview_green" asset catalog image resource.
    static let themePreviewGreen = ImageResource(name: "ThemePreview_green", bundle: resourceBundle)

    /// The "ThemePreview_orange" asset catalog image resource.
    static let themePreviewOrange = ImageResource(name: "ThemePreview_orange", bundle: resourceBundle)

    /// The "ThemePreview_pink" asset catalog image resource.
    static let themePreviewPink = ImageResource(name: "ThemePreview_pink", bundle: resourceBundle)

    /// The "background" asset catalog image resource.
    static let background = ImageResource(name: "background", bundle: resourceBundle)

    /// The "background2" asset catalog image resource.
    static let background2 = ImageResource(name: "background2", bundle: resourceBundle)

    /// The "background3" asset catalog image resource.
    static let background3 = ImageResource(name: "background3", bundle: resourceBundle)

    /// The "chart_bar_feeling_1" asset catalog image resource.
    static let chartBarFeeling1 = ImageResource(name: "chart_bar_feeling_1", bundle: resourceBundle)

    /// The "chart_bar_feeling_2" asset catalog image resource.
    static let chartBarFeeling2 = ImageResource(name: "chart_bar_feeling_2", bundle: resourceBundle)

    /// The "chart_bar_feeling_3" asset catalog image resource.
    static let chartBarFeeling3 = ImageResource(name: "chart_bar_feeling_3", bundle: resourceBundle)

    /// The "chart_bar_feeling_4" asset catalog image resource.
    static let chartBarFeeling4 = ImageResource(name: "chart_bar_feeling_4", bundle: resourceBundle)

    /// The "chart_bar_feeling_5" asset catalog image resource.
    static let chartBarFeeling5 = ImageResource(name: "chart_bar_feeling_5", bundle: resourceBundle)

    /// The "chart_feeling_1" asset catalog image resource.
    static let chartFeeling1 = ImageResource(name: "chart_feeling_1", bundle: resourceBundle)

    /// The "chart_feeling_2" asset catalog image resource.
    static let chartFeeling2 = ImageResource(name: "chart_feeling_2", bundle: resourceBundle)

    /// The "chart_feeling_3" asset catalog image resource.
    static let chartFeeling3 = ImageResource(name: "chart_feeling_3", bundle: resourceBundle)

    /// The "chart_feeling_4" asset catalog image resource.
    static let chartFeeling4 = ImageResource(name: "chart_feeling_4", bundle: resourceBundle)

    /// The "chart_feeling_5" asset catalog image resource.
    static let chartFeeling5 = ImageResource(name: "chart_feeling_5", bundle: resourceBundle)

    /// The "d113" asset catalog image resource.
    static let d113 = ImageResource(name: "d113", bundle: resourceBundle)

    /// The "d116" asset catalog image resource.
    static let d116 = ImageResource(name: "d116", bundle: resourceBundle)

    /// The "d119" asset catalog image resource.
    static let d119 = ImageResource(name: "d119", bundle: resourceBundle)

    /// The "d122" asset catalog image resource.
    static let d122 = ImageResource(name: "d122", bundle: resourceBundle)

    /// The "d143" asset catalog image resource.
    static let d143 = ImageResource(name: "d143", bundle: resourceBundle)

    /// The "d176" asset catalog image resource.
    static let d176 = ImageResource(name: "d176", bundle: resourceBundle)

    /// The "d179" asset catalog image resource.
    static let d179 = ImageResource(name: "d179", bundle: resourceBundle)

    /// The "d182" asset catalog image resource.
    static let d182 = ImageResource(name: "d182", bundle: resourceBundle)

    /// The "d185" asset catalog image resource.
    static let d185 = ImageResource(name: "d185", bundle: resourceBundle)

    /// The "d200" asset catalog image resource.
    static let d200 = ImageResource(name: "d200", bundle: resourceBundle)

    /// The "d227" asset catalog image resource.
    static let d227 = ImageResource(name: "d227", bundle: resourceBundle)

    /// The "d230" asset catalog image resource.
    static let d230 = ImageResource(name: "d230", bundle: resourceBundle)

    /// The "d248" asset catalog image resource.
    static let d248 = ImageResource(name: "d248", bundle: resourceBundle)

    /// The "d260" asset catalog image resource.
    static let d260 = ImageResource(name: "d260", bundle: resourceBundle)

    /// The "d263" asset catalog image resource.
    static let d263 = ImageResource(name: "d263", bundle: resourceBundle)

    /// The "d266" asset catalog image resource.
    static let d266 = ImageResource(name: "d266", bundle: resourceBundle)

    /// The "d281" asset catalog image resource.
    static let d281 = ImageResource(name: "d281", bundle: resourceBundle)

    /// The "d284" asset catalog image resource.
    static let d284 = ImageResource(name: "d284", bundle: resourceBundle)

    /// The "d293" asset catalog image resource.
    static let d293 = ImageResource(name: "d293", bundle: resourceBundle)

    /// The "d296" asset catalog image resource.
    static let d296 = ImageResource(name: "d296", bundle: resourceBundle)

    /// The "d299" asset catalog image resource.
    static let d299 = ImageResource(name: "d299", bundle: resourceBundle)

    /// The "d302" asset catalog image resource.
    static let d302 = ImageResource(name: "d302", bundle: resourceBundle)

    /// The "d305" asset catalog image resource.
    static let d305 = ImageResource(name: "d305", bundle: resourceBundle)

    /// The "d308" asset catalog image resource.
    static let d308 = ImageResource(name: "d308", bundle: resourceBundle)

    /// The "d311" asset catalog image resource.
    static let d311 = ImageResource(name: "d311", bundle: resourceBundle)

    /// The "d314" asset catalog image resource.
    static let d314 = ImageResource(name: "d314", bundle: resourceBundle)

    /// The "d317" asset catalog image resource.
    static let d317 = ImageResource(name: "d317", bundle: resourceBundle)

    /// The "d320" asset catalog image resource.
    static let d320 = ImageResource(name: "d320", bundle: resourceBundle)

    /// The "d323" asset catalog image resource.
    static let d323 = ImageResource(name: "d323", bundle: resourceBundle)

    /// The "d326" asset catalog image resource.
    static let d326 = ImageResource(name: "d326", bundle: resourceBundle)

    /// The "d329" asset catalog image resource.
    static let d329 = ImageResource(name: "d329", bundle: resourceBundle)

    /// The "d332" asset catalog image resource.
    static let d332 = ImageResource(name: "d332", bundle: resourceBundle)

    /// The "d335" asset catalog image resource.
    static let d335 = ImageResource(name: "d335", bundle: resourceBundle)

    /// The "d338" asset catalog image resource.
    static let d338 = ImageResource(name: "d338", bundle: resourceBundle)

    /// The "d350" asset catalog image resource.
    static let d350 = ImageResource(name: "d350", bundle: resourceBundle)

    /// The "d353" asset catalog image resource.
    static let d353 = ImageResource(name: "d353", bundle: resourceBundle)

    /// The "d356" asset catalog image resource.
    static let d356 = ImageResource(name: "d356", bundle: resourceBundle)

    /// The "d359" asset catalog image resource.
    static let d359 = ImageResource(name: "d359", bundle: resourceBundle)

    /// The "d362" asset catalog image resource.
    static let d362 = ImageResource(name: "d362", bundle: resourceBundle)

    /// The "d365" asset catalog image resource.
    static let d365 = ImageResource(name: "d365", bundle: resourceBundle)

    /// The "d368" asset catalog image resource.
    static let d368 = ImageResource(name: "d368", bundle: resourceBundle)

    /// The "d371" asset catalog image resource.
    static let d371 = ImageResource(name: "d371", bundle: resourceBundle)

    /// The "d374" asset catalog image resource.
    static let d374 = ImageResource(name: "d374", bundle: resourceBundle)

    /// The "d377" asset catalog image resource.
    static let d377 = ImageResource(name: "d377", bundle: resourceBundle)

    /// The "d386" asset catalog image resource.
    static let d386 = ImageResource(name: "d386", bundle: resourceBundle)

    /// The "d389" asset catalog image resource.
    static let d389 = ImageResource(name: "d389", bundle: resourceBundle)

    /// The "d392" asset catalog image resource.
    static let d392 = ImageResource(name: "d392", bundle: resourceBundle)

    /// The "d395" asset catalog image resource.
    static let d395 = ImageResource(name: "d395", bundle: resourceBundle)

    /// The "n113" asset catalog image resource.
    static let n113 = ImageResource(name: "n113", bundle: resourceBundle)

    /// The "n116" asset catalog image resource.
    static let n116 = ImageResource(name: "n116", bundle: resourceBundle)

    /// The "n119" asset catalog image resource.
    static let n119 = ImageResource(name: "n119", bundle: resourceBundle)

    /// The "n122" asset catalog image resource.
    static let n122 = ImageResource(name: "n122", bundle: resourceBundle)

    /// The "n143" asset catalog image resource.
    static let n143 = ImageResource(name: "n143", bundle: resourceBundle)

    /// The "n176" asset catalog image resource.
    static let n176 = ImageResource(name: "n176", bundle: resourceBundle)

    /// The "n179" asset catalog image resource.
    static let n179 = ImageResource(name: "n179", bundle: resourceBundle)

    /// The "n182" asset catalog image resource.
    static let n182 = ImageResource(name: "n182", bundle: resourceBundle)

    /// The "n185" asset catalog image resource.
    static let n185 = ImageResource(name: "n185", bundle: resourceBundle)

    /// The "n200" asset catalog image resource.
    static let n200 = ImageResource(name: "n200", bundle: resourceBundle)

    /// The "n227" asset catalog image resource.
    static let n227 = ImageResource(name: "n227", bundle: resourceBundle)

    /// The "n230" asset catalog image resource.
    static let n230 = ImageResource(name: "n230", bundle: resourceBundle)

    /// The "n248" asset catalog image resource.
    static let n248 = ImageResource(name: "n248", bundle: resourceBundle)

    /// The "n260" asset catalog image resource.
    static let n260 = ImageResource(name: "n260", bundle: resourceBundle)

    /// The "n263" asset catalog image resource.
    static let n263 = ImageResource(name: "n263", bundle: resourceBundle)

    /// The "n266" asset catalog image resource.
    static let n266 = ImageResource(name: "n266", bundle: resourceBundle)

    /// The "n281" asset catalog image resource.
    static let n281 = ImageResource(name: "n281", bundle: resourceBundle)

    /// The "n284" asset catalog image resource.
    static let n284 = ImageResource(name: "n284", bundle: resourceBundle)

    /// The "n293" asset catalog image resource.
    static let n293 = ImageResource(name: "n293", bundle: resourceBundle)

    /// The "n296" asset catalog image resource.
    static let n296 = ImageResource(name: "n296", bundle: resourceBundle)

    /// The "n299" asset catalog image resource.
    static let n299 = ImageResource(name: "n299", bundle: resourceBundle)

    /// The "n302" asset catalog image resource.
    static let n302 = ImageResource(name: "n302", bundle: resourceBundle)

    /// The "n305" asset catalog image resource.
    static let n305 = ImageResource(name: "n305", bundle: resourceBundle)

    /// The "n308" asset catalog image resource.
    static let n308 = ImageResource(name: "n308", bundle: resourceBundle)

    /// The "n311" asset catalog image resource.
    static let n311 = ImageResource(name: "n311", bundle: resourceBundle)

    /// The "n314" asset catalog image resource.
    static let n314 = ImageResource(name: "n314", bundle: resourceBundle)

    /// The "n317" asset catalog image resource.
    static let n317 = ImageResource(name: "n317", bundle: resourceBundle)

    /// The "n320" asset catalog image resource.
    static let n320 = ImageResource(name: "n320", bundle: resourceBundle)

    /// The "n323" asset catalog image resource.
    static let n323 = ImageResource(name: "n323", bundle: resourceBundle)

    /// The "n326" asset catalog image resource.
    static let n326 = ImageResource(name: "n326", bundle: resourceBundle)

    /// The "n329" asset catalog image resource.
    static let n329 = ImageResource(name: "n329", bundle: resourceBundle)

    /// The "n332" asset catalog image resource.
    static let n332 = ImageResource(name: "n332", bundle: resourceBundle)

    /// The "n335" asset catalog image resource.
    static let n335 = ImageResource(name: "n335", bundle: resourceBundle)

    /// The "n338" asset catalog image resource.
    static let n338 = ImageResource(name: "n338", bundle: resourceBundle)

    /// The "n350" asset catalog image resource.
    static let n350 = ImageResource(name: "n350", bundle: resourceBundle)

    /// The "n353" asset catalog image resource.
    static let n353 = ImageResource(name: "n353", bundle: resourceBundle)

    /// The "n356" asset catalog image resource.
    static let n356 = ImageResource(name: "n356", bundle: resourceBundle)

    /// The "n359" asset catalog image resource.
    static let n359 = ImageResource(name: "n359", bundle: resourceBundle)

    /// The "n362" asset catalog image resource.
    static let n362 = ImageResource(name: "n362", bundle: resourceBundle)

    /// The "n365" asset catalog image resource.
    static let n365 = ImageResource(name: "n365", bundle: resourceBundle)

    /// The "n368" asset catalog image resource.
    static let n368 = ImageResource(name: "n368", bundle: resourceBundle)

    /// The "n371" asset catalog image resource.
    static let n371 = ImageResource(name: "n371", bundle: resourceBundle)

    /// The "n374" asset catalog image resource.
    static let n374 = ImageResource(name: "n374", bundle: resourceBundle)

    /// The "n377" asset catalog image resource.
    static let n377 = ImageResource(name: "n377", bundle: resourceBundle)

    /// The "n386" asset catalog image resource.
    static let n386 = ImageResource(name: "n386", bundle: resourceBundle)

    /// The "n389" asset catalog image resource.
    static let n389 = ImageResource(name: "n389", bundle: resourceBundle)

    /// The "n392" asset catalog image resource.
    static let n392 = ImageResource(name: "n392", bundle: resourceBundle)

    /// The "n395" asset catalog image resource.
    static let n395 = ImageResource(name: "n395", bundle: resourceBundle)

    /// The "prostheticAbove" asset catalog image resource.
    static let prostheticAbove = ImageResource(name: "prostheticAbove", bundle: resourceBundle)

    /// The "prostheticBelow" asset catalog image resource.
    static let prostheticBelow = ImageResource(name: "prostheticBelow", bundle: resourceBundle)

    /// The "distance" asset catalog image resource.
    static let distance = ImageResource(name: "distance", bundle: resourceBundle)

    /// The "feeling_1" asset catalog image resource.
    static let feeling1 = ImageResource(name: "feeling_1", bundle: resourceBundle)

    /// The "feeling_2" asset catalog image resource.
    static let feeling2 = ImageResource(name: "feeling_2", bundle: resourceBundle)

    /// The "feeling_3" asset catalog image resource.
    static let feeling3 = ImageResource(name: "feeling_3", bundle: resourceBundle)

    /// The "feeling_4" asset catalog image resource.
    static let feeling4 = ImageResource(name: "feeling_4", bundle: resourceBundle)

    /// The "feeling_5" asset catalog image resource.
    static let feeling5 = ImageResource(name: "feeling_5", bundle: resourceBundle)

    /// The "figure.prothese" asset catalog image resource.
    static let figureProthese = ImageResource(name: "figure.prothese", bundle: resourceBundle)

    /// The "figure.prothese.motion" asset catalog image resource.
    static let figureProtheseMotion = ImageResource(name: "figure.prothese.motion", bundle: resourceBundle)

    /// The "figure.prothese.stairs" asset catalog image resource.
    static let figureProtheseStairs = ImageResource(name: "figure.prothese.stairs", bundle: resourceBundle)

    /// The "figure.steps" asset catalog image resource.
    static let figureSteps = ImageResource(name: "figure.steps", bundle: resourceBundle)

    /// The "instagram" asset catalog image resource.
    static let instagram = ImageResource(name: "instagram", bundle: resourceBundle)

    /// The "pain" asset catalog image resource.
    static let pain = ImageResource(name: "pain", bundle: resourceBundle)

    /// The "prothese.above" asset catalog image resource.
    static let protheseAbove = ImageResource(name: "prothese.above", bundle: resourceBundle)

    /// The "prothese.below" asset catalog image resource.
    static let protheseBelow = ImageResource(name: "prothese.below", bundle: resourceBundle)

    /// The "prothese.liner" asset catalog image resource.
    static let protheseLiner = ImageResource(name: "prothese.liner", bundle: resourceBundle)

}

// MARK: - Color Symbol Extensions -

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    /// The "AppLogoTransparent" asset catalog image.
    static var appLogoTransparent: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .appLogoTransparent)
#else
        .init()
#endif
    }

    /// The "Develper" asset catalog image.
    static var develper: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .develper)
#else
        .init()
#endif
    }

    /// The "Doctor" asset catalog image.
    static var doctor: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .doctor)
#else
        .init()
#endif
    }

    /// The "GetProProthese" asset catalog image.
    static var getProProthese: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .getProProthese)
#else
        .init()
#endif
    }

    /// The "GetProProthesePNG" asset catalog image.
    static var getProProthesePNG: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .getProProthesePNG)
#else
        .init()
#endif
    }

    /// The "Hospital" asset catalog image.
    static var hospital: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .hospital)
#else
        .init()
#endif
    }

    /// The "Illustration" asset catalog image.
    static var illustration: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .illustration)
#else
        .init()
#endif
    }

    /// The "LaunchImage_blueV1" asset catalog image.
    static var launchImageBlueV1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .launchImageBlueV1)
#else
        .init()
#endif
    }

    /// The "LaunchImage_blueV2" asset catalog image.
    static var launchImageBlueV2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .launchImageBlueV2)
#else
        .init()
#endif
    }

    /// The "LaunchImage_blueV3" asset catalog image.
    static var launchImageBlueV3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .launchImageBlueV3)
#else
        .init()
#endif
    }

    /// The "LaunchImage_greenV1" asset catalog image.
    static var launchImageGreenV1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .launchImageGreenV1)
#else
        .init()
#endif
    }

    /// The "LaunchImage_greenV2" asset catalog image.
    static var launchImageGreenV2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .launchImageGreenV2)
#else
        .init()
#endif
    }

    /// The "LaunchImage_greenV3" asset catalog image.
    static var launchImageGreenV3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .launchImageGreenV3)
#else
        .init()
#endif
    }

    /// The "LaunchImage_orangeV1" asset catalog image.
    static var launchImageOrangeV1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .launchImageOrangeV1)
#else
        .init()
#endif
    }

    /// The "LaunchImage_orangeV2" asset catalog image.
    static var launchImageOrangeV2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .launchImageOrangeV2)
#else
        .init()
#endif
    }

    /// The "LaunchImage_orangeV3" asset catalog image.
    static var launchImageOrangeV3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .launchImageOrangeV3)
#else
        .init()
#endif
    }

    /// The "LaunchImage_pinkV1" asset catalog image.
    static var launchImagePinkV1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .launchImagePinkV1)
#else
        .init()
#endif
    }

    /// The "LaunchImage_pinkV2" asset catalog image.
    static var launchImagePinkV2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .launchImagePinkV2)
#else
        .init()
#endif
    }

    /// The "LaunchImage_pinkV3" asset catalog image.
    static var launchImagePinkV3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .launchImagePinkV3)
#else
        .init()
#endif
    }

    /// The "Physio" asset catalog image.
    static var physio: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .physio)
#else
        .init()
#endif
    }

    /// The "ProWidgetPreview1" asset catalog image.
    static var proWidgetPreview1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .proWidgetPreview1)
#else
        .init()
#endif
    }

    /// The "ProWidgetPreview2" asset catalog image.
    static var proWidgetPreview2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .proWidgetPreview2)
#else
        .init()
#endif
    }

    /// The "ProWidgetPreview3" asset catalog image.
    static var proWidgetPreview3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .proWidgetPreview3)
#else
        .init()
#endif
    }

    /// The "ProWidgetPreview4" asset catalog image.
    static var proWidgetPreview4: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .proWidgetPreview4)
#else
        .init()
#endif
    }

    /// The "SnapShotBGOverlay" asset catalog image.
    static var snapShotBGOverlay: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .snapShotBGOverlay)
#else
        .init()
#endif
    }

    /// The "SnapShotLogo" asset catalog image.
    static var snapShotLogo: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .snapShotLogo)
#else
        .init()
#endif
    }

    /// The "SnapShotV1" asset catalog image.
    static var snapShotV1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .snapShotV1)
#else
        .init()
#endif
    }

    /// The "SnapShotV2" asset catalog image.
    static var snapShotV2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .snapShotV2)
#else
        .init()
#endif
    }

    /// The "SnapShotV3" asset catalog image.
    static var snapShotV3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .snapShotV3)
#else
        .init()
#endif
    }

    /// The "SnapShotV4" asset catalog image.
    static var snapShotV4: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .snapShotV4)
#else
        .init()
#endif
    }

    /// The "SnapShotV5" asset catalog image.
    static var snapShotV5: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .snapShotV5)
#else
        .init()
#endif
    }

    /// The "Stetoskop" asset catalog image.
    static var stetoskop: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .stetoskop)
#else
        .init()
#endif
    }

    /// The "ThemePreview_blue" asset catalog image.
    static var themePreviewBlue: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .themePreviewBlue)
#else
        .init()
#endif
    }

    /// The "ThemePreview_green" asset catalog image.
    static var themePreviewGreen: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .themePreviewGreen)
#else
        .init()
#endif
    }

    /// The "ThemePreview_orange" asset catalog image.
    static var themePreviewOrange: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .themePreviewOrange)
#else
        .init()
#endif
    }

    /// The "ThemePreview_pink" asset catalog image.
    static var themePreviewPink: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .themePreviewPink)
#else
        .init()
#endif
    }

    /// The "background" asset catalog image.
    static var background: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .background)
#else
        .init()
#endif
    }

    /// The "background2" asset catalog image.
    static var background2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .background2)
#else
        .init()
#endif
    }

    /// The "background3" asset catalog image.
    static var background3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .background3)
#else
        .init()
#endif
    }

    /// The "chart_bar_feeling_1" asset catalog image.
    static var chartBarFeeling1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .chartBarFeeling1)
#else
        .init()
#endif
    }

    /// The "chart_bar_feeling_2" asset catalog image.
    static var chartBarFeeling2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .chartBarFeeling2)
#else
        .init()
#endif
    }

    /// The "chart_bar_feeling_3" asset catalog image.
    static var chartBarFeeling3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .chartBarFeeling3)
#else
        .init()
#endif
    }

    /// The "chart_bar_feeling_4" asset catalog image.
    static var chartBarFeeling4: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .chartBarFeeling4)
#else
        .init()
#endif
    }

    /// The "chart_bar_feeling_5" asset catalog image.
    static var chartBarFeeling5: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .chartBarFeeling5)
#else
        .init()
#endif
    }

    /// The "chart_feeling_1" asset catalog image.
    static var chartFeeling1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .chartFeeling1)
#else
        .init()
#endif
    }

    /// The "chart_feeling_2" asset catalog image.
    static var chartFeeling2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .chartFeeling2)
#else
        .init()
#endif
    }

    /// The "chart_feeling_3" asset catalog image.
    static var chartFeeling3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .chartFeeling3)
#else
        .init()
#endif
    }

    /// The "chart_feeling_4" asset catalog image.
    static var chartFeeling4: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .chartFeeling4)
#else
        .init()
#endif
    }

    /// The "chart_feeling_5" asset catalog image.
    static var chartFeeling5: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .chartFeeling5)
#else
        .init()
#endif
    }

    /// The "d113" asset catalog image.
    static var d113: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d113)
#else
        .init()
#endif
    }

    /// The "d116" asset catalog image.
    static var d116: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d116)
#else
        .init()
#endif
    }

    /// The "d119" asset catalog image.
    static var d119: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d119)
#else
        .init()
#endif
    }

    /// The "d122" asset catalog image.
    static var d122: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d122)
#else
        .init()
#endif
    }

    /// The "d143" asset catalog image.
    static var d143: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d143)
#else
        .init()
#endif
    }

    /// The "d176" asset catalog image.
    static var d176: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d176)
#else
        .init()
#endif
    }

    /// The "d179" asset catalog image.
    static var d179: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d179)
#else
        .init()
#endif
    }

    /// The "d182" asset catalog image.
    static var d182: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d182)
#else
        .init()
#endif
    }

    /// The "d185" asset catalog image.
    static var d185: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d185)
#else
        .init()
#endif
    }

    /// The "d200" asset catalog image.
    static var d200: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d200)
#else
        .init()
#endif
    }

    /// The "d227" asset catalog image.
    static var d227: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d227)
#else
        .init()
#endif
    }

    /// The "d230" asset catalog image.
    static var d230: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d230)
#else
        .init()
#endif
    }

    /// The "d248" asset catalog image.
    static var d248: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d248)
#else
        .init()
#endif
    }

    /// The "d260" asset catalog image.
    static var d260: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d260)
#else
        .init()
#endif
    }

    /// The "d263" asset catalog image.
    static var d263: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d263)
#else
        .init()
#endif
    }

    /// The "d266" asset catalog image.
    static var d266: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d266)
#else
        .init()
#endif
    }

    /// The "d281" asset catalog image.
    static var d281: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d281)
#else
        .init()
#endif
    }

    /// The "d284" asset catalog image.
    static var d284: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d284)
#else
        .init()
#endif
    }

    /// The "d293" asset catalog image.
    static var d293: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d293)
#else
        .init()
#endif
    }

    /// The "d296" asset catalog image.
    static var d296: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d296)
#else
        .init()
#endif
    }

    /// The "d299" asset catalog image.
    static var d299: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d299)
#else
        .init()
#endif
    }

    /// The "d302" asset catalog image.
    static var d302: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d302)
#else
        .init()
#endif
    }

    /// The "d305" asset catalog image.
    static var d305: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d305)
#else
        .init()
#endif
    }

    /// The "d308" asset catalog image.
    static var d308: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d308)
#else
        .init()
#endif
    }

    /// The "d311" asset catalog image.
    static var d311: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d311)
#else
        .init()
#endif
    }

    /// The "d314" asset catalog image.
    static var d314: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d314)
#else
        .init()
#endif
    }

    /// The "d317" asset catalog image.
    static var d317: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d317)
#else
        .init()
#endif
    }

    /// The "d320" asset catalog image.
    static var d320: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d320)
#else
        .init()
#endif
    }

    /// The "d323" asset catalog image.
    static var d323: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d323)
#else
        .init()
#endif
    }

    /// The "d326" asset catalog image.
    static var d326: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d326)
#else
        .init()
#endif
    }

    /// The "d329" asset catalog image.
    static var d329: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d329)
#else
        .init()
#endif
    }

    /// The "d332" asset catalog image.
    static var d332: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d332)
#else
        .init()
#endif
    }

    /// The "d335" asset catalog image.
    static var d335: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d335)
#else
        .init()
#endif
    }

    /// The "d338" asset catalog image.
    static var d338: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d338)
#else
        .init()
#endif
    }

    /// The "d350" asset catalog image.
    static var d350: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d350)
#else
        .init()
#endif
    }

    /// The "d353" asset catalog image.
    static var d353: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d353)
#else
        .init()
#endif
    }

    /// The "d356" asset catalog image.
    static var d356: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d356)
#else
        .init()
#endif
    }

    /// The "d359" asset catalog image.
    static var d359: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d359)
#else
        .init()
#endif
    }

    /// The "d362" asset catalog image.
    static var d362: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d362)
#else
        .init()
#endif
    }

    /// The "d365" asset catalog image.
    static var d365: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d365)
#else
        .init()
#endif
    }

    /// The "d368" asset catalog image.
    static var d368: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d368)
#else
        .init()
#endif
    }

    /// The "d371" asset catalog image.
    static var d371: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d371)
#else
        .init()
#endif
    }

    /// The "d374" asset catalog image.
    static var d374: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d374)
#else
        .init()
#endif
    }

    /// The "d377" asset catalog image.
    static var d377: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d377)
#else
        .init()
#endif
    }

    /// The "d386" asset catalog image.
    static var d386: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d386)
#else
        .init()
#endif
    }

    /// The "d389" asset catalog image.
    static var d389: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d389)
#else
        .init()
#endif
    }

    /// The "d392" asset catalog image.
    static var d392: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d392)
#else
        .init()
#endif
    }

    /// The "d395" asset catalog image.
    static var d395: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .d395)
#else
        .init()
#endif
    }

    /// The "n113" asset catalog image.
    static var n113: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n113)
#else
        .init()
#endif
    }

    /// The "n116" asset catalog image.
    static var n116: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n116)
#else
        .init()
#endif
    }

    /// The "n119" asset catalog image.
    static var n119: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n119)
#else
        .init()
#endif
    }

    /// The "n122" asset catalog image.
    static var n122: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n122)
#else
        .init()
#endif
    }

    /// The "n143" asset catalog image.
    static var n143: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n143)
#else
        .init()
#endif
    }

    /// The "n176" asset catalog image.
    static var n176: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n176)
#else
        .init()
#endif
    }

    /// The "n179" asset catalog image.
    static var n179: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n179)
#else
        .init()
#endif
    }

    /// The "n182" asset catalog image.
    static var n182: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n182)
#else
        .init()
#endif
    }

    /// The "n185" asset catalog image.
    static var n185: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n185)
#else
        .init()
#endif
    }

    /// The "n200" asset catalog image.
    static var n200: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n200)
#else
        .init()
#endif
    }

    /// The "n227" asset catalog image.
    static var n227: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n227)
#else
        .init()
#endif
    }

    /// The "n230" asset catalog image.
    static var n230: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n230)
#else
        .init()
#endif
    }

    /// The "n248" asset catalog image.
    static var n248: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n248)
#else
        .init()
#endif
    }

    /// The "n260" asset catalog image.
    static var n260: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n260)
#else
        .init()
#endif
    }

    /// The "n263" asset catalog image.
    static var n263: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n263)
#else
        .init()
#endif
    }

    /// The "n266" asset catalog image.
    static var n266: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n266)
#else
        .init()
#endif
    }

    /// The "n281" asset catalog image.
    static var n281: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n281)
#else
        .init()
#endif
    }

    /// The "n284" asset catalog image.
    static var n284: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n284)
#else
        .init()
#endif
    }

    /// The "n293" asset catalog image.
    static var n293: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n293)
#else
        .init()
#endif
    }

    /// The "n296" asset catalog image.
    static var n296: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n296)
#else
        .init()
#endif
    }

    /// The "n299" asset catalog image.
    static var n299: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n299)
#else
        .init()
#endif
    }

    /// The "n302" asset catalog image.
    static var n302: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n302)
#else
        .init()
#endif
    }

    /// The "n305" asset catalog image.
    static var n305: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n305)
#else
        .init()
#endif
    }

    /// The "n308" asset catalog image.
    static var n308: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n308)
#else
        .init()
#endif
    }

    /// The "n311" asset catalog image.
    static var n311: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n311)
#else
        .init()
#endif
    }

    /// The "n314" asset catalog image.
    static var n314: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n314)
#else
        .init()
#endif
    }

    /// The "n317" asset catalog image.
    static var n317: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n317)
#else
        .init()
#endif
    }

    /// The "n320" asset catalog image.
    static var n320: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n320)
#else
        .init()
#endif
    }

    /// The "n323" asset catalog image.
    static var n323: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n323)
#else
        .init()
#endif
    }

    /// The "n326" asset catalog image.
    static var n326: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n326)
#else
        .init()
#endif
    }

    /// The "n329" asset catalog image.
    static var n329: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n329)
#else
        .init()
#endif
    }

    /// The "n332" asset catalog image.
    static var n332: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n332)
#else
        .init()
#endif
    }

    /// The "n335" asset catalog image.
    static var n335: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n335)
#else
        .init()
#endif
    }

    /// The "n338" asset catalog image.
    static var n338: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n338)
#else
        .init()
#endif
    }

    /// The "n350" asset catalog image.
    static var n350: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n350)
#else
        .init()
#endif
    }

    /// The "n353" asset catalog image.
    static var n353: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n353)
#else
        .init()
#endif
    }

    /// The "n356" asset catalog image.
    static var n356: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n356)
#else
        .init()
#endif
    }

    /// The "n359" asset catalog image.
    static var n359: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n359)
#else
        .init()
#endif
    }

    /// The "n362" asset catalog image.
    static var n362: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n362)
#else
        .init()
#endif
    }

    /// The "n365" asset catalog image.
    static var n365: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n365)
#else
        .init()
#endif
    }

    /// The "n368" asset catalog image.
    static var n368: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n368)
#else
        .init()
#endif
    }

    /// The "n371" asset catalog image.
    static var n371: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n371)
#else
        .init()
#endif
    }

    /// The "n374" asset catalog image.
    static var n374: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n374)
#else
        .init()
#endif
    }

    /// The "n377" asset catalog image.
    static var n377: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n377)
#else
        .init()
#endif
    }

    /// The "n386" asset catalog image.
    static var n386: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n386)
#else
        .init()
#endif
    }

    /// The "n389" asset catalog image.
    static var n389: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n389)
#else
        .init()
#endif
    }

    /// The "n392" asset catalog image.
    static var n392: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n392)
#else
        .init()
#endif
    }

    /// The "n395" asset catalog image.
    static var n395: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .n395)
#else
        .init()
#endif
    }

    /// The "prostheticAbove" asset catalog image.
    static var prostheticAbove: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .prostheticAbove)
#else
        .init()
#endif
    }

    /// The "prostheticBelow" asset catalog image.
    static var prostheticBelow: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .prostheticBelow)
#else
        .init()
#endif
    }

    /// The "distance" asset catalog image.
    static var distance: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .distance)
#else
        .init()
#endif
    }

    /// The "feeling_1" asset catalog image.
    static var feeling1: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .feeling1)
#else
        .init()
#endif
    }

    /// The "feeling_2" asset catalog image.
    static var feeling2: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .feeling2)
#else
        .init()
#endif
    }

    /// The "feeling_3" asset catalog image.
    static var feeling3: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .feeling3)
#else
        .init()
#endif
    }

    /// The "feeling_4" asset catalog image.
    static var feeling4: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .feeling4)
#else
        .init()
#endif
    }

    /// The "feeling_5" asset catalog image.
    static var feeling5: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .feeling5)
#else
        .init()
#endif
    }

    /// The "figure.prothese" asset catalog image.
    static var figureProthese: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .figureProthese)
#else
        .init()
#endif
    }

    /// The "figure.prothese.motion" asset catalog image.
    static var figureProtheseMotion: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .figureProtheseMotion)
#else
        .init()
#endif
    }

    /// The "figure.prothese.stairs" asset catalog image.
    static var figureProtheseStairs: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .figureProtheseStairs)
#else
        .init()
#endif
    }

    /// The "figure.steps" asset catalog image.
    static var figureSteps: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .figureSteps)
#else
        .init()
#endif
    }

    /// The "instagram" asset catalog image.
    static var instagram: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .instagram)
#else
        .init()
#endif
    }

    /// The "pain" asset catalog image.
    static var pain: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .pain)
#else
        .init()
#endif
    }

    /// The "prothese.above" asset catalog image.
    static var protheseAbove: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .protheseAbove)
#else
        .init()
#endif
    }

    /// The "prothese.below" asset catalog image.
    static var protheseBelow: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .protheseBelow)
#else
        .init()
#endif
    }

    /// The "prothese.liner" asset catalog image.
    static var protheseLiner: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .protheseLiner)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// The "AppLogoTransparent" asset catalog image.
    static var appLogoTransparent: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .appLogoTransparent)
#else
        .init()
#endif
    }

    /// The "Develper" asset catalog image.
    static var develper: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .develper)
#else
        .init()
#endif
    }

    /// The "Doctor" asset catalog image.
    static var doctor: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .doctor)
#else
        .init()
#endif
    }

    /// The "GetProProthese" asset catalog image.
    static var getProProthese: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .getProProthese)
#else
        .init()
#endif
    }

    /// The "GetProProthesePNG" asset catalog image.
    static var getProProthesePNG: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .getProProthesePNG)
#else
        .init()
#endif
    }

    /// The "Hospital" asset catalog image.
    static var hospital: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .hospital)
#else
        .init()
#endif
    }

    /// The "Illustration" asset catalog image.
    static var illustration: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .illustration)
#else
        .init()
#endif
    }

    /// The "LaunchImage_blueV1" asset catalog image.
    static var launchImageBlueV1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .launchImageBlueV1)
#else
        .init()
#endif
    }

    /// The "LaunchImage_blueV2" asset catalog image.
    static var launchImageBlueV2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .launchImageBlueV2)
#else
        .init()
#endif
    }

    /// The "LaunchImage_blueV3" asset catalog image.
    static var launchImageBlueV3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .launchImageBlueV3)
#else
        .init()
#endif
    }

    /// The "LaunchImage_greenV1" asset catalog image.
    static var launchImageGreenV1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .launchImageGreenV1)
#else
        .init()
#endif
    }

    /// The "LaunchImage_greenV2" asset catalog image.
    static var launchImageGreenV2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .launchImageGreenV2)
#else
        .init()
#endif
    }

    /// The "LaunchImage_greenV3" asset catalog image.
    static var launchImageGreenV3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .launchImageGreenV3)
#else
        .init()
#endif
    }

    /// The "LaunchImage_orangeV1" asset catalog image.
    static var launchImageOrangeV1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .launchImageOrangeV1)
#else
        .init()
#endif
    }

    /// The "LaunchImage_orangeV2" asset catalog image.
    static var launchImageOrangeV2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .launchImageOrangeV2)
#else
        .init()
#endif
    }

    /// The "LaunchImage_orangeV3" asset catalog image.
    static var launchImageOrangeV3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .launchImageOrangeV3)
#else
        .init()
#endif
    }

    /// The "LaunchImage_pinkV1" asset catalog image.
    static var launchImagePinkV1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .launchImagePinkV1)
#else
        .init()
#endif
    }

    /// The "LaunchImage_pinkV2" asset catalog image.
    static var launchImagePinkV2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .launchImagePinkV2)
#else
        .init()
#endif
    }

    /// The "LaunchImage_pinkV3" asset catalog image.
    static var launchImagePinkV3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .launchImagePinkV3)
#else
        .init()
#endif
    }

    /// The "Physio" asset catalog image.
    static var physio: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .physio)
#else
        .init()
#endif
    }

    /// The "ProWidgetPreview1" asset catalog image.
    static var proWidgetPreview1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .proWidgetPreview1)
#else
        .init()
#endif
    }

    /// The "ProWidgetPreview2" asset catalog image.
    static var proWidgetPreview2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .proWidgetPreview2)
#else
        .init()
#endif
    }

    /// The "ProWidgetPreview3" asset catalog image.
    static var proWidgetPreview3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .proWidgetPreview3)
#else
        .init()
#endif
    }

    /// The "ProWidgetPreview4" asset catalog image.
    static var proWidgetPreview4: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .proWidgetPreview4)
#else
        .init()
#endif
    }

    /// The "SnapShotBGOverlay" asset catalog image.
    static var snapShotBGOverlay: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .snapShotBGOverlay)
#else
        .init()
#endif
    }

    /// The "SnapShotLogo" asset catalog image.
    static var snapShotLogo: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .snapShotLogo)
#else
        .init()
#endif
    }

    /// The "SnapShotV1" asset catalog image.
    static var snapShotV1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .snapShotV1)
#else
        .init()
#endif
    }

    /// The "SnapShotV2" asset catalog image.
    static var snapShotV2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .snapShotV2)
#else
        .init()
#endif
    }

    /// The "SnapShotV3" asset catalog image.
    static var snapShotV3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .snapShotV3)
#else
        .init()
#endif
    }

    /// The "SnapShotV4" asset catalog image.
    static var snapShotV4: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .snapShotV4)
#else
        .init()
#endif
    }

    /// The "SnapShotV5" asset catalog image.
    static var snapShotV5: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .snapShotV5)
#else
        .init()
#endif
    }

    /// The "Stetoskop" asset catalog image.
    static var stetoskop: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .stetoskop)
#else
        .init()
#endif
    }

    /// The "ThemePreview_blue" asset catalog image.
    static var themePreviewBlue: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .themePreviewBlue)
#else
        .init()
#endif
    }

    /// The "ThemePreview_green" asset catalog image.
    static var themePreviewGreen: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .themePreviewGreen)
#else
        .init()
#endif
    }

    /// The "ThemePreview_orange" asset catalog image.
    static var themePreviewOrange: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .themePreviewOrange)
#else
        .init()
#endif
    }

    /// The "ThemePreview_pink" asset catalog image.
    static var themePreviewPink: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .themePreviewPink)
#else
        .init()
#endif
    }

    /// The "background" asset catalog image.
    static var background: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .background)
#else
        .init()
#endif
    }

    /// The "background2" asset catalog image.
    static var background2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .background2)
#else
        .init()
#endif
    }

    /// The "background3" asset catalog image.
    static var background3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .background3)
#else
        .init()
#endif
    }

    /// The "chart_bar_feeling_1" asset catalog image.
    static var chartBarFeeling1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .chartBarFeeling1)
#else
        .init()
#endif
    }

    /// The "chart_bar_feeling_2" asset catalog image.
    static var chartBarFeeling2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .chartBarFeeling2)
#else
        .init()
#endif
    }

    /// The "chart_bar_feeling_3" asset catalog image.
    static var chartBarFeeling3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .chartBarFeeling3)
#else
        .init()
#endif
    }

    /// The "chart_bar_feeling_4" asset catalog image.
    static var chartBarFeeling4: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .chartBarFeeling4)
#else
        .init()
#endif
    }

    /// The "chart_bar_feeling_5" asset catalog image.
    static var chartBarFeeling5: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .chartBarFeeling5)
#else
        .init()
#endif
    }

    /// The "chart_feeling_1" asset catalog image.
    static var chartFeeling1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .chartFeeling1)
#else
        .init()
#endif
    }

    /// The "chart_feeling_2" asset catalog image.
    static var chartFeeling2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .chartFeeling2)
#else
        .init()
#endif
    }

    /// The "chart_feeling_3" asset catalog image.
    static var chartFeeling3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .chartFeeling3)
#else
        .init()
#endif
    }

    /// The "chart_feeling_4" asset catalog image.
    static var chartFeeling4: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .chartFeeling4)
#else
        .init()
#endif
    }

    /// The "chart_feeling_5" asset catalog image.
    static var chartFeeling5: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .chartFeeling5)
#else
        .init()
#endif
    }

    /// The "d113" asset catalog image.
    static var d113: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d113)
#else
        .init()
#endif
    }

    /// The "d116" asset catalog image.
    static var d116: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d116)
#else
        .init()
#endif
    }

    /// The "d119" asset catalog image.
    static var d119: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d119)
#else
        .init()
#endif
    }

    /// The "d122" asset catalog image.
    static var d122: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d122)
#else
        .init()
#endif
    }

    /// The "d143" asset catalog image.
    static var d143: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d143)
#else
        .init()
#endif
    }

    /// The "d176" asset catalog image.
    static var d176: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d176)
#else
        .init()
#endif
    }

    /// The "d179" asset catalog image.
    static var d179: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d179)
#else
        .init()
#endif
    }

    /// The "d182" asset catalog image.
    static var d182: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d182)
#else
        .init()
#endif
    }

    /// The "d185" asset catalog image.
    static var d185: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d185)
#else
        .init()
#endif
    }

    /// The "d200" asset catalog image.
    static var d200: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d200)
#else
        .init()
#endif
    }

    /// The "d227" asset catalog image.
    static var d227: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d227)
#else
        .init()
#endif
    }

    /// The "d230" asset catalog image.
    static var d230: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d230)
#else
        .init()
#endif
    }

    /// The "d248" asset catalog image.
    static var d248: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d248)
#else
        .init()
#endif
    }

    /// The "d260" asset catalog image.
    static var d260: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d260)
#else
        .init()
#endif
    }

    /// The "d263" asset catalog image.
    static var d263: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d263)
#else
        .init()
#endif
    }

    /// The "d266" asset catalog image.
    static var d266: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d266)
#else
        .init()
#endif
    }

    /// The "d281" asset catalog image.
    static var d281: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d281)
#else
        .init()
#endif
    }

    /// The "d284" asset catalog image.
    static var d284: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d284)
#else
        .init()
#endif
    }

    /// The "d293" asset catalog image.
    static var d293: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d293)
#else
        .init()
#endif
    }

    /// The "d296" asset catalog image.
    static var d296: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d296)
#else
        .init()
#endif
    }

    /// The "d299" asset catalog image.
    static var d299: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d299)
#else
        .init()
#endif
    }

    /// The "d302" asset catalog image.
    static var d302: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d302)
#else
        .init()
#endif
    }

    /// The "d305" asset catalog image.
    static var d305: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d305)
#else
        .init()
#endif
    }

    /// The "d308" asset catalog image.
    static var d308: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d308)
#else
        .init()
#endif
    }

    /// The "d311" asset catalog image.
    static var d311: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d311)
#else
        .init()
#endif
    }

    /// The "d314" asset catalog image.
    static var d314: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d314)
#else
        .init()
#endif
    }

    /// The "d317" asset catalog image.
    static var d317: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d317)
#else
        .init()
#endif
    }

    /// The "d320" asset catalog image.
    static var d320: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d320)
#else
        .init()
#endif
    }

    /// The "d323" asset catalog image.
    static var d323: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d323)
#else
        .init()
#endif
    }

    /// The "d326" asset catalog image.
    static var d326: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d326)
#else
        .init()
#endif
    }

    /// The "d329" asset catalog image.
    static var d329: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d329)
#else
        .init()
#endif
    }

    /// The "d332" asset catalog image.
    static var d332: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d332)
#else
        .init()
#endif
    }

    /// The "d335" asset catalog image.
    static var d335: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d335)
#else
        .init()
#endif
    }

    /// The "d338" asset catalog image.
    static var d338: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d338)
#else
        .init()
#endif
    }

    /// The "d350" asset catalog image.
    static var d350: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d350)
#else
        .init()
#endif
    }

    /// The "d353" asset catalog image.
    static var d353: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d353)
#else
        .init()
#endif
    }

    /// The "d356" asset catalog image.
    static var d356: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d356)
#else
        .init()
#endif
    }

    /// The "d359" asset catalog image.
    static var d359: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d359)
#else
        .init()
#endif
    }

    /// The "d362" asset catalog image.
    static var d362: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d362)
#else
        .init()
#endif
    }

    /// The "d365" asset catalog image.
    static var d365: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d365)
#else
        .init()
#endif
    }

    /// The "d368" asset catalog image.
    static var d368: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d368)
#else
        .init()
#endif
    }

    /// The "d371" asset catalog image.
    static var d371: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d371)
#else
        .init()
#endif
    }

    /// The "d374" asset catalog image.
    static var d374: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d374)
#else
        .init()
#endif
    }

    /// The "d377" asset catalog image.
    static var d377: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d377)
#else
        .init()
#endif
    }

    /// The "d386" asset catalog image.
    static var d386: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d386)
#else
        .init()
#endif
    }

    /// The "d389" asset catalog image.
    static var d389: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d389)
#else
        .init()
#endif
    }

    /// The "d392" asset catalog image.
    static var d392: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d392)
#else
        .init()
#endif
    }

    /// The "d395" asset catalog image.
    static var d395: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .d395)
#else
        .init()
#endif
    }

    /// The "n113" asset catalog image.
    static var n113: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n113)
#else
        .init()
#endif
    }

    /// The "n116" asset catalog image.
    static var n116: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n116)
#else
        .init()
#endif
    }

    /// The "n119" asset catalog image.
    static var n119: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n119)
#else
        .init()
#endif
    }

    /// The "n122" asset catalog image.
    static var n122: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n122)
#else
        .init()
#endif
    }

    /// The "n143" asset catalog image.
    static var n143: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n143)
#else
        .init()
#endif
    }

    /// The "n176" asset catalog image.
    static var n176: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n176)
#else
        .init()
#endif
    }

    /// The "n179" asset catalog image.
    static var n179: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n179)
#else
        .init()
#endif
    }

    /// The "n182" asset catalog image.
    static var n182: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n182)
#else
        .init()
#endif
    }

    /// The "n185" asset catalog image.
    static var n185: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n185)
#else
        .init()
#endif
    }

    /// The "n200" asset catalog image.
    static var n200: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n200)
#else
        .init()
#endif
    }

    /// The "n227" asset catalog image.
    static var n227: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n227)
#else
        .init()
#endif
    }

    /// The "n230" asset catalog image.
    static var n230: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n230)
#else
        .init()
#endif
    }

    /// The "n248" asset catalog image.
    static var n248: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n248)
#else
        .init()
#endif
    }

    /// The "n260" asset catalog image.
    static var n260: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n260)
#else
        .init()
#endif
    }

    /// The "n263" asset catalog image.
    static var n263: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n263)
#else
        .init()
#endif
    }

    /// The "n266" asset catalog image.
    static var n266: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n266)
#else
        .init()
#endif
    }

    /// The "n281" asset catalog image.
    static var n281: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n281)
#else
        .init()
#endif
    }

    /// The "n284" asset catalog image.
    static var n284: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n284)
#else
        .init()
#endif
    }

    /// The "n293" asset catalog image.
    static var n293: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n293)
#else
        .init()
#endif
    }

    /// The "n296" asset catalog image.
    static var n296: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n296)
#else
        .init()
#endif
    }

    /// The "n299" asset catalog image.
    static var n299: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n299)
#else
        .init()
#endif
    }

    /// The "n302" asset catalog image.
    static var n302: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n302)
#else
        .init()
#endif
    }

    /// The "n305" asset catalog image.
    static var n305: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n305)
#else
        .init()
#endif
    }

    /// The "n308" asset catalog image.
    static var n308: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n308)
#else
        .init()
#endif
    }

    /// The "n311" asset catalog image.
    static var n311: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n311)
#else
        .init()
#endif
    }

    /// The "n314" asset catalog image.
    static var n314: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n314)
#else
        .init()
#endif
    }

    /// The "n317" asset catalog image.
    static var n317: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n317)
#else
        .init()
#endif
    }

    /// The "n320" asset catalog image.
    static var n320: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n320)
#else
        .init()
#endif
    }

    /// The "n323" asset catalog image.
    static var n323: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n323)
#else
        .init()
#endif
    }

    /// The "n326" asset catalog image.
    static var n326: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n326)
#else
        .init()
#endif
    }

    /// The "n329" asset catalog image.
    static var n329: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n329)
#else
        .init()
#endif
    }

    /// The "n332" asset catalog image.
    static var n332: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n332)
#else
        .init()
#endif
    }

    /// The "n335" asset catalog image.
    static var n335: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n335)
#else
        .init()
#endif
    }

    /// The "n338" asset catalog image.
    static var n338: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n338)
#else
        .init()
#endif
    }

    /// The "n350" asset catalog image.
    static var n350: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n350)
#else
        .init()
#endif
    }

    /// The "n353" asset catalog image.
    static var n353: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n353)
#else
        .init()
#endif
    }

    /// The "n356" asset catalog image.
    static var n356: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n356)
#else
        .init()
#endif
    }

    /// The "n359" asset catalog image.
    static var n359: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n359)
#else
        .init()
#endif
    }

    /// The "n362" asset catalog image.
    static var n362: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n362)
#else
        .init()
#endif
    }

    /// The "n365" asset catalog image.
    static var n365: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n365)
#else
        .init()
#endif
    }

    /// The "n368" asset catalog image.
    static var n368: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n368)
#else
        .init()
#endif
    }

    /// The "n371" asset catalog image.
    static var n371: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n371)
#else
        .init()
#endif
    }

    /// The "n374" asset catalog image.
    static var n374: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n374)
#else
        .init()
#endif
    }

    /// The "n377" asset catalog image.
    static var n377: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n377)
#else
        .init()
#endif
    }

    /// The "n386" asset catalog image.
    static var n386: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n386)
#else
        .init()
#endif
    }

    /// The "n389" asset catalog image.
    static var n389: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n389)
#else
        .init()
#endif
    }

    /// The "n392" asset catalog image.
    static var n392: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n392)
#else
        .init()
#endif
    }

    /// The "n395" asset catalog image.
    static var n395: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .n395)
#else
        .init()
#endif
    }

    /// The "prostheticAbove" asset catalog image.
    static var prostheticAbove: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .prostheticAbove)
#else
        .init()
#endif
    }

    /// The "prostheticBelow" asset catalog image.
    static var prostheticBelow: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .prostheticBelow)
#else
        .init()
#endif
    }

    /// The "distance" asset catalog image.
    static var distance: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .distance)
#else
        .init()
#endif
    }

    /// The "feeling_1" asset catalog image.
    static var feeling1: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .feeling1)
#else
        .init()
#endif
    }

    /// The "feeling_2" asset catalog image.
    static var feeling2: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .feeling2)
#else
        .init()
#endif
    }

    /// The "feeling_3" asset catalog image.
    static var feeling3: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .feeling3)
#else
        .init()
#endif
    }

    /// The "feeling_4" asset catalog image.
    static var feeling4: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .feeling4)
#else
        .init()
#endif
    }

    /// The "feeling_5" asset catalog image.
    static var feeling5: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .feeling5)
#else
        .init()
#endif
    }

    /// The "figure.prothese" asset catalog image.
    static var figureProthese: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .figureProthese)
#else
        .init()
#endif
    }

    /// The "figure.prothese.motion" asset catalog image.
    static var figureProtheseMotion: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .figureProtheseMotion)
#else
        .init()
#endif
    }

    /// The "figure.prothese.stairs" asset catalog image.
    static var figureProtheseStairs: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .figureProtheseStairs)
#else
        .init()
#endif
    }

    /// The "figure.steps" asset catalog image.
    static var figureSteps: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .figureSteps)
#else
        .init()
#endif
    }

    /// The "instagram" asset catalog image.
    static var instagram: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .instagram)
#else
        .init()
#endif
    }

    /// The "pain" asset catalog image.
    static var pain: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .pain)
#else
        .init()
#endif
    }

    /// The "prothese.above" asset catalog image.
    static var protheseAbove: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .protheseAbove)
#else
        .init()
#endif
    }

    /// The "prothese.below" asset catalog image.
    static var protheseBelow: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .protheseBelow)
#else
        .init()
#endif
    }

    /// The "prothese.liner" asset catalog image.
    static var protheseLiner: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .protheseLiner)
#else
        .init()
#endif
    }

}
#endif

// MARK: - Thinnable Asset Support -

@available(iOS 11.0, macOS 10.13, tvOS 11.0, *)
@available(watchOS, unavailable)
extension ColorResource {

    private init?(thinnableName: String, bundle: Bundle) {
#if canImport(AppKit) && os(macOS)
        if AppKit.NSColor(named: NSColor.Name(thinnableName), bundle: bundle) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIColor(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    private convenience init?(thinnableResource: ColorResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    private init?(thinnableResource: ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    private init?(thinnableResource: ColorResource?) {
        if let resource = thinnableResource {
            self.init(resource)
        } else {
            return nil
        }
    }

}
#endif

@available(iOS 11.0, macOS 10.7, tvOS 11.0, *)
@available(watchOS, unavailable)
extension ImageResource {

    private init?(thinnableName: String, bundle: Bundle) {
#if canImport(AppKit) && os(macOS)
        if bundle.image(forResource: NSImage.Name(thinnableName)) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#elseif canImport(UIKit) && !os(watchOS)
        if UIKit.UIImage(named: thinnableName, in: bundle, compatibleWith: nil) != nil {
            self.init(name: thinnableName, bundle: bundle)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}

#if canImport(AppKit)
@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    private convenience init?(thinnableResource: ImageResource?) {
#if !targetEnvironment(macCatalyst)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    private convenience init?(thinnableResource: ImageResource?) {
#if !os(watchOS)
        if let resource = thinnableResource {
            self.init(resource: resource)
        } else {
            return nil
        }
#else
        return nil
#endif
    }

}
#endif

// MARK: - Backwards Deployment Support -

/// A color resource.
struct ColorResource: Hashable {

    /// An asset catalog color resource name.
    fileprivate let name: String

    /// An asset catalog color resource bundle.
    fileprivate let bundle: Bundle

    /// Initialize a `ColorResource` with `name` and `bundle`.
    init(name: String, bundle: Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

/// An image resource.
struct ImageResource: Hashable {

    /// An asset catalog image resource name.
    fileprivate let name: String

    /// An asset catalog image resource bundle.
    fileprivate let bundle: Bundle

    /// Initialize an `ImageResource` with `name` and `bundle`.
    init(name: String, bundle: Bundle) {
        self.name = name
        self.bundle = bundle
    }

}

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    /// Initialize a `NSColor` with a color resource.
    convenience init(resource: ColorResource) {
        self.init(named: NSColor.Name(resource.name), bundle: resource.bundle)!
    }

}

protocol _ACResourceInitProtocol {}
extension AppKit.NSImage: _ACResourceInitProtocol {}

@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension _ACResourceInitProtocol {

    /// Initialize a `NSImage` with an image resource.
    init(resource: ImageResource) {
        self = resource.bundle.image(forResource: NSImage.Name(resource.name))! as! Self
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// Initialize a `UIColor` with a color resource.
    convenience init(resource: ColorResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}

@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIImage {

    /// Initialize a `UIImage` with an image resource.
    convenience init(resource: ImageResource) {
#if !os(watchOS)
        self.init(named: resource.name, in: resource.bundle, compatibleWith: nil)!
#else
        self.init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    /// Initialize a `Color` with a color resource.
    init(_ resource: ColorResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Image {

    /// Initialize an `Image` with an image resource.
    init(_ resource: ImageResource) {
        self.init(resource.name, bundle: resource.bundle)
    }

}
#endif