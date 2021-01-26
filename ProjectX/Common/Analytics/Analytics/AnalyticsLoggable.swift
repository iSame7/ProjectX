//
//  AnalyticsLoggable.swift
//  AnalyticsEngine
//
//  Created by Sameh Mabrouk on 26/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

public typealias AnalyticsParameters = [String: Any]

public protocol AnalyticsLoggable: CustomDebugStringConvertible {
    var name: String { get }
    var longEventName: String { get }
    var fullEventName: String { get }
    
    var parameters: AnalyticsParameters { get }
    
    var requiredForMarketing: Bool { get }
}

// MARK: - CustomDebugStringConvertible

extension AnalyticsLoggable {
    var debugDescription: String {
        return "\(fullEventName): \(parameters)"
    }
}
