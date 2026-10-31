//
//  AlertLocation.swift
//  SwiftfulRouting
//
//  Created by Nick Sarno on 4/19/25.
//
import Foundation
import SwiftUI

/// Selects which router in the active screen hierarchy presents an alert.
public enum AlertLocation: String {
    case currentScreen, topScreen
}
