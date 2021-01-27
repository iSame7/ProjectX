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

class MapCoordinator: BaseCoordinator<Void> {
    
    private weak var window: UIWindow?
    private let viewController: UIViewController
    
    init(window: UIWindow, viewController: UIViewController) {
        self.window = window
        self.viewController = viewController
    }
    
    override public func start() -> Observable<Void> {
        window?.setRootViewController(viewController: viewController)
        return .never()
    }
}
