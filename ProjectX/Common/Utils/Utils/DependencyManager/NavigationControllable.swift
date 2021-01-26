//
//  NavigationControllable.swift
//  Utils
//
//  Created by Sameh Mabrouk on 16/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit

public protocol NavigationControllable: class {
    func pushViewController(_ viewController: UIViewController, animated: Bool)
    func popViewController(animated: Bool) -> UIViewController?
    func popToRootViewController(animated: Bool) -> [UIViewController]? 
    func setViewControllers(_ viewControllers: [UIViewController], animated: Bool)
}

extension UINavigationController: NavigationControllable {}
