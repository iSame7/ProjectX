//
//  MapFactory.swift
//  DesignSystem
//
//  Created by Sameh Mabrouk on 27/01/2021.
//

import UIKit

/// Creates a Map component
public class MapFactory<T>: Factory {
    
    public typealias ComponentType = T
    
    private let map: Map
    
    public init() {
        map = Map()
    }
    
    public func cornerRadius(_ radius: CGFloat) -> Self {
        map.cornerRadius(radius)
        return self
    }
    
    public func address(_ text: String) -> Self {
        map.address(text)
        return self
    }
    
    public func delegate(_ delegate: MapDelegate) -> Self {
        map.delegate = delegate
        return self
    }
    
    public func build() -> Map {
        return map
    }
    
    public lazy var playbookPresentationSize = {
        return CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 48, height: 200)
    }()
    
    public func build() -> T {
        return map as! T
    }
}
