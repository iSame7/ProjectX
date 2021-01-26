//
//  UIViewController+Utils.swift
//  Components
//
//  Created by Sameh Mabrouk on 21/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit
import Utils

public extension UIViewController {
    
    func addBackButton(with image: UIImage = IconFactory(icon: .arrowLeft).build()) {
        let edgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        let backIndicatorImage = image.imageWithInsets(insets: edgeInsets)
        navigationController?.navigationBar.backIndicatorImage = backIndicatorImage
        navigationController?.navigationBar.backIndicatorTransitionMaskImage = backIndicatorImage
        navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    var isModallyPresented: Bool {
        return (hasPresentingController && !hasNavigationController)
            || (hasPresentingController && hasNavigationController && isNavigationRootViewController)
    }

    var hasPresentingController: Bool {
        return presentingViewController != nil
    }

    var hasNavigationController: Bool {
        return navigationController != nil
    }

    var isNavigationRootViewController: Bool {
        return navigationController?.viewControllers.first == self
    }
    
    func setupNavigationBar(withBackButton showBackButton: Bool){
        if showBackButton {
            addBackButton()
        } else {
            navigationItem.hidesBackButton = true
        }
        navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: DesignSystem.Colors.Palette.brandWhite.color)
        navigationController?.navigationBar.backItem?.title = ""
    }
}
