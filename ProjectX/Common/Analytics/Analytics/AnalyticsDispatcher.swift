//
//  AnalyticsDispatcher.swift
//  AnalyticsEngine
//
//  Created by Sameh Mabrouk on 26/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//
import Utils

public protocol AnalyticsDispatchable {
    func log(event: AnalyticsLoggable, userId: String?)
    func logUserID(_ userId: String)
}

public class AnalyticsDispatcher: AnalyticsDispatchable {
    
    public static let shared = AnalyticsDispatcher(loggers: [
        FirebaseAnalyticsLogger(),
        OptimizelyAnalyticsLogger()
    ])
    
    private let loggers: [AnalyticsLogging]
    
    public init(loggers: [AnalyticsLogging]) {        
        self.loggers = loggers
    }
    
    public func log(event: AnalyticsLoggable, userId: String? = nil) {
        print("[ANALYTICS] Logging event: \(event)")

        loggers.forEach {
            $0.log(loggable: event, userId: userId)
        }
    }
    
    public func logUserID(_ userId: String) {
        print("[ANALYTICS] Logging userID: \(userId)")
        
        loggers.forEach {
            $0.logUserID(userId)
        }
    }
}
