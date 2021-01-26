//
//  UniversalLinksRouter.swift
//  Core
//
//  Created by Sameh Mabrouk on 01/09/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

private typealias PatternRoutePair = (pattern: CompiledPattern, route: UniversalLinkRoute)
private typealias CompiledPattern = (NSRegularExpression, [String])

public protocol UniversalLinkRouting {
    func add(alias: String, pattern: String)
    func register(_ routePattern: String, handler: @escaping DeepLinkRouteQuickHandler)
    func register(_ routePatterns: [String], handler: @escaping DeepLinkRouteQuickHandler)
    func registerFull(_ routePattern: String, handler: @escaping DeepLinkRouteHandler)
    func registerFull(_ routePatterns: [String], handler: @escaping DeepLinkRouteHandler)
    func dispatch(_ url: URL)
}

/// Match the incoming URL and takes the appropriate actions.
public class UniversalLinksRouter: UniversalLinkRouting {
    
    // MARKS: - Private properties
    
    private var patterns = [PatternRoutePair]()
    private var aliases = [String: String]()
    private let unescapePattern = try! NSRegularExpression(pattern: "\\\\([\\{\\}\\?])", options: [])
    private let parameterPattern = try! NSRegularExpression(pattern: "\\{([a-zA-Z0-9_\\-]+)\\}", options: [])
    private let optionalParameterPattern = try! NSRegularExpression(pattern: "(\\\\\\/)?\\{([a-zA-Z0-9_\\-]+)\\?\\}", options: [])
    private let slashCharacterSet = CharacterSet(charactersIn: "/")
    
    // MARK: - Public functions
    
    public init() { }
    
    /**
     Add an parameter alias
     
     - parameter alias: Name of the parameter
     - parameter pattern: Regex pattern to match on
     */
    public func add(alias: String, pattern: String) {
        self.aliases[alias] = pattern
    }
    
    /**
     Register a route pattern
     
     - parameter pattern: Route pattern
     - parameter handler: Quick handler to call when route is dispatched
     
     - returns: New route instance for the pattern
     */
    public func register(_ routePattern: String, handler: @escaping DeepLinkRouteQuickHandler) {
        register([routePattern], handler: handler)
    }
    
    /**
     Register route patterns
     
     - parameter pattern: Route patterns
     - parameter handler: Quick handler to call when route is dispatched
     
     - returns: New route instance for the patterns
     */
    public func register(_ routePatterns: [String], handler: @escaping DeepLinkRouteQuickHandler) {
        registerFull(routePatterns) { (_, _, parameters) in
            handler(parameters)
        }
    }
    
    /**
     Route a URL and get the routed instance back
     
     - parameter url: URL to route
     
     - returns: Instance of UniversalLinkRouted with binded parameters if matched, nil if route isn’t supported
     */
    public func route(_ url: URL) -> UniversalLinkRouted? {
        let path = self.normalizePath(url.path)
        let range = NSRange(location: 0, length: path.count)
        
        for pattern in patterns {
            if let match = pattern.0.0.firstMatch(in: path, options: [], range: range) {
                var parameters = Dictionary<String, String>()
                let parameterKeys = pattern.0.1
                
                if !parameterKeys.isEmpty {
                    for i in 1 ..< match.numberOfRanges {
                        let range = match.range(at: i)
                        
                        if range.location != NSNotFound {
                            let value = (path as NSString).substring(with: range)
                            
                            if i <= parameterKeys.count {
                                parameters[parameterKeys[i - 1]] = value
                            }
                        }
                    }
                }
                
                return UniversalLinkRouted(route: pattern.route, parameters: parameters)
            }
        }
        
        return nil
    }
    
    /**
     Dispatch a url
     
     - parameter url: URL to dispatch
     */
    public func dispatch(_ url: URL) {
        if let routed = route(url) {
            routed.route.handler(url, routed.route, routed.parameters)
        }
    }
    
    // MARK: - Private fucntions
    /**
     Register a route pattern with full handler
     
     - parameter pattern: Route pattern
     - parameter handler: Full handler to call when route is dispatched
     
     - returns: New route instance for the pattern
     */
    public func registerFull(_ routePattern: String, handler: @escaping DeepLinkRouteHandler) {
        registerFull([routePattern], handler: handler)
    }
    
    /**
     Register route patterns with full handler
     
     - parameter pattern: Route patterns
     - parameter handler: Full handler to call when route is dispatched
     
     - returns: New route instance for the patterns
     */
    public func registerFull(_ routePatterns: [String], handler: @escaping DeepLinkRouteHandler) {
        precondition(!routePatterns.isEmpty, "Route patterns must contain at least one pattern")
        
        let route = UniversalLinkRoute(router: self, pattern: routePatterns.first, handler: handler)
        register(routePatterns, route: route)
    }
    
    func register(_ routePatterns: [String], route: UniversalLinkRoute) {
        for routePattern in routePatterns {
            patterns.append(PatternRoutePair(compilePattern(routePattern), route))
        }
    }
}

// MARKS: - Private helpers

private extension UniversalLinksRouter {
    
    func regexReplace(_ expression: NSRegularExpression, replacement: String, target: NSMutableString) {
        expression.replaceMatches(in: target, options: [], range: NSRange(location: 0, length: target.length), withTemplate: replacement)
    }
    
    /// This makes some regex dancing
    func compilePattern(_ pattern: String) -> CompiledPattern {
        // Escape pattern
        let compiled = NSMutableString(string: NSRegularExpression.escapedPattern(for: normalizePath(pattern)))
        
        // Unescape path parameters
        regexReplace(unescapePattern, replacement: "$1", target: compiled)
        
        // Extract out optional parameters so we have just {parameter} instead of {parameter?}
        regexReplace(optionalParameterPattern, replacement: "(?:$1{$2})?", target: compiled)
        
        // Compile captures since unfortunately Foundation doesnt’t support named groups
        var captures = [String]()
        
        parameterPattern.enumerateMatches(in: String(compiled), options: [], range: NSRange(location: 0, length: compiled.length)) { (match, _, _) in
            if let match = match, match.numberOfRanges > 1 {
                let range = match.range(at: 1)
                
                if range.location != NSNotFound {
                    captures.append(compiled.substring(with: range))
                }
            }
        }
        
        for alias in aliases {
            compiled.replaceOccurrences(of: "{\(alias.0)}", with: "(\(alias.1))", options: [], range: NSRange(location: 0, length: compiled.length))
        }
        
        regexReplace(parameterPattern, replacement: "([^\\/]+)", target: compiled)
        compiled.insert("^", at: 0)
        compiled.append("$")
        
        do {
            let expression = try NSRegularExpression(pattern: String(compiled), options: [])
            return CompiledPattern(expression, captures)
        } catch let error as NSError {
            preconditionFailure("Error compiling pattern: \(compiled), error: \(error)")
        }
    }
        
    func normalizePath(_ path: String?) -> String {
        if let path = path?.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines), path.count > 0 {
            return "/" + path.trimmingCharacters(in: slashCharacterSet)
        } else {
            return "/"
        }
    }
}
