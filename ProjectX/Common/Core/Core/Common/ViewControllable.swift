//
//  ViewControllable.swift
//  Core
//
//  Created by Sameh Mabrouk on 27/01/2021.
//

import UIKit

public protocol ViewControllable {
    associatedtype ViewModel
    var uiviewController: UIViewController { get }
    var viewModel: ViewModel! { get set }

    func setupUI()
    func setupConstraints()
    func setupObservers()
}

public extension ViewControllable where Self: UIViewController {

    static func instantiate(with viewModel: ViewModel) -> Self {
        var viewController = Self.init()
        viewController.viewModel = viewModel
        return viewController
    }
}
