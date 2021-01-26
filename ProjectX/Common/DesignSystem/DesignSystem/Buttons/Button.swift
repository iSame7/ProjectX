//
//  BaseButton.swift
//  DesignSystem
//
//  Created by Sameh Mabrouk on 1/9/20.
//

import UIKit

public enum ButtonStyle: Equatable {
    case primary
    case secondary(contentHorizontalAlignment: UIControl.ContentHorizontalAlignment)
    case custom
}

public class Button: UIButton {
    
    private var buttonStyle: ButtonStyle
    
    open override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.layer.opacity = (self?.isHighlighted ?? false) ? 0.50 : 1.0
            }
        }
    }
    
    public var isLoading: Bool = false {
        didSet {
            let extent = min(0.8 * frame.height, loadingIndicator.size.height)
            loadingIndicator.size = CGSize(width: extent, height: extent)
            
            isUserInteractionEnabled = !isLoading
            
            if !isLoading {
                loadingIndicator.stopAnimating()
                loadingIndicator.removeFromSuperview()
            }
            
            let animationOption: UIView.AnimationOptions = isHidden ? .curveEaseOut : .curveEaseIn
            UIView.transition(with: self, duration: 0.2, options: animationOption, animations: {
                self.subviews.forEach {
                    $0.alpha = self.isLoading ? 0.0 : 1.0
                }
            }) { [weak self] _ in
                guard let self = self else { return }
                if self.isLoading {
                    self.addSubview(self.loadingIndicator)
                    self.setupConstraints()
                    self.setNeedsLayout()
                    self.loadingIndicator.startAnimating()
                    
                    if case .secondary(_) = self.buttonStyle {
                        self.loadingIndicator.color = DesignSystem.Colors.Palette.secondary400.color
                    }
                }
            }
        }
    }
    
    public lazy var loadingIndicator: UIActivityIndicatorView = {
        return UIActivityIndicatorView()
    }()
    
    public init(withTitle title: String = "", style: ButtonStyle = .custom) {
        self.buttonStyle = style
        super.init(frame: .zero)
        
        setupView()
        setTitle(title, for: .normal)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        titleLabel?.textAlignment = .center
        setTitleColor(DesignSystem.Colors.Palette.brandBlack.color, for: .normal)
        backgroundColor = DesignSystem.Colors.Palette.primary500.color
        layer.cornerRadius = 4.0
    }
    
    public func disable() {
        isUserInteractionEnabled = false
        switch buttonStyle {
        case .primary:
            backgroundColor = DesignSystem.Colors.Palette.primary100.color
            setTitleColor(DesignSystem.Colors.Palette.brandBlack.color.withAlphaComponent(0.3), for: .normal)
        default:
            layer.opacity = 0.3
        }
    }
    
    public func enable() {
        isUserInteractionEnabled = true
        switch buttonStyle {
        case .primary:
            backgroundColor = DesignSystem.Colors.Palette.primary500.color
            setTitleColor(DesignSystem.Colors.Palette.brandBlack.color, for: .normal)
        default:
            layer.opacity = 1.0
        }
    }
}

extension Button {
    
    private func setupConstraints() {
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor)
        ])
    }
}
