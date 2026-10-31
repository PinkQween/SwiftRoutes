//
//  TransitionMemoryBehavior.swift
//  SwiftfulRouting
//
//  Created by Nick Sarno on 4/19/25.
//
import Foundation
import SwiftUI

/// Determines whether previous transition destinations stay in the view hierarchy.
public enum TransitionMemoryBehavior: String {
    case removePrevious
    case keepPrevious
    
    var allowSimultaneous: Bool {
        switch self {
        case .removePrevious:
            return false
        case .keepPrevious:
            return true
        }
    }
    
}
