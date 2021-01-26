//
//  UIImage+Utils.swift
//  Utils
//
//  Created by Sameh Mabrouk on 26/01/2021.
//

import UIKit

public extension UIImage {
    func imageWithInsets(insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
    
    class func imageWithColor(color: UIColor, size: CGSize = CGSize(width: 1, height: 0.5)) -> UIImage {
       let rect = CGRect(origin: .zero, size: size)
       UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
       color.setFill()
       UIRectFill(rect)
       guard let image = UIGraphicsGetImageFromCurrentImageContext() else {
           return UIImage()
       }
       UIGraphicsEndImageContext()
       return image
   }
}
