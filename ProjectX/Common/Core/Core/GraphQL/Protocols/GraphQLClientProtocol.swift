//
//  GraphQLClientProtocol.swift
//  Core
//
//  Created by Sameh Mabrouk on 15/03/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import Apollo
import RxSwift

/// The `GraphQLClientProtocol` provides the core API for GraphQL. This API provides methods to fetch and watch queries, and to perform mutations.

public protocol GraphQLClientProtocol {
    func fetch<Query: GraphQLQuery>(query: Query) -> Observable<Query.Data>
    func perform<Mutation: GraphQLMutation>(mutation: Mutation) -> Observable<Mutation.Data>
}
