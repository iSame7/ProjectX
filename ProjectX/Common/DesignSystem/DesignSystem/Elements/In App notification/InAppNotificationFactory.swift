//
//  InAppNotifications.swift
//  DesignSystem
//
//  Created by Sameh Mabrouk on 14/04/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit

open class InAppNotificationFactory<T>: Factory {
    
    public typealias ComponentType = T
    
    private let notificationView: NotificationView
    
    public var playbookPresentationSize: CGRect = {
        CGRect.zero
    }()
    
    public init(type: InAppNotificationType, title: String, subtitle: String? = nil, actionTitle: String? = nil, image: UIImage? = nil, delay: TimeInterval = 5.0) {
            let data = InAppNotificationViewData(type: type, title: title, message: subtitle, actionTitle: actionTitle, backgroundColor: DesignSystem.Colors.Palette.brandBlack.color, image: image, delay: delay)
            notificationView = NotificationView(viewData: data)
    }
    
    public init(with viewData: InAppNotificationViewData) {
        notificationView = NotificationView(viewData: viewData)
    }
    
    public func build() -> T {
        return notificationView as! T
    }
}
