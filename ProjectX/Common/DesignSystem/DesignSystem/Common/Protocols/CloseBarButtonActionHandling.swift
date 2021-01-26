//
//  CloseBarButtonActionHandling.swift
//  Core
//
//  Created by Sameh Mabrouk on 06/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//
import UIKit

@objc public protocol CloseBarButtonActionHandling: class {
    func closeButtonTapped()
}

public extension CloseBarButtonActionHandling where Self: UIViewController {
    func addCloseBarButtonItem(imageColor: UIColor = DesignSystem.Colors.Palette.secondary600.color) {
        navigationItem.leftBarButtonItem = closeBarButtonItem(imageColor: imageColor)
    }
    
    func removeCloseBarButtonItem() {
        navigationItem.leftBarButtonItem = nil
    }
    
    private func closeBarButtonItem(imageColor: UIColor) -> UIBarButtonItem {
        let button = UIButton.init(type: .custom)
        var image: UIImage = IconFactory(icon: .close).build()
        switch imageColor {
        case DesignSystem.Colors.Palette.brandWhite.color:
            image = IconFactory(icon: .whiteClose).build()
        case DesignSystem.Colors.Palette.secondary600.color:
            image = IconFactory(icon: .close).build()
        default:
            break
        }
      
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        button.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        
        return UIBarButtonItem(customView: button)
    }
}
