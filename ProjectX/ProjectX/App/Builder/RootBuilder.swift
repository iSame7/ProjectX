//
//  RootBuilder.swift
//  ProjectX
//
//  Created by Sameh Mabrouk on 27/01/2021.
//  Copyright © 2021 Sameh Mabrouk. All rights reserved.
//

import Core
import Map
import Utils
import UIKit

/// Provides all dependencies to build the AppRootCoordinator
private final class RootDependencyProvider: DependencyProvider<EmptyDependency> {
        
    fileprivate var mapModuleBuilder: MapModuleBuildable {
        MapModuleBuilder()
    }
}

protocol RootBuildable: ModuleBuildable {}

final class RootBuilder: Builder<EmptyDependency>, RootBuildable {
    
    // MARK: - RootBuildable
    
    func buildModule<T>(with window: UIWindow) -> Module<T>? {
        let dependencyProvider = RootDependencyProvider()
        let appRootCoordinator = AppRootCoordinator(window: window, mapModuleBuilder: dependencyProvider.mapModuleBuilder)
        return Module(coordinator: appRootCoordinator) as? Module<T>
    }
}
