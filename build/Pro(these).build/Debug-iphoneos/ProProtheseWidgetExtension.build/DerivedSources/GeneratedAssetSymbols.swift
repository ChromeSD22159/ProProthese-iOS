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

    /// The "WidgetBackground" asset catalog color resource.
    static let widgetBackground = ColorResource(name: "WidgetBackground", bundle: resourceBundle)

}

// MARK: - Image Symbols -

@available(iOS 11.0, macOS 10.7, tvOS 11.0, *)
extension ImageResource {

    /// The "ProLabel" asset catalog image resource.
    static let proLabel = ImageResource(name: "ProLabel", bundle: resourceBundle)

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

    /// The "figure.steps" asset catalog image resource.
    static let figureSteps = ImageResource(name: "figure.steps", bundle: resourceBundle)

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

    /// The "WidgetBackground" asset catalog color.
    static var widgetBackground: AppKit.NSColor {
#if !targetEnvironment(macCatalyst)
        .init(resource: .widgetBackground)
#else
        .init()
#endif
    }

}
#endif

#if canImport(UIKit)
@available(iOS 11.0, tvOS 11.0, *)
@available(watchOS, unavailable)
extension UIKit.UIColor {

    /// The "WidgetBackground" asset catalog color.
    static var widgetBackground: UIKit.UIColor {
#if !os(watchOS)
        .init(resource: .widgetBackground)
#else
        .init()
#endif
    }

}
#endif

#if canImport(SwiftUI)
@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.Color {

    /// The "WidgetBackground" asset catalog color.
    static var widgetBackground: SwiftUI.Color { .init(.widgetBackground) }

}

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension SwiftUI.ShapeStyle where Self == SwiftUI.Color {

    /// The "WidgetBackground" asset catalog color.
    static var widgetBackground: SwiftUI.Color { .init(.widgetBackground) }

}
#endif

// MARK: - Image Symbol Extensions -

#if canImport(AppKit)
@available(macOS 10.7, *)
@available(macCatalyst, unavailable)
extension AppKit.NSImage {

    /// The "ProLabel" asset catalog image.
    static var proLabel: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .proLabel)
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

    /// The "figure.steps" asset catalog image.
    static var figureSteps: AppKit.NSImage {
#if !targetEnvironment(macCatalyst)
        .init(resource: .figureSteps)
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

    /// The "ProLabel" asset catalog image.
    static var proLabel: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .proLabel)
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

    /// The "figure.steps" asset catalog image.
    static var figureSteps: UIKit.UIImage {
#if !os(watchOS)
        .init(resource: .figureSteps)
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

#if canImport(AppKit)
@available(macOS 10.13, *)
@available(macCatalyst, unavailable)
extension AppKit.NSColor {

    private convenience init?(thinnableResource: ColorResource?) {
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