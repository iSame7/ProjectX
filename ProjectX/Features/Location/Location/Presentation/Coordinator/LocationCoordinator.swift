//
//  LocationCoordinator.swift
//  Location
//
//  Created by Sameh Mabrouk on 16/02/2020.
//  Copyright © 2020 Sameh Mabrouk. All rights reserved.
//

import Core
import RxSwift
import UIKit
import Utils

public protocol LocationCoordinatorDelegate: class {
    func filterCategory(_ filterCategoryCoordinator: LocationCoordinator, didFinishWith location: Location?)
}

public final class LocationCoordinator: BaseCoordinator<Location?> {
    private let navigationController: NavigationControllable
    private let locationViewController: LocationViewController
    weak var delegate: LocationCoordinatorDelegate? 
    
    var didDismissLocation = PublishSubject<(Bool, Location?)>()
    
    init(navigationController: NavigationControllable, locationViewController: LocationViewController) {
        self.navigationController = navigationController
        self.locationViewController = locationViewController
    }
    
    override public func start() -> Observable<Location?> {
        navigationController.pushViewController(locationViewController, animated: true)
        return didDismissLocation.map { [weak self] (shouldPop, location) in
            if shouldPop {
                let _ = self?.navigationController.popViewController(animated: true)
            }
            return (location)
        }
    }
}
