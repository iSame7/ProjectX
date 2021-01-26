//
//  MapViewController.swift
//  Map
//
//  Created Sameh Mabrouk on 27/01/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Utils

class MapViewController: UIViewController, ViewModelDependable {

    typealias ViewModel = MapViewModellable
	var viewModel: ViewModel!

	override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - setupUI

extension MapViewController {

    func setupUI() {}

    func setupConstraints() {}

    func setupObservers() {}
}
