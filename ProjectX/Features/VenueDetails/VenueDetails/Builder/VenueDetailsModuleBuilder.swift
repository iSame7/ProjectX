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
import FoursquareCore

public protocol VenueDetailsDependency {
    var session: Session { get }
    var networkRechabilityManager: NetworkReachabilityManager? { get }
}

/// Provides all dependencies to build the VenueDetailsModuleBuilder
private final class VenueDetailsDependencyProvider: DependencyProvider<VenueDetailsDependency> {
    
    var session: Session {
        return dependency.session
    }
    
    fileprivate var networkRechabilityManager: NetworkReachabilityManager? {
        return dependency.networkRechabilityManager
    }
}

public protocol VenueDetailsModuleBuildable: ModuleBuildable {
    func buildModule<T>(with rootViewController: NavigationControllable, venue: Venue, venuePhotoURL: String?) -> Module<T>?
}

public class VenueDetailsModuleBuilder: Builder<VenueDetailsDependency> , VenueDetailsModuleBuildable {
    
    public func buildModule<T>(with rootViewController: NavigationControllable, venue: Venue, venuePhotoURL: String?) -> Module<T>? {
        let venueDetailsDependencyProvider = VenueDetailsDependencyProvider(dependency: dependency)
        
        registerService(session: venueDetailsDependencyProvider.session)
        registerUsecase(networkRechabilityManager: venueDetailsDependencyProvider.networkRechabilityManager)
        registerMapURLHandler()
        registerViewModel(venue: venue, venuePhotoURL: venuePhotoURL)
        registerView()
        registerCoordinator(rootViewController: rootViewController)
        
        guard let coordinator = container.resolve(VenueDetailsCoordinator.self) else {
            return nil
        }
        
        return Module(coordinator: coordinator) as? Module<T>
    }
}

private extension VenueDetailsModuleBuilder {
    
    func registerUsecase(networkRechabilityManager: NetworkReachabilityManager?) {
        container.register(VenueDetailsInteractable.self) { [weak self] in
            guard let self = self,
                let service = self.container.resolve(VenueDetailsServiceFetching.self) else { return nil }
            return VenueDetailsUseCase(service: service, networkRechabilityManager: networkRechabilityManager)
        }
    }
    
    func registerService(session: Session) {
        container.register(VenueDetailsServiceFetching.self) {
            return VenueDetailsService(session: session)
        }
    }
    
    func registerMapURLHandler() {
        container.register(MapURLHandling.self) {
            MapURLHandler()
        }
    }
    
    func registerViewModel(venue: Venue, venuePhotoURL: String?) {
        container.register(VenueDetailsViewModel.self) { [weak self] in
            guard let useCase = self?.container.resolve(VenueDetailsInteractable.self),
                  let mapURLHandler = self?.container.resolve(MapURLHandling.self) else { return nil }
            
            return VenueDetailsViewModel(useCase: useCase, venue: venue, venuePhotoURL: venuePhotoURL, mapURLHandler: mapURLHandler)
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
            coordinator.backButtonTapped = viewController.viewModel.outputs.showMap
            return coordinator
        }
    }
}
