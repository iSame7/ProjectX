//
//  ViewType.swift
//  Utils
//
//  Created by Sameh Mabrouk on 26/01/2021.
//

import Foundation
import UIKit

public protocol ViewModelType: class {}
public protocol ModelType {}

public protocol ViewType {
    associatedtype GenericViewModel
    var viewModel: GenericViewModel! { get set }
    
    func setupUI()
    func setupObservers()
    func setupConstraints()
}

extension ViewType {

    public static func create<GenericVC: ViewType>(viewModel: GenericViewModel) -> GenericVC where GenericVC: UIViewController, GenericViewModel == GenericVC.GenericViewModel {

        var vc = GenericVC()
        vc.viewModel = viewModel
        
        return vc
    }
}
