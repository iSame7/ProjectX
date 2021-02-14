//
//  TipsUseCase.swift
//  Tips
//
//  Created Sameh Mabrouk on 14/02/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import RxSwift

public protocol TipsInteractable {
    func doSomething() -> Single<Bool>
}

class TipsUseCase: TipsInteractable {

    private let service: TipsServicePerforming
    
    init(service: TipsServicePerforming) {
        self.service = service
    }
    
    func doSomething() -> Single<Bool> {
        service.doSomething()
    }
}
