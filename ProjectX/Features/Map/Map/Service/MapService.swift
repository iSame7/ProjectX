//
//  MapService.swift
//  Map
//
//  Created Sameh Mabrouk on 27/01/2021.
//  Copyright © 2021 Sameh Mabrouk. All rights reserved.
//

import RxSwift
import FoursquareCore
import Alamofire

protocol VenuFetching {
    func fetchVenues(coordinates: String) -> Observable<(venues: [Venue]?, error: FoursquareError?)>
    func fetchVenuesPhotos(venueId: String) -> Observable<[Photo]?>
}

class MapService: VenuFetching {
    
    private let session: Session
    private let requestRetrier: RequestRetrier
    private let networkRechabilityManager: NetworkReachabilityManager?
    
    public init(session: Session, requestRetrier: RequestRetrier, networkRechabilityManager: NetworkReachabilityManager?) {
        self.session = session
        self.requestRetrier = requestRetrier
        self.networkRechabilityManager = networkRechabilityManager
    }
    
    func fetchVenues(coordinates: String) -> Observable<(venues: [Venue]?, error: FoursquareError?)> {
        return Observable.create { [unowned self] observer in
            session.request(Router.fetchRestaurants(coordinates: coordinates)).responseJSON { response in
                
                switch response.result {
                case .success:
                    if let data = response.data {
                        do {
                            let JSON = try JSONDecoder().decode(SearchResult.self, from: data)
                            let venues = JSON.response.venues
                            observer.onNext((venues, nil))
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
    
    func fetchVenuesPhotos(venueId: String) -> Observable<[Photo]?> {
        return Observable.create { [unowned self] observer in
            session.request(Router.fetchPhotos(venueId: venueId)).responseJSON { response in
                switch response.result {
                case .success:
                    if let data = response.data {
                        do {
                            let JSON = try JSONDecoder().decode(VenuePhotoResponse.self, from: data)
                            let photos = JSON.response.photos?.items
                            observer.onNext(photos)
                        }
                        catch {
                            print("Error processing data \(error)")                            
                        }
                    }
                case  let .failure(error):
                    print("Error\(String(describing: error))")
                    observer.onNext(nil)
                }
            }
            return Disposables.create()
        }
    }
}
