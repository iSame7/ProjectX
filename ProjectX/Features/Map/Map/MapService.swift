//
//  MapService.swift
//  Map
//
//  Created Sameh Mabrouk on 27/01/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import RxSwift
import Apollo
import Core

public protocol MapServicePerforming {
    func doSomething() -> Single<Bool>
}

class MapService: MapServicePerforming {
    
    private let client: GraphQLClientProtocol
    
    public init(client: GraphQLClientProtocol) {
        self.client = client
    }
    
    
    func doSomething() -> Single<Bool> {
        return .just(true)
    }
}
