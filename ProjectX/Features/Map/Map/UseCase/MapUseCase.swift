//
//  MapUseCase.swift
//  Map
//
//  Created Sameh Mabrouk on 27/01/2021.
//  Copyright © 2021 Sameh Mabrouk. All rights reserved.
//

import RxSwift
import FoursquareCore

public protocol MapInteractable {
    func getRestaurantsAround(coordinates: String) -> Observable<([Venue]?, FoursquareError?)>
}

class MapUseCase: MapInteractable {

    private let service: VenuFetching
    
    init(service: VenuFetching) {
        self.service = service
    }

    func getRestaurantsAround(coordinates: String) -> Observable<([Venue]?, FoursquareError?)> {
        service.fetchVenues(coordinates: coordinates)
    }
}
