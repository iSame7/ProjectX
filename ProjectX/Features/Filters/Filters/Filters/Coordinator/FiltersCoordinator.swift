//
//  FiltersCoordinator.swift
//  Filters
//
//  Created by Sameh Mabrouk on 17/02/2020.
//  Copyright © 2020 Sameh Mabrouk. All rights reserved.
//

import Core
import RxSwift
import UIKit
import Utils
import Location

final class FiltersCoordinator: BaseCoordinator<Any> {
    private let rootViewController: Presentable
    private let filtersViewController: UINavigationController
    
    private let filterCategoryModuleBuilder: FilterCategoryModuleBuildable
    private let locationModuleBuilder: LocationBuildable
    
    init(rootViewController: Presentable, filtersViewController: UINavigationController,
         filterCategoryModuleBuilder: FilterCategoryModuleBuildable,
         locationModuleBuilder: LocationBuildable) {
        self.rootViewController = rootViewController
        self.filtersViewController = filtersViewController
        self.filterCategoryModuleBuilder = filterCategoryModuleBuilder
        self.locationModuleBuilder = locationModuleBuilder
    }
    
    override func start() -> Observable<Any> {
        rootViewController.present(filtersViewController, animated: true, completion: nil)
        return .just(())
    }
}

extension FiltersCoordinator: FilterViewModelDelegate {
    func didTapCategoryItem() {
        guard let filterCategoryCoordinator = filterCategoryModuleBuilder.buildModule(with: filtersViewController)?.coordinator else {
            preconditionFailure("Cannot get filterCategoryCoordinator from module builder")
        }
        
        let _ = coordinate(to: filterCategoryCoordinator)
    }
    
    func didTapLocation() {
        guard let locationCoordinator = locationModuleBuilder.buildModule(with: filtersViewController)?.coordinator else {
            preconditionFailure("Cannot get locationCoordinator from module builder")
        }
        
        let _ = coordinate(to: locationCoordinator)
    }
}
