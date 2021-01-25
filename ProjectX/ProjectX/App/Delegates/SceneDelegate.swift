//
//  SceneDelegate.swift
//  ProjectX
//
//  Created by Sameh Mabrouk on 22/12/2019.
//  Copyright © 2019 Sameh Mabrouk. All rights reserved.
//

import UIKit
import Core

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var sceneDelegateViewModel: SceneDelegateViewModellable!

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            window.makeKeyAndVisible()
            
            Core.setup(with: AppConfig.self)
        }
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        sceneDelegateViewModel.scene(continue: userActivity)
    }

    // Support url scheme for testing deeplinks with: "xcrun simctl openurl booted" command on simulators.
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        let urlConext = URLContexts.first
        if let url = urlConext?.url {
            sceneDelegateViewModel.scene(continue: url)
        }
    }
}

