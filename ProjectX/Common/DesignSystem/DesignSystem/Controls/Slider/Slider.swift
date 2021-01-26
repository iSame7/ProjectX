//
//  Slider.swift
//  DesignSystem
//
//  Created by Sameh Mabrouk on 10/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit

public class Slider: UISlider {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        configure()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension Slider {
    func configure() {
        minimumTrackTintColor = DesignSystem.Colors.Palette.primary500.color
        maximumTrackTintColor = DesignSystem.Colors.Palette.gray400.color
    }
}
