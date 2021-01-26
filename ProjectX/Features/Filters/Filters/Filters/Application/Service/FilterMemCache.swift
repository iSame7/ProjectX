//
//  FilterCache.swift
//  Core
//
//  Created by Yordi de Kleijn on 23/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import Foundation
import Utils
import Core

public protocol FilterCaching {
    var jobSections: [JobSectionDetail]? { get set }
    var preferences: FilterPreferenceResource? { get set }
    func nukePreferences()
}

public class FilterMemCache: FilterCaching {
    public static let shared: FilterMemCache = FilterMemCache()
    
    public var jobSections: [JobSectionDetail]? {
        didSet {
            print("[FilterCache] set JobSections")
        }
    }
    
    public var preferences: FilterPreferenceResource? {
        didSet {
            print("[FilterCache] set preferences")
        }
    }
    
    public init() {}
    
    public func nukePreferences() {
        print("[FilterCache] nuke preferences")
        preferences = nil
    }
}
