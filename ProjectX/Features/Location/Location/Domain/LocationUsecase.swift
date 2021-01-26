//
//  LocationUsecase.swift
//  Location
//
//  Created by Sameh Mabrouk on 14/02/2020.
//  Copyright © 2020 Sameh Mabrouk. All rights reserved.
//

import RxSwift

public protocol LocationInteractable {
    func getUserLocation(completion: @escaping UserLocationCompletionHandler)
    func getLocationsFor(text: String) -> Observable<[Location]>
}

public class LocationUsecase: LocationInteractable {
    private let locationService: LocationServiceChecking
    
    public init(locationService: LocationServiceChecking) {
        self.locationService = locationService
    }
    
    public func getUserLocation(completion: @escaping (Location) -> Void) {
        locationService.requestUserLocation(completion: completion)
    }
    
    public func getLocationsFor(text: String) -> Observable<[Location]> {
        return locationService.searchLocationsFor(text: text)
    }
}
