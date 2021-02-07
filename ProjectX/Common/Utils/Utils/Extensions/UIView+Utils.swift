//
//  UIView+Utils.swift
//  Utils
//
//  Created by Sameh Mabrouk on 07/02/2021.
//

import UIKit

public extension UIView {
    
    func addGradient(colors: [CGColor]){
        let gradient = CAGradientLayer()
        gradient.frame.size = frame.size
        gradient.colors = colors
        layer.addSublayer(gradient)
    }
}
