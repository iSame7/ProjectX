//
//  ConfigType.swift
//  Core
//
//  Created by Sameh Mabrouk on 20/07/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

public protocol CoreConfigurable {
    static var baseURL: String { get }
}

/// Use this method to inject the configuration for this framework.
public func setup(with config: CoreConfigurable.Type) {
    ConfigType.shared = ConfigType(config)
}

var Config: ConfigType { // swiftlint:disable:this variable_name
    if let config = ConfigType.shared {
        return config
    } else {
        fatalError("Please set the Config for \(Bundle(for: ConfigType.self))")
    }
}

final class ConfigType {
    
    static fileprivate var shared: ConfigType?
    
    let baseURL: String
    
    fileprivate init(_ config: CoreConfigurable.Type) {
        self.baseURL = config.baseURL
    }
}
