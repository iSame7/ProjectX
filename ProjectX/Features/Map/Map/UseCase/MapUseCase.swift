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
    func determineUserLocation() -> Observable<Location>
}

class MapUseCase: MapInteractable {

    private let service: VenuFetching
    private let locationService: LocationServiceChecking
    
    init(service: VenuFetching, locationService: LocationServiceChecking) {
        self.service = service
        self.locationService = locationService
    }

    func getRestaurantsAround(coordinates: String) -> Observable<([Venue]?, FoursquareError?)> {
        service.fetchVenues(coordinates: coordinates)
    }
    
    func determineUserLocation() -> Observable<Location> {
        Observable.create { [unowned self] observer in
            locationService.requestUserLocation { location in
                observer.onNext(location)
            }
            
            return Disposables.create()
        }
    }
}
