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
import Alamofire
import CoreLocation
import VenueDetails

/// Provides all dependencies to build the MapModuleBuilder
private final class MapDependencyProvider: DependencyProvider<EmptyDependency>, VenueDetailsDependency {
    
    fileprivate var session: Session { AF }
    fileprivate var requestRetrier: RequestRetrier { NetworkRequestRetrier() }
    fileprivate var networkRechabilityManager: NetworkReachabilityManager? { NetworkReachabilityManager() }
    fileprivate var locationManager: CLLocationManager { CLLocationManager() }
    fileprivate var venueDetailsModuleBuilder: VenueDetailsModuleBuildable { VenueDetailsModuleBuilder(dependency: self) }
}

public protocol MapModuleBuildable: ModuleBuildable {}

public class MapModuleBuilder: Builder<EmptyDependency>, MapModuleBuildable {
    
    public func buildModule<T>(with window: UIWindow) -> Module<T>? {
        let mapDependencyProvider = MapDependencyProvider()
        
        registerService(session: mapDependencyProvider.session, requestRetrier: mapDependencyProvider.requestRetrier, networkRechabilityManager: mapDependencyProvider.networkRechabilityManager, locationManager: mapDependencyProvider.locationManager)
        registerUsecase(networkRechabilityManager: mapDependencyProvider.networkRechabilityManager)
        registerViewModel()
        registerView()
        registerCoordinator(with: window, venueDetailsModuleBuilder: mapDependencyProvider.venueDetailsModuleBuilder)
        
        guard let coordinator = container.resolve(MapCoordinator.self) else {
            return nil
        }
        
        return Module(coordinator: coordinator) as? Module<T>
    }
}

private extension MapModuleBuilder {
    
    func registerUsecase(networkRechabilityManager: NetworkReachabilityManager?) {
        container.register(MapInteractable.self) { [weak self] in
            guard let self = self,
                  let service = self.container.resolve(VenuFetching.self),
                  let locationService = self.container.resolve(LocationServiceChecking.self) else { return nil }
            return MapUseCase(service: service, locationService: locationService, networkRechabilityManager: networkRechabilityManager)
        }
    }
    
    func registerService(session: Session, requestRetrier: RequestRetrier, networkRechabilityManager: NetworkReachabilityManager?, locationManager: CLLocationManager) {
        container.register(GraphQLClientProtocol.self) {
            return GraphQLClient()
        }
        
        container.register(VenuFetching.self) {
            return MapService(session: session, requestRetrier: requestRetrier, networkRechabilityManager: networkRechabilityManager)
        }
        
        container.register(LocationServiceChecking.self) {
            return LocationService(locationManager: locationManager)
        }
    }
    
    func registerViewModel() {
        container.register(MapViewModellable.self) { [weak self] in
            guard let useCase = self?.container.resolve(MapInteractable.self) else { return nil }
            
            return MapViewModel(useCase: useCase)
        }
    }
    
    func registerView() {
        container.register(MapViewController.self) { [weak self] in
            guard let viewModel = self?.container.resolve(MapViewModellable.self) as? MapViewModel else {
                return nil
            }
            
            return MapViewController.instantiate(with: viewModel)
        }
    }
    
    func registerCoordinator(with window: UIWindow, venueDetailsModuleBuilder: VenueDetailsModuleBuildable) {
        container.register(MapCoordinator.self) { [weak self] in
            guard let viewController = self?.container.resolve(MapViewController.self) else {
                return nil
            }
            
            let coordinator = MapCoordinator(window: window, viewController: UINavigationController(rootViewController: viewController), venueDetailsModuleBuilder: venueDetailsModuleBuilder)
            coordinator.showVenueDetials = viewController.viewModel.outputs.showVenueDetials
            return coordinator
        }
    }
}
