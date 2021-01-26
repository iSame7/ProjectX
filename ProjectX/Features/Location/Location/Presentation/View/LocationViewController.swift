//
//  LocationViewController.swift
//  Location
//
//  Created by Sameh Mabrouk on 12/02/2020.
//  Copyright © 2020 Sameh Mabrouk. All rights reserved.
//

import UIKit
import DesignSystem

public class LocationViewController: TableViewController<LocationViewModel> {

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.title
                
        addBackButton()
    }
    
    public override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
        if parent == navigationController?.parent {
            viewModel.didDismissLocation.onNext((false, nil))
        }
    }
}
