//
//  UniversalLinkRouted.swift
//  Core
//
//  Created by Sameh Mabrouk on 01/09/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

public class UniversalLinkRouted: CustomDebugStringConvertible {
    
    public let route: UniversalLinkRoute
    public let parameters: [String: String]

    public init(route: UniversalLinkRoute, parameters: [String: String]) {
        self.route = route
        self.parameters = parameters
    }

    public var debugDescription: String {
        if parameters.count > 0 {
            return "\(route): \(parameters)"
        } else {
            return "\(route): (no parameters)"
        }
    }
}
