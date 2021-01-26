//
//  UniversalLinkRoute.swift
//  Core
//
//  Created by Sameh Mabrouk on 01/09/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

public typealias DeepLinkRouteQuickHandler = ([String: String]) -> Void
public typealias DeepLinkRouteHandler = (URL, UniversalLinkRoute, [String: String]) -> Void

public class UniversalLinkRoute: CustomDebugStringConvertible {

    private weak var router: UniversalLinksRouter?

    /** Original route pattern this route was created with */
    private let pattern: String?

    /** Route handler to use during dispatching */
    public let handler: DeepLinkRouteHandler

    public var debugDescription: String {
        return pattern ?? ""
    }

    public init(router: UniversalLinksRouter, pattern: String?, handler: @escaping DeepLinkRouteHandler) {
        self.pattern = pattern
        self.router = router
        self.handler = handler
    }

    /**
    Add a route pattern alias to this route

    - parameter pattern: Route pattern

    - returns: Current route instance for chaining
    */
    public func addAlias(pattern: String) -> UniversalLinkRoute {
        return addAliases(patterns: [pattern])
    }

    /**
    Add route pattern aliases to this route

    - parameter patterns: Route patterns

    - returns: Current route instance for chaining
    */
    public func addAliases(patterns: [String]) -> UniversalLinkRoute {
        router?.register(patterns, route: self)
        return self
    }
}
