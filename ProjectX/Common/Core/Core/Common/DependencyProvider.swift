//
//  DependencyProvider.swift
//  Core
//
//  Created by Sameh Mabrouk on 26/01/2021.
//

/// Provides dependencies to a `Builder`'s build method.
class DependencyProvider<DependencyType> {
    let dependency: DependencyType

    init(dependency: DependencyType) {
        self.dependency = dependency
    }
}

// MARK: - Empty Dependency Support
private final class EmptyDependencyImpl: EmptyDependency {}

extension DependencyProvider where DependencyType == EmptyDependency {
    convenience init() {
        self.init(dependency: EmptyDependencyImpl())
    }
}
