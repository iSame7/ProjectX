//
//  IconFactory.swift
//  Components
//
//  Created by Jose Camallonga on 29/01/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit

public class IconFactory<T>: Factory {
    public var playbookPresentationSize = CGRect(x: 0, y: 0, width: 50, height: 50)
    public typealias ComponentType = T
    private let icon: Icon
    
    public init(icon: Icon) {
        self.icon = icon
    }
    
    public func build() -> T {
        return UIImage(named: icon.rawValue, in: Bundle(for: IconFactory.self), compatibleWith: nil) as! T
    }
}
