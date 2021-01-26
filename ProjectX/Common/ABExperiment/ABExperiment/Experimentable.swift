//
//  Experimentable.swift
//  OptimizelyWrapper
//
//  Created by Sameh Mabrouk on 25/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

public protocol Experimentable {
    var name: ExperimentName { get }
    
    var defaultValue: Any { get }
    var remoteValue: Any? { get set }
}

private extension Experimentable {
    var value: Any? {
        return remoteValue ?? defaultValue
    }
}

public extension Experimentable {
    var stringValue: String? {
      return value as? String
    }
}
