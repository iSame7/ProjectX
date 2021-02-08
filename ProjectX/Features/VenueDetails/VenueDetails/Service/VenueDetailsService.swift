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
import FoursquareCore

public protocol VenueDetailsServiceFetching {
    func fetchVenueDetails(venueId: String) -> Observable<(venue: Venue?, error: FoursquareError?)>
}

class VenueDetailsService: VenueDetailsServiceFetching {
    
    private let session: Session
    
    public init(session: Session) {
        self.session = session
    }
    
    func fetchVenueDetails(venueId: String) -> Observable<(venue: Venue?, error: FoursquareError?)> {
        return Observable.create { [unowned self] observer in
            session.request(Router.fetchVenueDetails(venueId: venueId)).responseJSON { response in
                switch response.result {
                case .success:
                    if let data = response.data {
                        do {
                            let JSON = try JSONDecoder().decode(DetailsResult.self, from: data)
                            let venue = JSON.response.venue
                            observer.onNext((venue, nil))
                        }
                        catch {
                            print("Error processing data \(error)")
                            observer.onNext((nil, .JSONParsing))
                        }
                    }
                case  let .failure(error):
                    print("Error\(String(describing: error))")
                    if error.isSessionTaskError {
                        observer.onNext((nil, .noInternetConnection))
                    } else {
                        observer.onNext((nil, .noResponse))
                    }
                }
            }
            return Disposables.create()
        }
    }
}
