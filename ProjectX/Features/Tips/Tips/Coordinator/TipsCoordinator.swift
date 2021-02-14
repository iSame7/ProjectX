//
//  TipsCoordinator.swift
//  Tips
//
//  Created Sameh Mabrouk on 14/02/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import RxSwift
import Core
import DesignSystem
import Utils

class TipsCoordinator: BaseCoordinator<Void> {
    
    private weak var rootViewController: Presentable?
    private let viewController: UIViewController
    
    var backButtonTapped = PublishSubject<Void>()

    init(rootViewController: Presentable?, viewController: UIViewController) {
        self.rootViewController = rootViewController
        self.viewController = viewController
    }
    
    override public func start() -> Observable<Void> {
        rootViewController?.presentInFullScreen(viewController, animated: true, completion: nil)
        
        return backButtonTapped.do(onNext: { [weak self] in
            self?.viewController.dismiss(animated: true, completion: nil)
        })
    }
}
