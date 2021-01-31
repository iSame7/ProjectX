//
//  MapViewModel.swift
//  Map
//
//  Created Sameh Mabrouk on 27/01/2021.
//  Copyright © 2021 Sameh Mabrouk. All rights reserved.
//

import RxSwift
import Utils
import Core
import FoursquareCore

protocol MapViewModellable: ViewModellable {
    var disposeBag: DisposeBag { get }
    var inputs: MapViewModelInputs { get }
    var outputs: MapViewModelOutputs { get }
}

struct MapViewModelInputs {
    var viewState = PublishSubject<ViewState>()
    var restaurantsListAroundCoordinatedRequested = PublishSubject<(lat: String, lng: String)>()
}

struct MapViewModelOutputs {
    var showUserLocation = PublishSubject<(lat: Double, lng: Double)>()
    var showRestaurantsList = PublishSubject<[Venue]>()
    var showError = PublishSubject<FoursquareError>()
}

class MapViewModel: MapViewModellable {
    
    let disposeBag = DisposeBag()
    let inputs = MapViewModelInputs()
    let outputs = MapViewModelOutputs()
    var useCase: MapInteractable
    
    init(useCase: MapInteractable) {
        self.useCase = useCase
        
         observeInputs()
    }
}

// MARK: - Observables

private extension MapViewModel {
    
    func setupObservables() {
        observeInputs()
    }
    
    func observeInputs() {
        inputs.viewState.subscribe(onNext: { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .loaded:
                self.useCase.determineUserLocation().subscribe { event in
                    guard let location = event.element else { return }
                    self.outputs.showUserLocation.onNext((location.lat, location.lng))
                }.disposed(by: self.disposeBag)
            default:
                break
            }
        }).disposed(by: disposeBag)
        
        inputs.restaurantsListAroundCoordinatedRequested.subscribe { [weak self] (lat, lng) in
            guard let self = self else { return }

            let coordinate = "\(lat),\(lng)"
            self.useCase.getRestaurantsAround(coordinates: coordinate).subscribe({ event in
                guard let result = event.element else { return }
                
                if let venues = result.venues {
                    self.outputs.showRestaurantsList.onNext(venues)
                } else if let error = result.error {
                    self.outputs.showError.onNext(error)
                }
                
            }).disposed(by: self.disposeBag)
        }.disposed(by: disposeBag)
    }
}
