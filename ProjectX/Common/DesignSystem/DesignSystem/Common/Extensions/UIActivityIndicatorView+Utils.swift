//
//  UIActivityIndicatorView+Utils.swift
//  Components
//
//  Created by Sameh Mabrouk on 3/23/20.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {
    public var size: CGSize {
        get {
            return frame.size
        }
        set {
            frame.size = newValue
            setNeedsDisplay()
        }
    }
}
