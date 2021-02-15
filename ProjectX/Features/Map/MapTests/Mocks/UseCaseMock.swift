//
//  UseCaseMock.swift
//  MapTests
//
//  Created by Sameh Mabrouk on 14/02/2021.
//

import Core
import RxSwift
import FoursquareCore

@testable import Map

class MapUseCase: MapInteractable {
    
    var invokedGetRestaurantsAround = false
    var invokedGetRestaurantsAroundCount = 0
    var invokedGetRestaurantsAroundParameters: (coordinates: String, Void)?
    var invokedGetRestaurantsAroundParametersList = [(coordinates: String, Void)]()
    var stubbedGetRestaurantsAroundResult: Observable<(venues: [Venue]?, error: FoursquareError?)>!
    func getRestaurantsAround(coordinates: String) -> Observable<(venues: [Venue]?, error: FoursquareError?)> {
        invokedGetRestaurantsAround = true
        invokedGetRestaurantsAroundCount += 1
        invokedGetRestaurantsAroundParameters = (coordinates, ())
        invokedGetRestaurantsAroundParametersList.append((coordinates, ()))
        return stubbedGetRestaurantsAroundResult
    }
    
    var invokedDetermineUserLocation = false
    var invokedDetermineUserLocationCount = 0
    var stubbedDetermineUserLocationResult: Observable<Location>!
    func determineUserLocation() -> Observable<Location> {
        invokedDetermineUserLocation = true
        invokedDetermineUserLocationCount += 1
        return stubbedDetermineUserLocationResult
    }
    
    var invokedGetVenuesPhotos = false
    var invokedGetVenuesPhotosCount = 0
    var invokedGetVenuesPhotosParameters: (venueId: String, Void)?
    var invokedGetVenuesPhotosParametersList = [(venueId: String, Void)]()
    var stubbedGetVenuesPhotosResult: Observable<[Photo]?>!
    func getVenuesPhotos(venueId: String) -> Observable<[Photo]?> {
        invokedGetVenuesPhotos = true
        invokedGetVenuesPhotosCount += 1
        invokedGetVenuesPhotosParameters = (venueId, ())
        invokedGetVenuesPhotosParametersList.append((venueId, ()))
        return stubbedGetVenuesPhotosResult
    }
}
