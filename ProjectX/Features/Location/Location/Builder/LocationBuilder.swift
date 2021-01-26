//
//  LocationBuilder.swift
//  Location
//
//  Created by Sameh Mabrouk on 16/02/2020.
//  Copyright © 2020 Sameh Mabrouk. All rights reserved.
//

import Core
import Utils
import DesignSystem
import CoreLocation
import UIKit
import MapboxGeocoder

public protocol LocationBuildable: ModuleBuildable {
    func buildModule(with navigationController: NavigationControllable) -> Module<Location?>?
}

public class LocationBuilder: LocationBuildable {
    
    private let container: DependencyManager
    
    public init(container: DependencyManager) {
        self.container = container
    }
    
    public func buildModule(with navigationController: NavigationControllable) -> Module<Location?>? {
        registerLocationService()
        registerUseCase()
        registerViewModel()
        registerView()
        registerCoordinator(with: navigationController)
        
        guard let coordinator = container.resolve(LocationCoordinator.self) else {
            return nil
        }
                
        return Module(coordinator: coordinator)
    }
}

private extension LocationBuilder {
    
    func registerLocationService() {
        container.register(CLLocationManager.self) {
            let locationManager = CLLocationManager()
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.activityType = .other
            
            return locationManager
        }
        
        container.register(Geocoder.self) {
            Geocoder(accessToken: "pk.eyJ1IjoidGVtcGVyd29ya3MiLCJhIjoiY2pua21rZzBkMTU0cjNrcDd2aTF1anQxaSJ9.X-2pFA89Z4ffp_T8qfesqA")
        }
        
        container.register(LocationServiceChecking.self) { [weak self] in
            guard let locationManager = self?.container.resolve(CLLocationManager.self), let geocoder = self?.container.resolve(Geocoder.self) else {
                return nil
            }
            
            return LocationService(locationManager: locationManager, geocoder: geocoder)
        }
    }
    
    func registerUseCase() {
        container.register(LocationInteractable.self) { [weak self] in
            guard let locationService = self?.container.resolve(LocationServiceChecking.self) else {
                return nil
            }
            
            return LocationUsecase(locationService: locationService)
        }
    }
    
    func registerViewModel() {
        container.register(TableViewModelProtocol.self) { [weak self] in
            guard let locationUsecase = self?.container.resolve(LocationInteractable.self) else {
                return nil
            }
            
            return LocationViewModel(locationUsecase: locationUsecase)
        }
    }
    
    func registerView() {
        container.register(LocationViewController.self) { [weak self] in
            guard let locationViewModel = self?.container.resolve(TableViewModelProtocol.self) as? LocationViewModel  else {
                return nil
            }
            
            return LocationViewController.create(viewModel: locationViewModel)
        }
    }
    
    func registerCoordinator(with navigationController: NavigationControllable) {
        container.register(LocationCoordinator.self) { [weak self] in
            guard let locationViewController = self?.container.resolve(LocationViewController.self) else {
                return nil
            }
            
            let coordinator = LocationCoordinator(navigationController: navigationController, locationViewController: locationViewController)            
            coordinator.didDismissLocation = locationViewController.viewModel.didDismissLocation
            
            return coordinator
        }
    }
}
