//
//  VenueDetailsService.swift
//  VenueDetails
//
//  Created Sameh Mabrouk on 04/02/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import RxSwift
import Alamofire
import Core

public protocol VenueDetailsServiceFetching {}

class VenueDetailsService: VenueDetailsServiceFetching {
    
    private let session: Session
    
    public init(session: Session) {
        self.session = session
    }
}
