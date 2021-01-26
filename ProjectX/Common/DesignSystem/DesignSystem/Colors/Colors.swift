//
//  Colors.swift
//  Components
//
//  Created by Sameh Mabrouk on 15/07/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit

extension DesignSystem {
    
    public final class Colors {
        
        /// colors defined in asset catalog
        public enum Palette: String {
            case ferrari500 = "Ferrari500"
            case brandBlack = "BrandBlack"
            case brandWhite = "BrandWhite"
            case bubbleGum500 = "BubbleGum500"
            case gold500 = "Gold500"
            case orange500 = "Orange500"
            case gray100 = "Gray100"
            case gray200 = "Gray200"
            case gray300 = "Gray300"
            case gray400 = "Gray400"
            case gray500 = "Gray500"
            case gray600 = "Gray600"
            case gray700 = "Gray700"
            case gray800 = "Gray800"
            case gray900 = "Gray900"
            case primary100 = "Primary100"
            case primary200 = "Primary200"
            case primary300 = "Primary300"
            case primary400 = "Primary400"
            case primary500 = "Primary500"
            case primary600 = "Primary600"
            case primary700 = "Primary700"
            case primary800 = "Primary800"
            case primary900 = "Primary900"
            case secondary100 = "Secondary100"
            case secondary200 = "Secondary200"
            case secondary300 = "Secondary300"
            case secondary400 = "Secondary400"
            case secondary500 = "Secondary500"
            case secondary600 = "Secondary600"
            case secondary700 = "Secondary700"
            case secondary800 = "Secondary800"
            case secondary900 = "Secondary900"
            
            public var color: UIColor {
                guard let designSystemColor = UIColor(named: self.rawValue, in: Bundle(identifier: "com.smapps.DesignSystem"), compatibleWith: nil) else {
                    preconditionFailure("invalid design system color")
                }
                
                return designSystemColor
            }
        }
    }
}

/// Make palette enum CaseIterable for unit testing purposes
extension DesignSystem.Colors.Palette: CaseIterable {}
