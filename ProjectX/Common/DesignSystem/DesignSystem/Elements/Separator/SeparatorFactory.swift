//
//  SeparatorFactory.swift
//  Components
//
//  Created by Sameh Mabrouk on 13/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit

public class SeparatorFactory<T>: Factory {
    public typealias ComponentType = T
    
    private let separator: Separator
    
    public init() {
        separator = Separator(frame: .zero)
        separator.backgroundColor = DesignSystem.Colors.Palette.gray200.color
        separator.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public func setColor(_ color: UIColor) -> Self {
        separator.backgroundColor = color
        return self
    }
    
    public func build() -> T {
        return separator as! T
    }
    
    public lazy var playbookPresentationSize: CGRect = {
        return CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 48, height: 0.5)
    }()
}
