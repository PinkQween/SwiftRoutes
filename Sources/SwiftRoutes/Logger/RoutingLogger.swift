//
//  RoutingLogger.swift
//  SwiftfulRouting
//
//  Created by Nick Sarno on 4/19/25.
//
import Foundation
import SwiftUI

@MainActor var logger: (any RoutingLogger) = MockRoutingLogger(logLevel: .warning, printParameters: false)

/// Receives routing events and screen-view events from SwiftRoutes.
@MainActor
public protocol RoutingLogger {
    func trackEvent(event: RoutingLogEvent)
    func trackScreenView(event: RoutingLogEvent)
}

/// Configures the logger used by SwiftRoutes.
public enum SwiftRoutesLogger {
    
    // RoutingLogger.enableLogging(logger: logger)
    @MainActor static public func enableLogging(logger newValue: RoutingLogger) {
        logger = newValue
    }

    // RoutingLogger.enableLogging(level: .info)
    @MainActor static public func enableLogging(level newValue: RoutingLogType, printParameters: Bool = false) {
        logger = MockRoutingLogger(logLevel: newValue, printParameters: printParameters)
    }
    
}

/// Compatibility name for the logger configuration namespace.
@available(*, deprecated, renamed: "SwiftRoutesLogger")
public typealias SwiftfulRoutingLogger = SwiftRoutesLogger

struct MockRoutingLogger: RoutingLogger {
    
    var logLevel: RoutingLogType
    var printParameters: Bool
    
    func trackEvent(event: any RoutingLogEvent) {
        #if DEBUG
        if event.type.rawValue >= logLevel.rawValue {
            var value = "\(event.type.emoji) \(event.eventName)"
            
            if printParameters, let params = event.parameters, !params.isEmpty {
                let sortedKeys = params.keys.sorted()
                for key in sortedKeys {
                    if let paramValue = params[key] {
                        value += "\n  (key: \"\(key)\", value: \(paramValue))"
                    }
                }
            }

            print(value)
        }
        #endif
    }
    
    func trackScreenView(event: any RoutingLogEvent) {
        trackEvent(event: event)
    }
}

/// Describes a routing event that can be sent to a ``RoutingLogger``.
@MainActor
public protocol RoutingLogEvent {
    var eventName: String { get }
    var parameters: [String: Any]? { get }
    var type: RoutingLogType { get }
}

/// Severity levels used to filter routing log output.
public enum RoutingLogType: Int, CaseIterable, Sendable {
    case info // 0
    case analytic // 1
    case warning // 2
    case severe // 3

    var emoji: String {
        switch self {
        case .info:
            return "👋"
        case .analytic:
            return "📈"
        case .warning:
            return "⚠️"
        case .severe:
            return "🚨"
        }
    }

    var asString: String {
        switch self {
        case .info: return "info"
        case .analytic: return "analytic"
        case .warning: return "warning"
        case .severe: return "severe"
        }
    }
}
