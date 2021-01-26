//
//  FilterCategoryBuilder.swift
//  Filters
//
//  Created by Sameh Mabrouk on 17/02/2020.
//  Copyright © 2020 Sameh Mabrouk. All rights reserved.
//

import UIKit
import Core
import Utils
import DesignSystem

public protocol FilterCategoryModuleBuildable: ModuleBuildable {
    func buildModule(with rootViewController: NavigationControllable, sectionName: String, items: [Selectable], showFooter: Bool) -> Module<Void>?
}

public class FilterCategoryBuilder: FilterCategoryModuleBuildable {
    
    private let container: DependencyManager
    
    public init(container: DependencyManager) {
        self.container = container
    }
    
    public func buildModule(with rootViewController: NavigationControllable, sectionName: String, items: [Selectable], showFooter: Bool) -> Module<Void>? {
        registerViewModel(with: sectionName, items: items, showFooter: showFooter)
        registerView()
        registerCoordinator(with: rootViewController)
        
        guard let coordinator = container.resolve(FilterCategoryCoordinator.self) else {
            return nil
        }
        
        return Module(coordinator: coordinator)
    }
    
    public func buildModule<T>(with rootViewController: NavigationControllable) -> Module<T>? {
        return nil
    }
}

private extension FilterCategoryBuilder {
    
    func registerViewModel(with sectionName: String, items: [Selectable], showFooter: Bool) {
        container.register(TableViewModelProtocol.self) {
            FilterCategoryViewModel(sectionItems: items, sectionName: sectionName, showFooter: showFooter)
        }
    }
    
    func registerView() {
        container.register(FilterCategoryViewController.self) { [weak self] in
            guard let filtersViewModel = self?.container.resolve(TableViewModelProtocol.self) as? FilterCategoryViewModel  else {
                return nil
            }
            
            return FilterCategoryViewController.create(viewModel: filtersViewModel)
        }
    }
    
    func registerCoordinator(with rootViewController: NavigationControllable) {
        container.register(FilterCategoryCoordinator.self) { [weak self] in
            guard let filterCategoryViewController = self?.container.resolve(FilterCategoryViewController.self) else {
                return nil
            }
            
            let coordinator = FilterCategoryCoordinator(rootViewController: rootViewController, filterCategoryViewController: filterCategoryViewController)
            coordinator.result = filterCategoryViewController.viewModel.result
                        
            return coordinator
        }
    }
}
