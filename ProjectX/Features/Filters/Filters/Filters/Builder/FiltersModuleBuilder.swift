//
//  FiltersModuleBuilder.swift
//  Filters
//
//  Created by Sameh Mabrouk on 06/02/2020.
//  Copyright © 2020 Sameh Mabrouk. All rights reserved.
//

import UIKit
import Core
import Utils
import DesignSystem
import Location
import CoreLocation
import MapboxGeocoder

public protocol FiltersModuleBuildable: ModuleBuildable {
    func buildModule(with rootViewController: Presentable) -> Module<Filter?>?
}

public class FiltersModuleBuilder: FiltersModuleBuildable {
    
    private let container: DependencyManager
    
    public init(container: DependencyManager) {
        self.container = container
    }
    
    public func buildModule(with rootViewController: Presentable) -> Module<Filter?>? {
        registerLocationService()
        registerFilterService()
        registerFilterPreferencesService()
        registerFilterUsecase()
        registerViewModel()
        registerView()
        registerFiltersCategoryBuilder()
        registerLocationBuilder()
        registerCoordinator(with: rootViewController)
        
        guard let coordinator = container.resolve(FiltersCoordinator.self) else {
            return nil
        }
        
        return Module(coordinator: coordinator)
    }
    
    public func buildModule<T>(with rootViewController: NavigationControllable) -> Module<T>? {
        return nil
    }
}

private extension FiltersModuleBuilder {
    
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
            guard let locationManager = self?.container.resolve(CLLocationManager.self), let gecoder = self?.container.resolve(Geocoder.self) else {
                return nil
            }
            
            return LocationService(locationManager: locationManager, geocoder: gecoder)
        }
    }
        
    func registerFilterService() {
        container.register(FilterServiceFetching.self) {
            FilterService(filterCache: FilterMemCache.shared)
        }
    }
    
    func registerFilterPreferencesService() {
        container.register(FilterPreferencesFetching.self) {
            FilterPreferencesService(filterCache: FilterMemCache.shared)
        }
    }
    
    func registerFilterUsecase() {
        container.register(FiltersInteractable.self) { [weak self] in
            guard let filterService = self?.container.resolve(FilterServiceFetching.self),
                let filterPreferencesService = self?.container.resolve(FilterPreferencesFetching.self),
                let locationService = self?.container.resolve(LocationServiceChecking.self)  else {
                    return nil
            }
            
            return FiltersUsecase(filterService: filterService, filterPreferencesService: filterPreferencesService, locationService: locationService)
        }
    }
    
    func registerViewModel() {
        container.register(TableViewModelProtocol.self) { [weak self] in
            guard let filterUsecase = self?.container.resolve(FiltersInteractable.self) else {
                return nil
            }
            
            return FilterViewModel(filterUsecase: filterUsecase, filterCache: FilterMemCache.shared)
        }
    }
    
    func registerView() {
        container.register(NavigationControllable.self) { [weak self] in
            guard let filtersViewModel = self?.container.resolve(TableViewModelProtocol.self) as? FilterViewModel  else {
                return nil
            }
            
            let filterViewController: FiltersViewController = FiltersViewController.create(viewModel: filtersViewModel)
            return UINavigationController(rootViewController: filterViewController)
        }
    }
    
    func registerCoordinator(with rootViewController: Presentable) {
        container.register(FiltersCoordinator.self) { [weak self] in
            guard let filtersViewController = self?.container.resolve(NavigationControllable.self) as? UINavigationController,
                let filterCategoryModuleBuilder = self?.container.resolve(FilterCategoryModuleBuildable.self),
                let locationModuleBuilder = self?.container.resolve(LocationBuildable.self) else {
                    return nil
            }
            
            guard let filtersVC = filtersViewController.viewControllers.first as? FiltersViewController else {
                return nil
            }
            
            let coordinator = FiltersCoordinator(rootViewController: rootViewController, filtersViewController: filtersViewController, filterCategoryModuleBuilder: filterCategoryModuleBuilder, locationModuleBuilder: locationModuleBuilder)
            filtersVC.viewModel.didFinishCategoryCoordinator = coordinator.didFinishCategoryCoordinator
            filtersVC.viewModel.didFinishLocation = coordinator.didFinishLocationCoordinator
            coordinator.didTapJobSection = filtersVC.viewModel.didTapJobSection
            coordinator.didTapLocation = filtersVC.viewModel.didTapLocation
            coordinator.didDismiss = filtersVC.viewModel.didDismiss
            coordinator.didApply = filtersVC.viewModel.didApply
            return coordinator
        }
    }
    
    func registerFiltersCategoryBuilder()  {
        container.register(FilterCategoryModuleBuildable.self) { [weak self] in
            guard let self = self else { return nil }
            
            return FilterCategoryBuilder(container: self.container)
        }
    }
    
    func registerLocationBuilder() {
        container.register(LocationBuildable.self) { [weak self] in
            guard let self = self else { return nil }
            
            return LocationBuilder(container: self.container)
        }
    }
}
