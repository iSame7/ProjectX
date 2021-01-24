//
//  ApolloClient+Rx.swift
//  Core
//
//  Created by Sameh Mabrouk on 12/03/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import Foundation
import Apollo
import RxSwift

public enum ApolloError: Error {
    case gqlErrors([GraphQLError])
}

extension ApolloClient: ReactiveCompatible {}

extension Reactive where Base: ApolloClient {
    
    /**
     Fetches a query from the server or from the local cache, depending on the current contents of the cache and the specified cache policy.
     - parameter query: The query to fetch.
     - parameter cachePolicy: A cache policy that specifies whether results should be fetched from the server or loaded from the local cache
     - parameter context: [optional] A context to use for the cache to work with results. Should default to nil.
     - parameter queue: A dispatch queue on which the result handler will be called. Defaults to the main queue.
     - returns: A generic observable of fetched query data
     */
    public func fetch<Query: GraphQLQuery>(
        query: Query,
        cachePolicy: CachePolicy = .returnCacheDataElseFetch,
        context: UnsafeMutableRawPointer? = nil,
        queue: DispatchQueue = DispatchQueue.main
    ) -> Maybe<Query.Data> {
        return Maybe.create { [weak base] observer in
            let cancellable = base?.fetch(
                query: query,
                cachePolicy: cachePolicy,
                context: context,
                queue: queue,
                resultHandler: { result in
                    switch result {
                    case let .success(gqlResult):
                        if let errors = gqlResult.errors {
                            observer(.error(ApolloError.gqlErrors(errors)))
                        } else if let data = gqlResult.data {
                            observer(.success(data))
                        } else {
                            observer(.completed)
                        }
                        
                    case let .failure(error):
                        observer(.error(error))
                    }
            })
            return Disposables.create {
                cancellable?.cancel()
            }
        }
    }
    
    /**
     Performs a mutation by sending it to the server.
     - parameter mutation: The mutation.
     - parameter context: [optional] A context to use for the cache to work with results. Should default to nil.
     - parameter queue: A dispatch queue on which the result handler will be called. Defaults to the main queue.
     - returns: A generic observable of created mutation data
     */
    public func perform<Mutation: GraphQLMutation>(
        mutation: Mutation,
        context: UnsafeMutableRawPointer? = nil,
        queue: DispatchQueue = DispatchQueue.main
    ) -> Maybe<Mutation.Data> {
        return Maybe.create { [weak base] observer in
            let cancellable = base?.perform(
                mutation: mutation,
                context: context,
                queue: queue,
                resultHandler: { result in
                    switch result {
                    case let .success(gqlResult):
                        if let errors = gqlResult.errors {
                            observer(.error(ApolloError.gqlErrors(errors)))
                        } else if let data = gqlResult.data {
                            observer(.success(data))
                        } else {
                            observer(.completed)
                        }
                        
                    case let .failure(error):
                        observer(.error(error))
                    }
            })
            return Disposables.create {
                cancellable?.cancel()
            }
        }
    }
}
