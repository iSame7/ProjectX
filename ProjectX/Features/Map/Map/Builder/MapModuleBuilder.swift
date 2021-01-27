//
//  MapModuleBuilder.swift
//  Map
//
//  Created Sameh Mabrouk on 27/01/2021.
//  Copyright © 2021 Sameh Mabrouk. All rights reserved.
//

import UIKit
import Utils
import Core

/// Provides all dependencies to build the MapModuleBuilder
private final class MapDependencyProvider: DependencyProvider<EmptyDependency> {}

public protocol MapModuleBuildable: ModuleBuildable {}

public class MapModuleBuilder: Builder<EmptyDependency>, MapModuleBuildable {
    
    public func buildModule<T>(with window: UIWindow) -> Module<T>? {
        registerService()
        registerUsecase()
        registerViewModel()
        registerView()
        registerCoordinator(with: window)
        
        guard let coordinator = container.resolve(MapCoordinator.self) else {
            return nil
        }
        
        return Module(coordinator: coordinator) as? Module<T>
    }
}

private extension MapModuleBuilder {
    
    func registerUsecase() {
        container.register(MapInteractable.self) { [weak self] in
            guard let self = self,
                let service = self.container.resolve(MapServicePerforming.self) else { return nil }
            return MapUseCase(service: service)
        }
    }
    
    func registerService() {
        container.register(GraphQLClientProtocol.self) {
            return GraphQLClient()
        }
        
        container.register(MapServicePerforming.self) { [weak self] in
            guard let client = self?.container.resolve(GraphQLClientProtocol.self) else { return nil }
            return MapService(client: client)
        }
    }
    
    func registerViewModel() {
        container.register(MapViewModel.self) { [weak self] in
            guard let useCase = self?.container.resolve(MapInteractable.self) else { return nil }
            
            return MapViewModel(useCase: useCase)
        }
    }
    
    func registerView() {
        container.register(MapViewController.self) { [weak self] in
            guard let viewModel = self?.container.resolve(MapViewModel.self) else {
                return nil
            }
            
            return MapViewController.instantiate(with: viewModel)
        }
    }
    
    func registerCoordinator(with window: UIWindow) {
        container.register(MapCoordinator.self) { [weak self] in
            guard let viewController = self?.container.resolve(MapViewController.self) else {
                return nil
            }
            
            let coordinator = MapCoordinator(window: window, viewController: viewController)
            return coordinator
        }
    }
}
