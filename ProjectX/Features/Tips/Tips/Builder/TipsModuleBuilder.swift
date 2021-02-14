//
//  TipsModuleBuilder.swift
//  Tips
//
//  Created Sameh Mabrouk on 14/02/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import Utils
import DesignSystem
import Core
import FoursquareCore

public protocol TipsModuleBuildable: ModuleBuildable {
    func buildModule<T>(with rootViewController: Presentable, tips: [TipItem], venuePhotoURL: String?) -> Module<T>?
}

public class TipsModuleBuilder: Builder<EmptyDependency>, TipsModuleBuildable {

    public func buildModule<T>(with rootViewController: Presentable, tips: [TipItem], venuePhotoURL: String?) -> Module<T>? {
        registerViewModel(tips: tips, venuePhotoURL: venuePhotoURL)
        registerView()
        registerCoordinator(rootViewController: rootViewController)
        
        guard let coordinator = container.resolve(TipsCoordinator.self) else {
            return nil
        }
        
        return Module(coordinator: coordinator) as? Module<T>
    }
}

private extension TipsModuleBuilder {
    
    func registerViewModel(tips: [TipItem], venuePhotoURL: String?) {
        container.register(TipsViewModellable.self) {
            return TipsViewModel(tips: tips, venuePhotoURL: venuePhotoURL)
        }
    }
    
    func registerView() {
        container.register(TipsViewController.self) { [weak self] in
            guard let viewModel = self?.container.resolve(TipsViewModellable.self) as? TipsViewModel else {
                return nil
            }
            
            return TipsViewController.instantiate(with: viewModel)
        }
    }
    
    func registerCoordinator(rootViewController: Presentable? = nil) {
        container.register(TipsCoordinator.self) { [weak self] in
            guard let viewController = self?.container.resolve(TipsViewController.self) else {
                return nil
            }
            
            let coordinator = TipsCoordinator(rootViewController: rootViewController, viewController: viewController)
            coordinator.backButtonTapped = viewController.viewModel.outputs.showVenueDetails
            return coordinator
        }
    }
}
