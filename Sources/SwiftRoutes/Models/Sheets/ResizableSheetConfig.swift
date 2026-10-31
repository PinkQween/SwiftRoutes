//
//  ResizableSheetConfig.swift
//  SwiftfulRouting
//
//  Created by Nick Sarno on 4/19/25.
//
import Foundation
import SwiftUI

/// Configuration for a resizable sheet, including its detents and interactions.
public struct ResizableSheetConfig {
    /// The set of available sheet sizes. Include multiple values to let people resize the sheet.
    public var detents: Set<PresentationDetentTransformable>
    /// Optional binding for reading and changing the selected sheet size.
    public var selection: Binding<PresentationDetentTransformable>?
    /// Visibility of the sheet's drag indicator.
    public var dragIndicator: Visibility
    /// Background treatment for the sheet.
    public var background: EnvironmentBackgroundOption
    /// Optional sheet corner radius.
    public var cornerRadius: CGFloat?
    /// Whether the content behind the sheet can be interacted with.
    public var backgroundInteraction: PresentationBackgroundInteractionBackSupport
    /// Whether scrolling content resizes the sheet or scrolls within it.
    public var contentInteraction: PresentationContentInteractionBackSupport

    /// Resizable sheet settings.
    /// - Parameters:
    ///   - detents: Available sheet sizes. For example, `[.fraction(0.25), .medium, .large]` offers three sizes.
    ///   - selection: Binding to the selected size. If `nil`, the user can still swipe between sizes.
    ///   - dragIndicator: Visibility of the drag indicator.
    ///   - background: Background of sheet. (supported on iOS 16.4 only!)
    ///   - cornerRadius: Corner radius of sheet. (supported on iOS 16.4 only!)
    ///   - backgroundInteraction: Background interaction of sheet (supported on iOS 16.4 only!)
    ///   - contentInteraction: Content interaction of sheet (supported on iOS 16.4 only!)
    public init(
        detents: Set<PresentationDetentTransformable> = [.large],
        selection: Binding<PresentationDetentTransformable>? = nil,
        dragIndicator: Visibility = .automatic,
        background: EnvironmentBackgroundOption = .automatic,
        cornerRadius: CGFloat? = nil,
        backgroundInteraction: PresentationBackgroundInteractionBackSupport = .automatic,
        contentInteraction: PresentationContentInteractionBackSupport = .automatic
    ) {
        self.detents = detents
        self.selection = selection
        self.dragIndicator = dragIndicator
        self.background = background
        self.cornerRadius = cornerRadius
        self.backgroundInteraction = backgroundInteraction
        self.contentInteraction = contentInteraction
    }
}

/// Background interaction options supported across the package's deployment targets.
public enum PresentationBackgroundInteractionBackSupport {
    case automatic, disabled, enabled
    case enabledUpThrough(PresentationDetent)
    
    @available(iOS 16.4, *)
    var backgroundInteraction: PresentationBackgroundInteraction {
        switch self {
        case .automatic:
            return .automatic
        case .disabled:
            return .disabled
        case .enabled:
            return .enabled
        case .enabledUpThrough(let upThrough):
            return .enabled(upThrough: upThrough)
        }
    }
}

/// Content interaction options supported across the package's deployment targets.
public enum PresentationContentInteractionBackSupport {
    case automatic, resizes, scrolls
    
    @available(iOS 16.4, *)
    var contentInteraction: PresentationContentInteraction {
        switch self {
        case .automatic:
            return .automatic
        case .resizes:
            return .resizes
        case .scrolls:
            return .scrolls
        }
    }
}
