//
//  PresentationDetentTransformable.swift
//  SwiftfulRouting
//
//  Created by Nick Sarno on 4/19/25.
//
import Foundation
import SwiftUI

/// A hashable representation of SwiftUI presentation detents.
public enum PresentationDetentTransformable: Hashable {
    /// A sheet detent at the medium system-defined height.
    case medium
    /// A sheet detent at the large system-defined height.
    case large
    /// A sheet detent with a fixed height, in points.
    case height(CGFloat)
    /// A sheet detent at a fraction of the available height, from `0.0` to `1.0`.
    case fraction(CGFloat)
    /// A fallback for a detent that cannot be represented by the supported cases.
    case unknown
    
    init(detent: PresentationDetent) {
        // FIXME: Unable to convert .height(CGFloat) and .fraction(CGFloat) back from PresentationDetent to PresentationDetentTransformable
        switch detent {
        case .medium:
            self = .medium
        case .large:
            self = .large
        default:
            self = .unknown
        }
    }
    
    var asPresentationDetent: PresentationDetent {
        switch self {
        case .medium:
            return .medium
        case .large:
            return .large
        case .height(let height):
            return .height(height)
        case .fraction(let fraction):
            return .fraction(fraction)
        case .unknown:
            return .large
        }
    }
    
    public var title: String {
        switch self {
        case .medium:
            return "Medium"
        case .large:
            return "Large"
        case .height(let height):
            return "Height: \(height) px"
        case .fraction(let fraction):
            return "Fraction: \((fraction * 100))%"
        case .unknown:
            return "unknown"
        }
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
    }
}
