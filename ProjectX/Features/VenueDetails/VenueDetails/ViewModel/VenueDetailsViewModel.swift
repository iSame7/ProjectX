//
//  VenueDetailsViewModel.swift
//  VenueDetails
//
//  Created Sameh Mabrouk on 04/02/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import RxSwift
import Utils
import Core
import FoursquareCore

protocol VenueDetailsViewModellable: ViewModellable {
    var disposeBag: DisposeBag { get }
    var inputs: VenueDetailsViewModelInputs { get }
    var outputs: VenueDetailsViewModelOutputs { get }
}

struct VenueDetailsViewModelInputs {
    var viewState = PublishSubject<ViewState>()
    var backButtonTapped = PublishSubject<Void>()
}

struct VenueDetailsViewModelOutputs {
    var showVenueDetailsHeader = PublishSubject<VenueDetailsTableStretchyHeader.ViewData>()
    var showError = PublishSubject<FoursquareError>()
    var showMap = PublishSubject<Void>()
}

class VenueDetailsViewModel: VenueDetailsViewModellable {

    let disposeBag = DisposeBag()
    let inputs = VenueDetailsViewModelInputs()
    let outputs = VenueDetailsViewModelOutputs()
    private let useCase: VenueDetailsInteractable
    private let venueId: String
    private let venuePhotoURL: String?
    
    init(useCase: VenueDetailsInteractable, venueId: String, venuePhotoURL: String?) {
        self.useCase = useCase
        self.venueId = venueId
        self.venuePhotoURL = venuePhotoURL
        
        setupObservables()
    }
}

// MARK: - Observables

private extension VenueDetailsViewModel {

    func setupObservables() {
        observeInputs()
    }
    
    func observeInputs() {
        inputs.viewState.subscribe(onNext: { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .loaded:
                self.useCase.getVenueDetails(venueId: self.venueId).subscribe { event in
                    if let venue = event.element?.venue, let category = venue.categories.first {
                        self.outputs.showVenueDetailsHeader.onNext(VenueDetailsTableStretchyHeader.ViewData(title: venue.name, description: category.name, imageURL: self.venuePhotoURL, imagePlaceholder: "restraunt-placeholder"))
                    } else if let error = event.element?.error {
                        self.outputs.showError.onNext(error)
                    }
                }.disposed(by: self.disposeBag)
            default:
                break
            }
        }).disposed(by: disposeBag)
        
        inputs.backButtonTapped.subscribe(onNext: { [weak self] in
            self?.outputs.showMap.onNext(())
        }).disposed(by: disposeBag)
    }
}
