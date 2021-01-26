//
//  TemperButtonFactory.swift
//  DesignSystem
//
//  Created by Sameh Mabrouk on 1/9/20.
//

import UIKit

/** Create Button component styling
 
 - parameters:
 Button styles
 * primary
 * secondary
 * custom
 
 Button with primary style
 ````
 ButtonFactory(title: "Primary Button", style: .primary)
 .build()
 ````
 Button with custom style
 ````
 ButtonFactory(title: "Custom Button")
 .backgroundColor(with: .temperComponentPurple)
 .titleColor(with: .white, for: .normal)
 .font(of: TemperComponentFont(type: .body(.bold)))
 .cornerRadius(of: 24.0)
 .dropShadow(of: CGSize(width: 2, height: 2), radius: 2.0, opacity: 1.0)
 .build()
 ````
 */

public class ButtonFactory<T>: Factory {
    
    public typealias ComponentType = T
    
    private let button: Button
    
    public init(title: String = "", style: ButtonStyle = .custom) {
        button = Button(withTitle: title, style: style)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        switch style {
        case .primary:
            primaryButton()
        case let .secondary(alignment):
            secondaryButton(alignment: alignment)
        case .custom:
            break
        }
    }
    
    @discardableResult
    public func backgroundColor(with color: UIColor) -> Self {
        button.backgroundColor = color
        return self
    }

    @discardableResult
    public func cornerRadius(of radius: CGFloat) -> Self {
        button.layer.cornerRadius = radius
        return self
    }
    
    @discardableResult
    public func title(title: String) -> Self {
        button.setTitle(title, for: .normal)
        return self
    }
    
    @discardableResult
    public func titleColor(with color: UIColor, for state: UIControl.State) -> Self {
        button.setTitleColor(color, for: state )
        return self
    }
    
    @discardableResult
    public func font(of font: Font) -> Self {
        button.titleLabel?.font = font.instance
        return self
    }
    
    @discardableResult
    public func titleEdgeInsets(edgeInsets: UIEdgeInsets) -> Self {
        button.titleEdgeInsets = edgeInsets
        return self
    }
    
    @discardableResult
    public func textAlignment(alignment: UIControl.ContentHorizontalAlignment) -> Self {
        button.contentHorizontalAlignment = alignment
        
        return self
    }
    
    @discardableResult
    public func rectangularCorners() -> Self {
        button.layer.cornerRadius = 0
        
        return self
    }
    
    @discardableResult
    public func disable() -> Self {
        button.isUserInteractionEnabled = false
        button.disable()
        return self
    }
    
    @discardableResult
    public func enable() -> Self {
        button.isUserInteractionEnabled = true
        button.enable()
        return self
    }
    
    public lazy var playbookPresentationSize = {
        return CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width - 48, height: 48)
    }()
    
    public func build() -> T {
        return button as! T
    }
}

extension ButtonFactory {
    private func primaryButton() {
        button.titleLabel?.textAlignment = .center
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = Font(type: .body(.medium)).instance
        button.backgroundColor = DesignSystem.Colors.Palette.primary500.color
        button.layer.cornerRadius = 4.0
    }
    
    private func secondaryButton(alignment: UIControl.ContentHorizontalAlignment) {
        button.contentHorizontalAlignment = alignment
        button.setTitleColor(DesignSystem.Colors.Palette.secondary500.color, for: .normal)
        
        var left: CGFloat
        var right: CGFloat
        
        switch alignment {
        case .left:
            left = 0
            right = 40
        case .right:
            left = 40
            right = 0
        case .center:
            left = 40
            right = 40
        case .fill, .leading, .trailing:
            preconditionFailure("Alignment is not supported")
        @unknown default:
            preconditionFailure("Alignment is not supported")
        }
        button.titleLabel?.font = Font(type: .body(.medium)).instance
        button.titleEdgeInsets = UIEdgeInsets(top: 12, left: left, bottom: 12, right: right)
        button.backgroundColor = .clear
    }
}
