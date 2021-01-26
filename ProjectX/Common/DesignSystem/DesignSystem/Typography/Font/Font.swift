//
//  Font.swift
//  DesignSystem
//
//  Created by Sameh Mabrouk on 25/01/2021.
//

import UIKit
import CoreText

/** The base class for fonts .
 
 - Usage Eg:
    - Font with body style with standard body size.
    ````
    titleLabel?.font = Font(type: .body(.bold)).instance
    ````
    - Font with custom size
    ````
     titleLabel?.font = Font(type: .custom(.medium, .custom(20.0))).instance
    ````
 */

public class Font {
    public enum FontName: String, CaseIterable {
        case black              = "GTAmerica-Black"
        case bold               = "GTAmerica-Bold"
        case light              = "GTAmerica-Light"
        case medium             = "GTAmerica-Medium"
        case regular            = "GTAmerica-Regular"
        case thin               = "GTAmerica-Thin"
        case ultraLight         = "GTAmerica-UltraLight"
    }
    
    public enum StandardSize: Double {
        case title1 = 28.0
        case title2 = 24.0
        case title3 = 20.0
        case subtitle = 17.0
        case body = 15.0
        case footnote = 13.0
        case caption1 = 11.0
        case caption2 = 8.0
    }
    
    public enum FontSize {
        case standard(StandardSize)
        case custom(Double)
        var value: Double {
            switch self {
            case .standard(let size):
                return size.rawValue
            case .custom(let customSize):
                return customSize
            }
        }
    }
    
    public enum FontType {
        case title1
        case title2
        case title3(FontName)
        case subtitle(FontName)
        case body(FontName)
        case footNote(FontName)
        case caption1(FontName)
        case caption2
        case custom(FontName, FontSize)
    }
    
    var type: FontType
    
    public init(type: FontType) {
        self.type = type
    }
    
}

extension Font {
    
    public var instance: (UIFont) {
        var fontInstance: UIFont!

        switch type {
        case .title1:
            guard let font = UIFont(name: FontName.bold.rawValue, size: CGFloat(FontSize.standard(.title1).value)) else {
                return UIFont.systemFont(ofSize: CGFloat(FontSize.standard(.title1).value), weight: .bold)
            }
            fontInstance = font
        case .title2:
            guard let font = UIFont(name: FontName.bold.rawValue, size: CGFloat(FontSize.standard(.title2).value)) else {
                return UIFont.systemFont(ofSize: CGFloat(FontSize.standard(.title2).value), weight: .bold)
            }
            fontInstance = font
        case .title3:
            guard let font = UIFont(name: FontName.bold.rawValue, size: CGFloat(FontSize.standard(.title3).value)) else {
                return UIFont.systemFont(ofSize: CGFloat(FontSize.standard(.title3).value), weight: .bold)
            }
            fontInstance = font
        case let .subtitle(fontName):
            guard let font = UIFont(name: fontName.rawValue, size: CGFloat(FontSize.standard(.subtitle).value)) else {
                return UIFont.systemFont(ofSize: CGFloat(FontSize.standard(.subtitle).value), weight: .bold)
            }
            fontInstance = font
        case let .body(fontName):
            guard let font = UIFont(name: fontName.rawValue, size: CGFloat(FontSize.standard(.body).value)) else {
                return UIFont.systemFont(ofSize: CGFloat(FontSize.standard(.body).value), weight: .regular)
            }
            fontInstance = font
        case let .footNote(fontName):
            guard let font = UIFont(name: fontName.rawValue, size: CGFloat(FontSize.standard(.footnote).value)) else {
                return UIFont.systemFont(ofSize: CGFloat(FontSize.standard(.footnote).value), weight: .regular)
            }
            fontInstance = font
        case let .caption1(fontName):
            guard let font = UIFont(name: fontName.rawValue, size: CGFloat(FontSize.standard(.caption1).value)) else {
                return UIFont.systemFont(ofSize: CGFloat(FontSize.standard(.caption1).value), weight: .regular)
            }
            fontInstance = font
        case .caption2:
            guard let font = UIFont(name: FontName.medium.rawValue, size: CGFloat(FontSize.standard(.caption2).value)) else {
                return UIFont.systemFont(ofSize: CGFloat(FontSize.standard(.caption2).value), weight: .regular)
            }
            fontInstance = font
        case let  .custom(fontName,fontSize):
            guard let font = UIFont(name: fontName.rawValue, size: CGFloat(fontSize.value)) else {
                return UIFont.systemFont(ofSize: CGFloat(fontSize.value), weight: .regular)
            }
            fontInstance = font
        }
        return fontInstance
    }
}

// MARK: - LineHeight

public enum LineHeight: CGFloat {
    case title1 = 34.0
    case title2 = 30.0
    case title3 = 26.0
    case subtitle = 24.0
    case body = 22.0
    case footnote = 18.0
    case caption1 = 14.0
    case caption2 = 10.0
}

// MARK: - BaseLineOffset

public enum BaseLineOffset: CGFloat {
    case title1 = 0.13
    case title2 = 0.0399999
    case title3 = 0.4999999
    case subtitle = 0.7575
    case body = 0.9625
    case footnote = 0.6675
    case caption1 = 0.3725
    case caption2 = 0
}
