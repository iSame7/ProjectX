//
//  Label.swift
//  Components
//
//  Created by Sameh Mabrouk on 14/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit

public class Label: UILabel {
    public enum Style {
        case title1
        case title2
        case title3
        case subtitleBold
        case subtitleMedium
        case subtitleRegular
        
        case bodyBold
        case bodyMedium
        case bodyRegular
        
        case footNoteMedium
        case footNoteRegular
        
        case caption1Medium
        case caption1Regular
        
        case caption2
        
        case custom
    }
    
    override public var text: String? {
        get {
            attributedText?.string
        }
        
        set {
            let mutableAttributedString = NSMutableAttributedString(attributedString: attributedText ?? NSAttributedString(string: " "))
            mutableAttributedString.mutableString.setString(newValue ?? " ")
            attributedText = mutableAttributedString
        }
    }
    
    func addCharactersSpacing(spacing: CGFloat) {
        let attributedString: NSMutableAttributedString
        
        if let labelattributedText = attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: text ?? "")
        }
        
        attributedString.addAttribute(NSAttributedString.Key.kern,
                                      value: spacing,
                                      range: NSRange(location: 0, length: (text ?? "").count))
        attributedText = attributedString
    }
    
    func setStyle(style: Style) {
        switch style {
        case .title1:
            title1Style()
        case .title2:
            title2Style()
        case .title3:
            title3Style()
        case .subtitleRegular:
            subtitleStyleRegular()
        case .subtitleBold:
            subtitleStyleBold()
        case .subtitleMedium:
            subtitleStyleMedium()
        case .bodyBold:
            bodyStyleBold()
        case .bodyMedium:
            bodyStyleMedium()
        case .bodyRegular:
            bodyStyleRegular()
        case .footNoteRegular:
            footnoteRegularStyle()
        case .footNoteMedium:
            footnoteMediumStyle()
        case .caption1Medium:
            caption1MediumStyle()
        case .caption1Regular:
            caption1RegularStyle()
        case .caption2:
            caption2Style()
        case .custom:
            break
        }
    }
}

private extension Label {
    func title1Style() {
        font = Font(type: .title1).instance
        setLineSpacing(minimumLineHeight: LineHeight.title1.rawValue, baseLineOffset: BaseLineOffset.title1.rawValue)
        addCharactersSpacing(spacing: 0.0)
        numberOfLines = 2
    }
    
    func title2Style() {
        font = Font(type: .title2).instance
        setLineSpacing(minimumLineHeight: LineHeight.title2.rawValue, baseLineOffset: BaseLineOffset.title2.rawValue)
        addCharactersSpacing(spacing: 0.0)
        
        numberOfLines = 1
    }
    
    func title3Style() {
        font = Font(type: .title3(.regular)).instance
        setLineSpacing(minimumLineHeight: LineHeight.title3.rawValue, baseLineOffset: BaseLineOffset.title3.rawValue)
        addCharactersSpacing(spacing: 0.0)
        
        numberOfLines = 1
    }
    
    func subtitleStyleBold() {
        font = Font(type: .subtitle(.bold)).instance
        setLineSpacing(minimumLineHeight: LineHeight.subtitle.rawValue, baseLineOffset: BaseLineOffset.subtitle.rawValue)
        addCharactersSpacing(spacing: 0.0)
        
        numberOfLines = 1
    }
    
    func subtitleStyleMedium() {
        font = Font(type: .subtitle(.medium)).instance
        setLineSpacing(minimumLineHeight: LineHeight.subtitle.rawValue, baseLineOffset: BaseLineOffset.subtitle.rawValue)
        addCharactersSpacing(spacing: 0.0)
        
        numberOfLines = 1
    }
    
    func subtitleStyleRegular() {
        font = Font(type: .subtitle(.regular)).instance
        
        setLineSpacing(minimumLineHeight: LineHeight.subtitle.rawValue, baseLineOffset: BaseLineOffset.subtitle.rawValue)
        addCharactersSpacing(spacing: 0.0)
        
        numberOfLines = 1
    }
    
    func bodyStyleBold() {
        font = Font(type: .body(.bold)).instance
        
        setLineSpacing(minimumLineHeight: LineHeight.body.rawValue, baseLineOffset: BaseLineOffset.body.rawValue)
        textAlignment = .left
        
        addCharactersSpacing(spacing: 0.0)
        
        numberOfLines = 3
    }
    
    func bodyStyleMedium() {
        font = Font(type: .body(.medium)).instance
        
        setLineSpacing(minimumLineHeight: LineHeight.body.rawValue, baseLineOffset: BaseLineOffset.body.rawValue)
        addCharactersSpacing(spacing: 0.0)
    }
    
    func bodyStyleRegular() {
        font = Font(type: .body(.regular)).instance
        
        setLineSpacing(minimumLineHeight: LineHeight.body.rawValue, baseLineOffset: BaseLineOffset.body.rawValue)
        addCharactersSpacing(spacing: 0.0)
        
        numberOfLines = 3
    }
    
    func footnoteRegularStyle() {
        font = Font(type: .footNote(.regular)).instance
        setLineSpacing(minimumLineHeight: LineHeight.footnote.rawValue, baseLineOffset: BaseLineOffset.footnote.rawValue)
        addCharactersSpacing(spacing: 0.0)
        
    }
    
    func footnoteMediumStyle() {
        font = Font(type: .footNote(.medium)).instance
        
        setLineSpacing(minimumLineHeight: LineHeight.footnote.rawValue, baseLineOffset: BaseLineOffset.footnote.rawValue)
        addCharactersSpacing(spacing: 0.0)

    }
    
    func caption1MediumStyle() {
        font = Font(type: .caption1(.medium)).instance
        
        setLineSpacing(minimumLineHeight: LineHeight.caption1.rawValue, baseLineOffset: BaseLineOffset.caption1.rawValue)
        addCharactersSpacing(spacing: 0.0)
        
        numberOfLines = 3
    }
    
    func caption1RegularStyle() {
        font = Font(type: .caption1(.regular)).instance
        
        setLineSpacing(minimumLineHeight: LineHeight.caption1.rawValue, baseLineOffset: BaseLineOffset.caption1.rawValue)
        addCharactersSpacing(spacing: 0.0)
        
        numberOfLines = 3
    }
    
    func caption2Style() {
        font = Font(type: .caption2).instance
        
        setLineSpacing(minimumLineHeight: LineHeight.caption2.rawValue, baseLineOffset: BaseLineOffset.caption2.rawValue)
        addCharactersSpacing(spacing: 0.0)
        
        numberOfLines = 3
    }
}
