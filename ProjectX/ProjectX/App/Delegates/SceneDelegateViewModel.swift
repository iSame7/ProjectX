//
//  SceneDelegateViewModel.swift
//  ProjectX
//
//  Created by Sameh Mabrouk on 25/01/2021.
//  Copyright © 2021 Sameh Mabrouk. All rights reserved.
//

import RxSwift
import Core

enum TabType: Int {
    case overview
    case dashboard
    case profile
}

protocol SceneDelegateViewModellable: ViewModellable {
    func scene(continue userActivity: NSUserActivity)
    func scene(continue url: URL)
}

class SceneDelegateViewModel: SceneDelegateViewModellable {
    
    let disposeBag = DisposeBag()
    
    private let universalLinksRouter: UniversalLinkRouting
    private let window: UIWindow
    
    init(window: UIWindow, universalLinksRouter: UniversalLinkRouting) {
        self.window = window
        self.universalLinksRouter = universalLinksRouter
        bindUniversalLinksRoutes()
    }
    
    func bindUniversalLinksRoutes() {}
    
    func scene(continue userActivity: NSUserActivity) {
        if let url = userActivity.webpageURL {
            if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
                universalLinksRouter.dispatch(url)
            }
        }
    }
    
    func scene(continue url: URL) {
        universalLinksRouter.dispatch(url)
    }
}

private extension SceneDelegateViewModel {
    
    func handleMagicLinkAuthentication(token: String) {
        // Hadnle magic link login implementation goes here.
    }
    
    func selectTab(tap: TabType) {
        // Select tab bar tab implementation goes here.
    }
}
