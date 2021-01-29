//
//  ConfigType.swift
//  FoursquareCore
//
//  Created by Sameh Mabrouk on 28/01/2021.
//

public protocol FoursquareCoreConfigurable {
    static var baseURL: String { get }
    static var clientId: String { get }
    static var clientSecret: String { get }
    static var categoreyId: String { get }
}

/// Use this method to inject the configuration for this framework.
public func setup(with config: FoursquareCoreConfigurable.Type) {
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
        
    let baseURL: String
    let clientId: String
    let clientSecret: String
    let categoryId: String
    
    static fileprivate var shared: ConfigType? 
    
    fileprivate init(_ config: FoursquareCoreConfigurable.Type) {
        self.baseURL = config.baseURL
        self.clientId = config.clientId
        self.clientSecret = config.clientSecret
        self.categoryId = config.categoreyId
    }
}
