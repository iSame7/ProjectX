//
//  VenueDetailsModuleBuilder.swift
//  VenueDetails
//
//  Created Sameh Mabrouk on 04/02/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Utils
import DesignSystem
import Core
import Alamofire

protocol VenueDetailsDependency {
    var session: Session { get }
}

/// Provides all dependencies to build the VenueDetailsModuleBuilder
private final class VenueDetailsDependencyProvider: DependencyProvider<VenueDetailsDependency> {
    
    var session: Session {
        return dependency.session
    }
}

protocol VenueDetailsModuleBuildable: ModuleBuildable {}

class VenueDetailsModuleBuilder: Builder<VenueDetailsDependency> , VenueDetailsModuleBuildable {
    
    func buildModule<T>(with rootViewController: NavigationControllable) -> Module<T>? {
        let venueDetailsDependencyProvider = VenueDetailsDependencyProvider(dependency: dependency)
        
        registerService(session: venueDetailsDependencyProvider.session)
        registerUsecase()
        registerViewModel()
        registerView()
        registerCoordinator(rootViewController: rootViewController)
        
        guard let coordinator = container.resolve(VenueDetailsCoordinator.self) else {
            return nil
        }
        
        return Module(coordinator: coordinator) as? Module<T>
    }
}

private extension VenueDetailsModuleBuilder {
    
    func registerUsecase() {
        container.register(VenueDetailsInteractable.self) { [weak self] in
            guard let self = self,
                let service = self.container.resolve(VenueDetailsServiceFetching.self) else { return nil }
            return VenueDetailsUseCase(service: service)
        }
    }
    
    func registerService(session: Session) {
        container.register(VenueDetailsServiceFetching.self) {
            return VenueDetailsService(session: session)
        }
    }
    
    func registerViewModel() {
        container.register(VenueDetailsViewModel.self) { [weak self] in
            guard let useCase = self?.container.resolve(VenueDetailsInteractable.self) else { return nil }
            
            return VenueDetailsViewModel(useCase: useCase)
        }
    }
    
    func registerView() {
        container.register(VenueDetailsViewController.self) { [weak self] in
            guard let viewModel = self?.container.resolve(VenueDetailsViewModel.self) else {
                return nil
            }
            
            return VenueDetailsViewController.instantiate(with: viewModel)
        }
    }
    
    func registerCoordinator(rootViewController: NavigationControllable? = nil) {
        container.register(VenueDetailsCoordinator.self) { [weak self] in
            guard let viewController = self?.container.resolve(VenueDetailsViewController.self) else {
                return nil
            }
            
            let coordinator = VenueDetailsCoordinator(rootViewController: rootViewController, viewController: viewController)
            return coordinator
        }
    }
}
