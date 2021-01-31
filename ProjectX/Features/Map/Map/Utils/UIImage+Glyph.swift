//
//  UIImage+Glyph.swift
//  Map
//
//  Created by Sameh Mabrouk on 31/01/2021.
//

import UIKit
import DesignSystem

enum ImageType: String {
    case restaurant = "4bf58dd8d48988d1c4941735"
    case bakery = "4bf58dd8d48988d16a941735"
    case halal = "52e81612bcbc57f1066b79ff"
    case cafe = "4bf58dd8d48988d16d941735"
    case coffeeShop = "4bf58dd8d48988d1e0931735"
    case asian = "4bf58dd8d48988d145941735"
    case fish = "4edd64a0c7ddd24ca188df1a"
    case doughnut = "4bf58dd8d48988d148941735"
    case food = "4d4b7105d754a06374d81259"
}

extension UIImage {
    
    static func glyphFor(imageType: ImageType) -> UIImage? {
        switch imageType {
        case .restaurant:
            return IconFactory(icon: .restaurant).build()
        case .bakery:
            return IconFactory(icon: .bakery).build()
        case .halal:
            return IconFactory(icon: .halal).build()
        case .cafe, .coffeeShop:
            return IconFactory(icon: .cafe).build()
        case .asian:
            return IconFactory(icon: .asian).build()
        case .fish:
            return IconFactory(icon: .fish).build()
        case .doughnut:
            return IconFactory(icon: .doughnut).build()
        default:
            return IconFactory(icon: .restaurant).build()
        }
    }
}

