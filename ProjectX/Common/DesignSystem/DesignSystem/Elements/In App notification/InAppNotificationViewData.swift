//
//  InAppNotificationTextAttribute.swift
//  DesignSystem
//
//  Created by Abubakar Oladeji on 04/05/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit

public struct InAppNotificationViewData {
    
    public struct InAppNotificationTextStyle {
        public var labelStyle: Label.Style
        public var color: UIColor
        
        public init(style: Label.Style, color: UIColor) {
            self.labelStyle = style
            self.color = color
        }
    }
    
    public var type: InAppNotificationType
    public var title: String
    public var titleStyle: InAppNotificationTextStyle? = nil
    public var message: String?
    public var messageStyle: InAppNotificationTextStyle? = nil
    public var actionTitle: String?
    public var backgroundColor: UIColor
    public var image: UIImage?
    public var delay: TimeInterval
}
