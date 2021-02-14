//
//  NotificationView.swift
//  DesignSystem
//
//  Created by Sameh Mabrouk on 14/04/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit

public protocol InAppNotifiable {
    func hide(_ shouldDismiss: Bool)
    func showNotification(_ completion: ((_ isAction: Bool) -> Void)?)
}

public class NotificationView: UIView, InAppNotifiable {
    
    private let imageView: UIImageView = {
        let view = UIImageView()
        view.tintColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let actionButton: Button = {
        let button = ButtonFactory<Button>()
            .font(of: Font(type: .footNote(.medium)))
            .titleColor(with: DesignSystem.Colors.Palette.gray700.color, for: .normal)
            .backgroundColor(with: DesignSystem.Colors.Palette.brandBlack.color)
            .build()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var titleLabel = {
        LabelFactory<Label>(style: .footNoteMedium)
            .textAlignment(.left)
            .numberOf(lines: 1)
            .textColor(with: DesignSystem.Colors.Palette.brandWhite.color)
            .build()
    }()
    
    private lazy var messageLabel = {
        LabelFactory<Label>(style: .footNoteRegular)
            .textAlignment(.left)
            .textColor(with: DesignSystem.Colors.Palette.gray600.color)
            .numberOf(lines: 3)
            .build()
    }()
    
    private var completion: ((_ isAction: Bool) -> Void)? = nil
    
    private(set) var viewData: InAppNotificationViewData
    
    private var notificationTimer: Timer? {
        willSet {
            notificationTimer?.invalidate()
        }
    }
    
    private let firstKeyWindow = UIApplication.shared.windows.first { $0.isKeyWindow }
    var estimatedHeight: CGFloat = 100
    var topConstraint: NSLayoutConstraint! = nil
    
    // MARK: - Init
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented.")
    }
    
    init(viewData: InAppNotificationViewData) {
        self.viewData = viewData
        super.init(frame: .zero)
        
        setupLayer()
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        imageView.contentMode = .scaleAspectFit
        
        setup(withViewData: viewData)
        setupSubviews()
        setupConstraints()
        setupTargets()
    }
    
    private func setupLayer() {
        layer.cornerRadius = 8
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.25
        layer.shadowColor = UIColor.lightGray.cgColor
    }
    
    private func setup(withViewData viewData: InAppNotificationViewData) {
        imageView.image = viewData.image
        backgroundColor = viewData.backgroundColor
        
        if viewData.type == .action {
            if let actionTitle = viewData.actionTitle {
                actionButton.setTitle(actionTitle, for: .normal)
                actionButton.setTitleColor(DesignSystem.Colors.Palette.gray700.color, for: .normal)
            } else {
                let image = IconFactory<UIImage>(icon: .close).build().withRenderingMode(.alwaysTemplate)
                actionButton.setImage(image, for: .normal)
                actionButton.tintColor = UIColor.white
            }
        }
        
        titleLabel.text = viewData.title
        if let titleStyle = viewData.titleStyle {
            titleLabel.setStyle(style: titleStyle.labelStyle)
            titleLabel.textColor = titleStyle.color
        }
        
        guard let message = viewData.message else {
            return
        }
        messageLabel.text = message
        
        guard let messageStyle = viewData.messageStyle else {
            return
        }
        messageLabel.setStyle(style: messageStyle.labelStyle)
        messageLabel.textColor = messageStyle.color
    }
    
    private func setupSubviews() {
        if viewData.type != .normal {
            addSubview(actionButton)
        }
        if viewData.image != nil {
            addSubview(imageView)
        }
        addSubview(titleLabel)
        addSubview(messageLabel)
    }
    
    private func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            messageLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            messageLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor),
            messageLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
        
        if viewData.image != nil {
            NSLayoutConstraint.activate([
                imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
                imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 14),
                imageView.heightAnchor.constraint(equalToConstant: 58),
                imageView.widthAnchor.constraint(equalToConstant: 44),
                
                titleLabel.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 14),
            ])
        } else {
            NSLayoutConstraint.activate([
                titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 14),
            ])
        }
        
        if viewData.type != .normal {
            NSLayoutConstraint.activate([
                actionButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
                actionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                
                titleLabel.rightAnchor.constraint(equalTo: actionButton.leftAnchor, constant: -12)
            ])
        } else {
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        }
        
        titleLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
        
        messageLabel.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        messageLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
    
    private func setupTargets() {
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissNotification))
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.dismissNotification))
        swipeRecognizer.direction = .up
        
        addGestureRecognizer(tapRecognizer)
        addGestureRecognizer(swipeRecognizer)
        
        actionButton.addTarget(self, action: #selector(onTapAction(_:)), for: .touchUpInside)
    }
    
    // MARK: - Helpers
    private func setDismissTimer() {
        let delay = viewData.delay
        if delay > 0 {
            notificationTimer = Timer.scheduledTimer(timeInterval: Double(delay), target: self, selector: #selector(dismissNotification), userInfo: nil, repeats: false)
        }
    }
    
    @IBAction func onTapAction(_ sender: UIButton) {
        hide(true)
    }
    
    @objc internal func dismissNotification() {
        hide()
    }
    
    // MARK: - Public
    
    public func hide(_ shouldDismiss: Bool = false) {
        guard let window = firstKeyWindow  else { return }
        
        UIView.animate(withDuration: 0.1, animations: {
            if let topConstraint = self.topConstraint {
                topConstraint.constant = 5
            }
        }, completion: { _ in
            self.topConstraint.constant = -self.frame.height
            UIView.animate(withDuration: 0.25, animations: {
                window.layoutIfNeeded()
            }, completion: { _ in
                self.notificationTimer = nil
                self.completion?(shouldDismiss)
                self.removeFromSuperview()
            })
        })
    }
    
    public func update(withViewData viewData: InAppNotificationViewData) {
        self.viewData = viewData
        subviews.forEach {
            $0.removeFromSuperview()
        }
        setupUI()
    }
    
    public func showNotification(_ completion: ((_ isAction: Bool) -> Void)? = nil) {
        guard let window = firstKeyWindow  else {
            return
        }
        
        window.addSubview(self)
        NSLayoutConstraint.activate([
            self.leftAnchor.constraint(equalTo: window.leftAnchor, constant: 8),
            self.rightAnchor.constraint(equalTo: window.rightAnchor, constant: -8)
        ])
        topConstraint = topAnchor.constraint(equalTo: window.safeAreaLayoutGuide.topAnchor, constant: -estimatedHeight)
        topConstraint.isActive = true
        window.layoutIfNeeded()
        
        topConstraint.constant = 10
        UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.68, initialSpringVelocity: 0.1, options: UIView.AnimationOptions(), animations: {
            window.layoutIfNeeded()
        })
        
        self.completion = completion
        setDismissTimer()
    }
}
