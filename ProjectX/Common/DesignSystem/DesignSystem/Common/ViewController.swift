//
//  ViewController.swift
//  DesignSystem
//
//  Created by Sameh Mabrouk on 27/01/2021.
//

import UIKit
import Core

open class ViewController<T: ViewModellable>: UIViewController, ViewControllable {
    
    open var viewModel: T!
    
    public var uiviewController: UIViewController {
        return self
    }
    
    @available(*, unavailable, message: "NSCoder and Interface Builder is not supported. Use Programmatic layout.")
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setupUI() {}
    
    open func setupConstraints() {}
    
    open func setupObservers() {}
}
