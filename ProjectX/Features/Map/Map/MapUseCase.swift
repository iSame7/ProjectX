//
//  MapUseCase.swift
//  Map
//
//  Created Sameh Mabrouk on 27/01/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import RxSwift

public protocol MapInteractable {
    func doSomething() -> Single<Bool>
}

class MapUseCase: MapInteractable {

    private let service: MapServicePerforming
    
    init(service: MapServicePerforming) {
        self.service = service
    }
    
    func doSomething() -> Single<Bool> {
        service.doSomething()
    }
}
