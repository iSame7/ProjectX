//
//  ExtendedNavigationBar.swift
//  ShiftOverview
//
//  Created by Sameh Mabrouk on 13/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import Foundation
import UIKit

public class ExtendedDateScrollerHitAreaNavigationBar: UINavigationBar {
    
    override public func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var extendedRect = self.frame
        extendedRect.size.height += 70
        extendedRect.size.width = UIScreen.main.bounds.size.width
        extendedRect.origin.y = 0
        extendedRect.origin.x = 0
        
        var pointInside = false
        
        if extendedRect.contains(point) {
            pointInside = true
        }
        
        return pointInside
    }
}
