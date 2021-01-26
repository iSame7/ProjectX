//
//  TemperLabelFactory.swift
//  TemperComponents
//
//  Created by Sameh Mabrouk on 1/8/20.
//

import SkeletonView
import UIKit

/** Create Label component with styles
 
 - parameters:
 Label styles
 * header
 * subheader
 * body
 * footer
 * custom
 
 Label with set style
 ````
 LabelFactory(text: "Header", style: .header)
 .build()
 ````
 ````
 LabelFactory(text: "Subheader", style: .subheader)
 .textColor(with: .red)
 .build()
 ````
 Label with attributed style
 ````
 LabelFactory(text: "Something for the rest of us")
 .format(substrings: ["rest"], font: Font(type: .body(.medium)), color: .red)
 .format(substrings: ["Something"], font: Font(type: .title4(.bold)), color: .purple)
 .build()
 ````
 */

public class LabelFactory<T>: Factory {
    
    public typealias ComponentType = T
    
    public lazy var playbookPresentationSize: CGRect = {
        return CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 48, height: 48)
    }()
    
    private let label: Label
    
    public init(text: String? = " ", style: Label.Style = .custom) {
        label = Label()
        label.text = text
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.setStyle(style: style)
    }
    
    @discardableResult
    public func style(style: Label.Style) -> Self {
        label.setStyle(style: style)
        return self
    }
    
    @discardableResult
    public func textColor(with color: UIColor) -> Self {
        label.textColor = color
        return self
    }
    
    @discardableResult
    public func numberOf(lines: Int) -> Self {
        label.numberOfLines = lines
        return self
    }
    
    @discardableResult
    public func textAlignment(_ aligment: NSTextAlignment) -> Self {
        label.textAlignment = aligment
        return self
    }
    
    @discardableResult
    public func setLineSpacing(lineSpacing: CGFloat = 0.0,
                               lineHeightMultiple: CGFloat = 0.0,
                               minimumLineHeight: CGFloat = 0.0,
                               baseLineOffset: CGFloat = 0.0) -> Self {
        label.setLineSpacing(lineSpacing: lineSpacing,
                             lineHeightMultiple: lineHeightMultiple,
                             minimumLineHeight: minimumLineHeight,
                             baseLineOffset: baseLineOffset)
        return self
    }
    
    @discardableResult
    public func format(substrings: [String], font: Font, color: UIColor) -> Self {
        
        if let attributedText = label.attributedText {
            let attributedString = NSMutableAttributedString(attributedString: attributedText)
            let attributes = [NSAttributedString.Key.font: font.instance, NSAttributedString.Key.foregroundColor: color]
            for string in substrings {
                attributedString.addAttributes(attributes, range: (attributedText.string as NSString).range(of: string))
            }
            label.attributedText = attributedString
            
            return self
        } else if let labelText = label.text {
            let attributedString = NSMutableAttributedString(string: labelText, attributes: [:])
            let attributes = [NSAttributedString.Key.font: font.instance, NSAttributedString.Key.foregroundColor: color]
            for string in substrings {
                attributedString.addAttributes(attributes, range: (labelText as NSString).range(of: string))
            }
            label.attributedText = attributedString
            
            return self
        }
        
        return self
    }
    
    @discardableResult
    public func addCharactersSpacing(spacing: CGFloat) -> Self {
        label.addCharactersSpacing(spacing: spacing)
        return self
    }
    
    public func addPadding(withNumberNumberOfSpaces spaces: Int) -> Self {
        label.addPadding(withNumberNumberOfSpaces: spaces)
        return self
    }
    
    public func backgroundColor(_ color: UIColor) -> Self {
        label.backgroundColor = color
        return self
    }
    
    public func isSkeletonable(_ isSkeletonable: Bool) -> Self {
        label.isSkeletonable = isSkeletonable
        return self
    }
    
    public func cornerRadius(_ radius: CGFloat) -> Self {
        label.layer.cornerRadius = radius
        label.layer.masksToBounds = true
        return self
    }
    
    public func build() -> T {
        return label as! T
    }
}
