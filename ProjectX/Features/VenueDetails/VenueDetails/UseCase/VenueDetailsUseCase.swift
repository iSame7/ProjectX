//
//  VenueDetailsUseCase.swift
//  VenueDetails
//
//  Created Sameh Mabrouk on 04/02/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import RxSwift

public protocol VenueDetailsInteractable {}

class VenueDetailsUseCase: VenueDetailsInteractable {

    private let service: VenueDetailsServiceFetching
    
    init(service: VenueDetailsServiceFetching) {
        self.service = service
    }
}
