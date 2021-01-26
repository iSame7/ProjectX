//
//  FilterCategoryCoordinator.swift
//  Filters
//
//  Created by Sameh Mabrouk on 17/02/2020.
//  Copyright © 2020 Sameh Mabrouk. All rights reserved.
//

import Core
import RxSwift
import UIKit
import Utils

public final class FilterCategoryCoordinator: BaseCoordinator<Void> {
    private let rootViewController: NavigationControllable
    private let filterCategoryViewController: FilterCategoryViewController
    
    var result = PublishSubject<Void>()
    
    public init(rootViewController: NavigationControllable, filterCategoryViewController: FilterCategoryViewController) {
        self.rootViewController = rootViewController
        self.filterCategoryViewController = filterCategoryViewController
    }
    
    public override func start() -> Observable<Void> {
        rootViewController.pushViewController(filterCategoryViewController, animated: true)
        return result
    }
}
