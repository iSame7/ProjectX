//
//  TipsService.swift
//  Tips
//
//  Created Sameh Mabrouk on 14/02/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import RxSwift
import Apollo
import Core

public protocol TipsServicePerforming {
    func doSomething() -> Single<Bool>
}

class TipsService: TipsServicePerforming {
    
    private let client: GraphQLClientProtocol
    private let serviceErrorListener: ServiceErrorListener
    
    public init(client: GraphQLClientProtocol, serviceErrorListener: ServiceErrorListener) {
        self.client = client
        self.serviceErrorListener = serviceErrorListener
    }
    
    
    func doSomething() -> Single<Bool> {
        return .just(true)
    }
}

private extension TipsService {
    func notifyError(_ error: Error) {
        serviceErrorListener.notifyError(errorMessage: error.localizedDescription, error: error)
    }
}
