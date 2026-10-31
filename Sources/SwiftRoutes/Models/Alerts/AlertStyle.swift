//
//  AlertStyle.swift
//  SwiftfulRouting
//
//  Created by Nick Sarno on 4/19/25.
//
import Foundation
import SwiftUI

/// The native SwiftUI presentation style used for an alert.
public enum AlertStyle: String, CaseIterable, Hashable {
    case alert, confirmationDialog
    
    public var codeString: String {
        ".\(rawValue)"
    }
}
