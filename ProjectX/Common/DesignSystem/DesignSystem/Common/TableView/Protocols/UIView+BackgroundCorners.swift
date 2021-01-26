//
//  UIView+BackgroundCorners.swift
//  Filters
//
//  Created by Sameh Mabrouk on 10/02/2020.
//  Copyright © 2020 Sameh Mabrouk. All rights reserved.
//

import UIKit

extension UIView {
    public func setupBackgroundCorner(corner: ItemBackgroundCorner) {
        let shape = CAShapeLayer()
        let cornerRadius: CGFloat
        let corners: UIRectCorner

        switch corner {
        case let .all(radius):
            layer.cornerRadius = radius
            layer.masksToBounds = true
            return
        case let .top(radius):
            corners = [.topLeft, .topRight]
            cornerRadius = radius
        case let .bottom(radius):
            corners = [.bottomLeft, .bottomRight]
            cornerRadius = radius
        case .none:
            corners = []
            layer.cornerRadius = 0
            cornerRadius = 0
        }

        let rect = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.size.height)
        shape.path = UIBezierPath(roundedRect: rect,
                                  byRoundingCorners: corners,
                                  cornerRadii: CGSize(width: cornerRadius, height: cornerRadius)).cgPath
        layer.mask = shape
        layer.masksToBounds = true
    }
}
