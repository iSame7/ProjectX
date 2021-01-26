//
//  SliderFactory.swift
//  DesignSystem
//
//  Created by Sameh Mabrouk on 10/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit

public class SliderFactory<T>: Factory {
    public lazy var playbookPresentationSize = {
        return CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 48, height: 48)
    }()
    
    public typealias ComponentType = T
    
    private let slider: Slider
    
    public init() {
        slider = Slider()
        slider.translatesAutoresizingMaskIntoConstraints = false
    }
    
    public func build() -> T {
        return slider as! T
    }
}
