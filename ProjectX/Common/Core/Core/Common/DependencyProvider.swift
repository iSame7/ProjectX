//
//  DependencyProvider.swift
//  Core
//
//  Created by Sameh Mabrouk on 26/01/2021.
//

/// Provides dependencies to a `Builder`'s build method.
open class DependencyProvider<DependencyType> {
    
    // `dependency` variable represents a parent dependency
    let dependency: DependencyType //

    public init(dependency: DependencyType) {
        self.dependency = dependency
    }
}

// MARK: - Empty Dependency Support if no parent dependencies are needed
private final class EmptyDependencyImpl: EmptyDependency {}

public extension DependencyProvider where DependencyType == EmptyDependency {
    convenience init() {
        self.init(dependency: EmptyDependencyImpl())
    }
}
