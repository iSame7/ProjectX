//
//  Presentable.swift
//  Utils
//
//  Created by Sameh Mabrouk on 16/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit

public protocol Presentable: class {
    func presentInFullScreen(_ viewController: UIViewController, animated: Bool, completion: (() -> Void)?)
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
    func dismiss(animated flag: Bool, completion: (() -> Void)?)
}

extension UIViewController: Presentable {
    public func presentInFullScreen(_ viewController: UIViewController,
                             animated: Bool,
                             completion: (() -> Void)? = nil) {
        viewController.modalPresentationStyle = .fullScreen
        present(viewController, animated: animated, completion: completion)
    }
}
