//
//  GraphQLClinet.swift
//  Core
//
//  Created by Sameh Mabrouk on 15/03/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import Foundation
import Apollo
import RxSwift
import Utils

public class GraphQLClient: GraphQLClientProtocol {
    
    private lazy var client: ApolloClient = {
        let serverUrl = URL(staticString: Config.baseURL)
        
        // Accept-Language HTTP Header; see https://tools.ietf.org/html/rfc7231#section-5.3.5
        let acceptLanguage = Locale.preferredLanguages.prefix(6).enumerated().map { index, languageCode in
            let quality = 1.0 - (Double(index) * 0.1)
            return "\(languageCode);q=\(quality)"
        }.joined(separator: ", ")
        
        let urlSessionConfiguration = URLSessionConfiguration.default
        urlSessionConfiguration.httpAdditionalHeaders = [
            "Authorization": "Bearer \("TOKEN")",
            "Accept-Language": acceptLanguage
        ]
        
        let client = URLSessionClient(sessionConfiguration: urlSessionConfiguration)
        let networkTransport = HTTPNetworkTransport(url: serverUrl, client: client)
        return ApolloClient(networkTransport: networkTransport)
    }()    
    
    public init() {}
    
    public func fetch<Query: GraphQLQuery>(query: Query) -> Observable<Query.Data> {
        return client.rx.fetch(query: query, cachePolicy: .fetchIgnoringCacheCompletely).asObservable()
    }
    
    public func perform<Mutation>(mutation: Mutation) -> Observable<Mutation.Data> where Mutation: GraphQLMutation {
        return client.rx.perform(mutation: mutation).asObservable()
    }
}
