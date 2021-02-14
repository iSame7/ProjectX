//
//  VenueDetailsCoordinator.swift
//  VenueDetails
//
//  Created Sameh Mabrouk on 04/02/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import RxSwift
import Core
import DesignSystem
import Utils
import FoursquareCore
import Tips

class VenueDetailsCoordinator: BaseCoordinator<Void> {
    
    private weak var rootViewController: NavigationControllable?
    private let viewController: UIViewController
    private let tipsModuleBuilder: TipsModuleBuildable
    
    var backButtonTapped = PublishSubject<Void>()
    var showTips = PublishSubject<(tips: [TipItem], venuePhotoURL: String?)>()

    init(rootViewController: NavigationControllable?, viewController: UIViewController, tipsModuleBuilder: TipsModuleBuildable) {
        self.rootViewController = rootViewController
        self.viewController = viewController
        self.tipsModuleBuilder = tipsModuleBuilder
    }
    
    override public func start() -> Observable<Void> {
        rootViewController?.pushViewController(viewController, animated: true)
        
        showTips.subscribe { [weak self] (tips: [TipItem], venuePhotoURL: String?) in
            guard let self = self else { return }
            
            guard let tipsCoordinator: BaseCoordinator<Void> = self.tipsModuleBuilder.buildModule(with: self.viewController, tips: tips, venuePhotoURL: venuePhotoURL)?.coordinator else {
                preconditionFailure("Cannot get tipsCoordinator from module builder")
            }
            
            self.coordinate(to: tipsCoordinator).subscribe(onNext: {
            }).disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
        
        return backButtonTapped.do(onNext: { [weak self] in
           _ = self?.rootViewController?.popViewController(animated: true)
        })
    }
}
