//
//  TipsModuleBuilder.swift
//  Tips
//
//  Created Sameh Mabrouk on 14/02/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Utils
import Components
import Core

protocol TipsModuleBuildable: ModuleBuildable {}

class TipsModuleBuilder: TipsModuleBuildable {
    
    private let container: DependencyManager
    
    public init(container: DependencyManager) {
        self.container = container
    }
    
    func buildModule<T>(with rootViewController: NavigationControllable) -> Module<T>? {
        registerService()
        registerUsecase()
        registerViewModel()
        registerView()
        registerCoordinator(rootViewController: rootViewController)
        
        guard let coordinator = container.resolve(TipsCoordinator.self) else {
            return nil
        }
        
        return Module(coordinator: coordinator) as? Module<T>
    }
}

private extension TipsModuleBuilder {
    
    func registerUsecase() {
        container.register(TipsInteractable.self) { [weak self] in
            guard let self = self,
                let service = self.container.resolve(TipsServicePerforming.self) else { return nil }
            return TipsUseCase(service: service)
        }
    }
    
    func registerService() {
        container.register(ServiceErrorListener.self) { TemperServiceErrorListener() }
        container.register(CoreConfiguration.self) { CoreConfiguration.sharedInstance }
        container.register(GraphQLClientProtocol.self) { [weak self] in
            guard let coreConfiguration = self?.container.resolve(CoreConfiguration.self) else { return nil }
            return GraphQLClient(withConfiguration: coreConfiguration)
        }
        
        container.register(TipsServicePerforming.self) { [weak self] in
            guard let client = self?.container.resolve(GraphQLClientProtocol.self),
                let listener = self?.container.resolve(ServiceErrorListener.self) else { return nil }
            return TipsService(client: client, serviceErrorListener: listener)
        }
    }
    
    func registerViewModel() {
        container.register(TipsViewModel.self) { [weak self] in
            guard let useCase = self?.container.resolve(TipsInteractable.self) else { return nil }
            
            return TipsViewModel(useCase: useCase)
        }
    }
    
    func registerView() {
        container.register(TipsViewController.self) { [weak self] in
            guard let viewModel = self?.container.resolve(TipsViewModel.self) else {
                return nil
            }
            
            return TipsViewController.instantiate(with: viewModel)
        }
    }
    
    func registerCoordinator(rootViewController: NavigationControllable? = nil) {
        container.register(TipsCoordinator.self) { [weak self] in
            guard let viewController = self?.container.resolve(TipsViewController.self) else {
                return nil
            }
            
            let coordinator = TipsCoordinator(rootViewController: rootViewController, viewController: viewController)
            return coordinator
        }
    }
}
