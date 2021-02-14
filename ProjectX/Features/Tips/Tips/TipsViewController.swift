//
//  TipsViewController.swift
//  Tips
//
//  Created Sameh Mabrouk on 14/02/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Utils

class TipsViewController: UIViewController, ViewModelDependable {

    typealias ViewModel = TipsViewModellable
	var viewModel: ViewModel!

	override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}

// MARK: - setupUI

extension TipsViewController {

    func setupUI() {}

    func setupConstraints() {}

    func setupObservers() {}
}
