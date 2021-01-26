//
//  Builder.swift
//  Core
//
//  Created by Sameh Mabrouk on 26/01/2021.
//

/// A Builder can build new objects using a dependency as input
///
/// Builders can be added to an architecture to simplify dependency
/// injecten and (therefore) object creation.
public class Builder<DependencyType> {
    /// DependencyType instance to use to create return a built instance
    let dependency: DependencyType

    /// Initialises a new builder instance
    ///
    /// - Parameter dependency: Dependency of type DependencyType
    init(dependency: DependencyType) {
        self.dependency = dependency
    }
}

// MARK: - Empty Dependency Support
/// Empty Dependency implementation
/// Is used implicitly when defining a Builder with EmptyDependency
/// as DependencyType
private final class EmptyDependencyImpl: EmptyDependency {}

extension Builder where DependencyType == EmptyDependency {
    convenience init() {
        self.init(dependency: EmptyDependencyImpl())
    }
}
