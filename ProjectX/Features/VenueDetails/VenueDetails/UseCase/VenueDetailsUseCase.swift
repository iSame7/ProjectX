//
//  VenueDetailsUseCase.swift
//  VenueDetails
//
//  Created Sameh Mabrouk on 04/02/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import RxSwift
import FoursquareCore
import Alamofire

public protocol VenueDetailsInteractable {
    func getVenueDetails(venueId: String) -> Observable<(venue: Venue?, error: FoursquareError?)>
}

class VenueDetailsUseCase: VenueDetailsInteractable {

    private let service: VenueDetailsServiceFetching
    private let networkRechabilityManager: NetworkReachabilityManager?
    private let disposeBag = DisposeBag()

    init(service: VenueDetailsServiceFetching, networkRechabilityManager: NetworkReachabilityManager?) {
        self.service = service
        self.networkRechabilityManager = networkRechabilityManager
    }
    
    func getVenueDetails(venueId: String) -> Observable<(venue: Venue?, error: FoursquareError?)> {
        return Observable.create { observer in
            self.service.fetchVenueDetails(venueId: venueId).subscribe { event in
                guard let element = event.element else { return }
                
                switch element.error {
                case .noInternetConnection:
                    self.networkRechabilityManager?.startListening(onUpdatePerforming: { status in
                        print("Network Status Changed: \(status)")
                        switch status {
                        case .reachable(_):
                            self.service.fetchVenueDetails(venueId: venueId).subscribe { event in
                                observer.onNext(event)
                            }.disposed(by: self.disposeBag)
                        default:
                            break
                        }
                    })
                default:
                    observer.onNext((element.venue, element.error))
                }
            }.disposed(by: self.disposeBag)
                        
            return Disposables.create()
        }
    }
}
