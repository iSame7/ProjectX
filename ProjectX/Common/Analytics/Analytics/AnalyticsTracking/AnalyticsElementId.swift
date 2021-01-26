//
//  AnalyticsElementId.swift
//  AnalyticsEngine
//
//  Created by Sameh Mabrouk on 15/04/2020.
//  Copyright © 2020 Temper. All rights reserved.
//


public protocol AnalyticsElementId {
    var rawValue: String { get }
    var requiredForMarketing: Bool { get }
}

// MARK: - Viewable

enum AnalyticsViewableScreen: String, AnalyticsElementId {
    case about
    case home
    
    var requiredForMarketing: Bool {
        switch self {
        case .home:
            return true
        case .about:
            return false
        }
    }
}
