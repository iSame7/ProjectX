//
//  MapUseCase.swift
//  Map
//
//  Created Sameh Mabrouk on 27/01/2021.
//  Copyright © 2021 Sameh Mabrouk. All rights reserved.
//

import RxSwift
import FoursquareCore
import Alamofire
import Utils

public protocol MapInteractable {
    func getRestaurantsAround(coordinates: String) -> Observable<(venues: [Venue]?, error: FoursquareError?)>
    func determineUserLocation() -> Observable<Location>
    func getVenuesPhotos(venueId: String) -> Observable<[Photo]?>
}

class MapUseCase: MapInteractable {

    private let service: VenuFetching
    private let locationService: LocationServiceChecking
    private let networkRechabilityManager: NetworkReachabilityManager?
    private let disposeBag = DisposeBag()
    
    init(service: VenuFetching, locationService: LocationServiceChecking, networkRechabilityManager: NetworkReachabilityManager?) {
        self.service = service
        self.locationService = locationService
        self.networkRechabilityManager = networkRechabilityManager
    }

    func getRestaurantsAround(coordinates: String) -> Observable<(venues: [Venue]?, error: FoursquareError?)> {
        return Observable.create { observer in
            self.service.fetchVenues(coordinates: coordinates).subscribe { event in
                guard let element = event.element else { return }
                
                switch element.error {
                case .noInternetConnection:
                    self.networkRechabilityManager?.startListening(onUpdatePerforming: { status in
                        print("Network Status Changed: \(status)")
                        switch status {
                        case .reachable(_):
                            self.service.fetchVenues(coordinates: coordinates).subscribe { event in
                                observer.onNext(event)
                            }.disposed(by: self.disposeBag)
                        default:
                            break
                        }
                    })
                default:
                    observer.onNext((element.venues, element.error))
                }
            }.disposed(by: self.disposeBag)
                        
            return Disposables.create()
        }
    }
    
    func determineUserLocation() -> Observable<Location> {
        locationService.requestAuthorization()
        return Observable.create { [unowned self] observer in
            locationService.requestUserLocation { location in
                observer.onNext(location)
            }
            
            return Disposables.create()
        }
    }
    
    func getVenuesPhotos(venueId: String) -> Observable<[Photo]?> {
        service.fetchVenuesPhotos(venueId: venueId)
    }
}
