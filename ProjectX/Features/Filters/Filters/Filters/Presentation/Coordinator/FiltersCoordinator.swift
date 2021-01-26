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
import DesignSystem

extension JobCategoryDetail: Selectable {}

public protocol FiltersCoordinatorDelegate: class {
    func filterCategoryCoordinatorDidFinish()
    func locationCoordinatorDidFinish(with location: Location?)
}

final class FiltersCoordinator: BaseCoordinator<Filter?> {
    private let rootViewController: Presentable
    private let filtersViewController: UINavigationController
    
    private let filterCategoryModuleBuilder: FilterCategoryModuleBuildable
    private let locationModuleBuilder: LocationBuildable
    
    var didTapJobSection = PublishSubject<(jobSectionName: String, categories: [JobCategoryDetail])>()
    var didTapLocation = PublishSubject<Void>()
    var didDismiss = PublishSubject<Filter?>()
    var didApply = PublishSubject<Filter?>()
    
    var didFinishCategoryCoordinator = PublishSubject<Void>()
    var didFinishLocationCoordinator = PublishSubject<Location?>()
    
    init(rootViewController: Presentable, filtersViewController: UINavigationController,
         filterCategoryModuleBuilder: FilterCategoryModuleBuildable,
         locationModuleBuilder: LocationBuildable) {
        self.rootViewController = rootViewController
        self.filtersViewController = filtersViewController
        self.filterCategoryModuleBuilder = filterCategoryModuleBuilder
        self.locationModuleBuilder = locationModuleBuilder
    }
    
    override func start() -> Observable<Filter?> {
        rootViewController.present(filtersViewController, animated: true, completion: nil)
        
        didTapJobSection.subscribe(onNext: { [weak self] (jobSectionName, categories) in
            guard let self = self else { return }
            
            guard let filterCategoryCoordinator = self.filterCategoryModuleBuilder.buildModule(with: self.filtersViewController, sectionName: jobSectionName, items: categories, showFooter: true)?.coordinator else {
                preconditionFailure("Cannot get filterCategoryCoordinator from module builder")
            }
            
            self.coordinate(to: filterCategoryCoordinator).subscribe(onNext: { [weak self] in
                self?.didFinishCategoryCoordinator.onNext(())
            }).disposed(by: self.disposeBag)
            
        }).disposed(by: disposeBag)
        
        didTapLocation.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            
            guard let locationCoordinator = self.locationModuleBuilder.buildModule(with: self.filtersViewController)?.coordinator else {
                preconditionFailure("Cannot get locationCoordinator from module builder")
            }
            
            self.coordinate(to: locationCoordinator).subscribe(onNext: { [weak self] location in
                self?.didFinishLocationCoordinator.onNext(location)
            }).disposed(by: self.disposeBag)
            
        }).disposed(by: disposeBag)
        
        return Observable.merge(didDismiss, didApply)
            .take(1)
            .do(onNext: { [weak self] _ in self?.rootViewController.dismiss(animated: true, completion: nil) })
    }
}
