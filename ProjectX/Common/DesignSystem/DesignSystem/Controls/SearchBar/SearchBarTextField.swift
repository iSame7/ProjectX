//
//  SHSearchBarTextField.swift
//  Components
//
//  Created by Sameh Mabrouk on 12/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit

/**
 * UITextField subclass to be able to overwrite the *rect functions.
 * This makes it possible to exactly control all margins.
 */
public class SearchBarTextField: UITextField {
    
    init() {
        super.init(frame: .zero)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    // MARK: - Overrides
    override public func textRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.textRect(forBounds: bounds)
        return rectForBounds(rect, originalBounds: bounds)
    }
    
    override public func editingRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.editingRect(forBounds: bounds)
        return rectForBounds(rect, originalBounds: bounds)
    }
    
    /**
     * Calculates the text bounds depending on the visibility of left and right views.
     * - parameter bounds: The bounds of the textField after subtracting margins for left and/or right views.
     * - parameter originalBounds: The current bounds of the textField.
     * - returns: The bounds inside the textField so that the text does not overlap with the left and right views.
     */
    private func rectForBounds(_ bounds: CGRect, originalBounds: CGRect) -> CGRect {
        let minX: CGFloat = bounds.minX + 8
        let width: CGFloat = bounds.width
        return CGRect(x: minX, y: 0.0, width: width - 8, height: bounds.height)
    }
}
