//
//  ShiftOverviewCoordinator.swift
//  Temper
//
//  Created by Ramitha Wirasinha on 12/16/19.
//  Copyright © 2019 Temper B.V. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Core
import Filters
import Utils

public final class ShiftOverviewCoordinator: BaseCoordinator<Void> {
    
    private let navigationController: NavigationControllable
    private var baseViewController: ShiftOverviewViewController
    private let filtersModule: FiltersModuleBuildable
    
    public var showJobPage = PublishSubject<(jobId: String, shiftId: String)>()
    public var showFilters = PublishSubject<Void>()
    public var didFinishFilters = PublishSubject<Filter?>()
    public var shiftApplied = PublishSubject<ShiftApplicationAlertType?>()
    
    public init(navigationController: NavigationControllable, baseViewController: ShiftOverviewViewController!, filtersModule: FiltersModuleBuildable) {
        self.navigationController = navigationController
        self.baseViewController = baseViewController
        self.filtersModule = filtersModule
    }
    
    override public func start() -> Observable<Void> {        
        navigationController.setViewControllers([baseViewController], animated: true)
        
        showFilters.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            guard let filtersCoordinator = self.filtersModule.buildModule(with: self.baseViewController)?.coordinator  else {
                preconditionFailure("Cannot get FiltersCoordinator from module builder")
            }
            
            self.coordinate(to: filtersCoordinator).subscribe(onNext: { [weak self] filter in
                self?.didFinishFilters.onNext(filter)
            }).disposed(by: self.disposeBag)
            
        }).disposed(by: disposeBag)
        
        return .never()
    }
}
