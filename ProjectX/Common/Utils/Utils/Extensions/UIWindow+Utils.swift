//
//  UIWindow+Utils.swift
//  Utils
//
//  Created by Sameh Mabrouk on 27/01/2021.
//

import UIKit

public extension UIWindow {
    func setRootViewController(viewController: UIViewController) {
        rootViewController = viewController
        makeKeyAndVisible()
    }
}
