//
//  AnalyticsLogging.swift
//  AnalyticsEngine
//
//  Created by Sameh Mabrouk on 26/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

public protocol AnalyticsLogging {
    func log(loggable: AnalyticsLoggable, userId: String?)
    func logUserID(_ userId: String)
}
