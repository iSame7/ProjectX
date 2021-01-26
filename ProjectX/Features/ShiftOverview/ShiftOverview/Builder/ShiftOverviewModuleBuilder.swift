//
//  ShiftOverviewModuleBuilder.swift
//  ShiftOverview
//
//  Created by Sameh Mabrouk on 14/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit
import Core
import Utils
import Filters

public protocol ShiftOverviewModuleBuildable: ModuleBuildable {}

public class ShiftOverviewModuleBuilder: ShiftOverviewModuleBuildable {
    
    private let container: DependencyManager
    
    public init(container: DependencyManager) {
        self.container = container
    }
    
    public func buildModule<T>(with rootViewController: NavigationControllable, context: Any) -> Module<T>? {
        registerService()
        registerFilterService()
        registerFilterPreferencesService()
        registerUsecase()
        registerViewModel(bannerType: (context as? ShiftOverviewBannerType) ?? nil)
        registerView()
        registerFiltersModule()
        registerJobModule()
        registerCoordinator(with: rootViewController)
        
        guard let coordinator = container.resolve(ShiftOverviewCoordinator.self) else {
            return nil
        }
        
        return Module(coordinator: coordinator) as? Module<T>
    }
}

private extension ShiftOverviewModuleBuilder {
    
    func registerService() {
        container.register(ShiftOverviewServiceFetching.self) {
            ShiftOverviewService()
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
    
    func registerUsecase() {
        container.register(ShiftOverviewUseCase.self) { [weak self] in 
            guard let shiftOverviewService = self?.container.resolve(ShiftOverviewServiceFetching.self),
                let filterService = self?.container.resolve(FilterServiceFetching.self),
                let filterPreferencesService = self?.container.resolve(FilterPreferencesFetching.self) else {
                    return nil
            }
            
            return ShiftOverviewUseCase(shiftOverviewService: shiftOverviewService, filterService: filterService, filterPreferencesService: filterPreferencesService)
        }
    }
    
    func registerViewModel(bannerType: ShiftOverviewBannerType?) {
        container.register(ShiftOverviewViewModel.self) { [weak self] in
            guard let shiftOverviewUsecase = self?.container.resolve(ShiftOverviewUseCase.self) else {
                return nil
            }
            
            return ShiftOverviewViewModel(withUseCase: shiftOverviewUsecase, filterCache: FilterMemCache.shared, bannerType: bannerType)
        }
    }
    
    func registerView() {
        container.register(ShiftOverviewViewController.self) { [weak self] in
            guard let shiftOverviewViewModel = self?.container.resolve(ShiftOverviewViewModel.self)  else {
                return nil
            }
            
            return ShiftOverviewViewController.create(viewModel: shiftOverviewViewModel)
        }
    }
    
    func registerCoordinator(with navigationController: NavigationControllable) {
        container.register(ShiftOverviewCoordinator.self) { [weak self] in
            guard let shiftOverviewViewController = self?.container.resolve(ShiftOverviewViewController.self),
                let filtersMduleBuilder = self?.container.resolve(FiltersModuleBuildable.self),
                let jobModuleBuilder = self?.container.resolve(JobPageModuleBuildable.self) else {
                    return nil
            }
            
            let coordinator = ShiftOverviewCoordinator(navigationController: navigationController, baseViewController: shiftOverviewViewController, filtersModule: filtersMduleBuilder, jobModule: jobModuleBuilder)
            shiftOverviewViewController.viewModel.onFinishFilterCoordinator = coordinator.didFinishFilters
            coordinator.showJobPage = shiftOverviewViewController.viewModel.showJobPage
            coordinator.showFilters = shiftOverviewViewController.viewModel.showFilters
            coordinator.shiftApplied = shiftOverviewViewController.viewModel.shiftApplied
            return coordinator
        }
    }
    
    func registerFiltersModule() {
        container.register(FiltersModuleBuildable.self) { [weak self] in
            guard let self = self else { return nil }
            
            return FiltersModuleBuilder(container: self.container)
        }
    }
    
    func registerJobModule() {
        container.register(JobPageModuleBuildable.self) { [weak self] in
            guard let self = self else { return nil }
            
            return JobPageModuleBuilder(container: self.container)
        }
    }
}
