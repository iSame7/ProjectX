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
    private let mapModuleBuilder: MapModuleBuildable
    
    init(window: UIWindow, mapModuleBuilder: MapModuleBuildable) {
        self.window = window
        self.mapModuleBuilder = mapModuleBuilder
    }
    
    override func start() -> Observable<Void> {
        guard let mapCoordinator: BaseCoordinator<Void> = mapModuleBuilder.buildModule(with: window)?.coordinator else {
            preconditionFailure("[AppCoordinator] Cannot get mapCoordinator from module builder")
        }
        
        _ = coordinate(to: mapCoordinator).subscribe({ event in
            
        }).disposed(by: disposeBag)
        return .never()
    }
}
