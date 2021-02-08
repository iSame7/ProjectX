//
//  MapCoordinator.swift
//  Map
//
//  Created Sameh Mabrouk on 27/01/2021.
//  Copyright © 2021 Sameh Mabrouk. All rights reserved.
//

import RxSwift
import Core
import Utils
import FoursquareCore
import VenueDetails

class MapCoordinator: BaseCoordinator<Void> {
    
    private weak var window: UIWindow?
    private let viewController: UINavigationController
    private let venueDetailsModuleBuilder: VenueDetailsModuleBuildable
    
    var showVenueDetials = PublishSubject<(venue: Venue, venuePhotoURL: String?)>()

    init(window: UIWindow, viewController: UINavigationController, venueDetailsModuleBuilder: VenueDetailsModuleBuildable) {
        self.window = window
        self.viewController = viewController
        self.venueDetailsModuleBuilder = venueDetailsModuleBuilder
    }
    
    override public func start() -> Observable<Void> {
        window?.setRootViewController(viewController: viewController)
        
        showVenueDetials.subscribe { [weak self] (venue, venuePhotoURL) in
            guard let self = self else { return }
            
            guard let venueDetailsCoordinator: BaseCoordinator<Void> = self.venueDetailsModuleBuilder.buildModule(with: self.viewController, venueId: venue.id, venuePhotoURL: venuePhotoURL)?.coordinator else {
                preconditionFailure("Cannot get venueDetailsCoordinator from module builder")
            }
            
            self.coordinate(to: venueDetailsCoordinator).subscribe(onNext: {
            }).disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)

        return .never()
    }
}
