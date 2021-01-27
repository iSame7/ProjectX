//
//  AppRootCoordinator.swift
//  ProjectX
//
//  Created by Sameh Mabrouk on 27/01/2021.
//  Copyright © 2021 Sameh Mabrouk. All rights reserved.
//

import UIKit
import Core
import RxSwift
import Map
import Utils

class AppRootCoordinator: BaseCoordinator<Void> {
    
    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() -> Observable<Void> {
        guard let mapCoordinator: BaseCoordinator<Void> = MapModuleBuilder(container: DependencyManager.shared).buildModule(with: window)?.coordinator else {
            preconditionFailure("[AppCoordinator] Cannot get ClientLocationSelectorModuleBuilder from module builder")
        }
        
        _ = coordinate(to: mapCoordinator)
        return .never()
    }
}
