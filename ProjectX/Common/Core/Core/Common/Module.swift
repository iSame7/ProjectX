//
//  Module.swift
//  Core
//
//  Created by Sameh Mabrouk on 16/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import Utils
import UIKit

public struct Module<T> {
    public let coordinator: BaseCoordinator<T>
    
    public init(coordinator: BaseCoordinator<T>) {
        self.coordinator = coordinator
    }
}

public protocol ModuleBuildable: class {
    func buildModule<T>() -> Module<T>?
    func buildModule<T>(with window: UIWindow) -> Module<T>?
    func buildModule<T>(with window: UIWindow, context: Any) -> Module<T>?
    func buildModule<T>(with rootViewController: NavigationControllable) -> Module<T>?
    func buildModule<T>(with rootViewController: NavigationControllable, context: Any) -> Module<T>?
}

extension ModuleBuildable {
    public func buildModule<T>() -> Module<T>? {
        return nil
    }
    
    public func buildModule<T>(with window: UIWindow) -> Module<T>? {
        return nil
    }
    
    public func buildModule<T>(with rootViewController: NavigationControllable) -> Module<T>? {
        return nil
    }
    
    public func buildModule<T>(with rootViewController: NavigationControllable, context: Any) -> Module<T>? {
        return nil
    }
    
    public func buildModule<T>(with window: UIWindow, context: Any) -> Module<T>? {
        return nil
    }
}
