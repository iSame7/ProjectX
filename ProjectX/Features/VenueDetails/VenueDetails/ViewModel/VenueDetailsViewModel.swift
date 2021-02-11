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
    
    func buildVenueTableHeaderViewData() -> VenueDetailsTableStretchyHeader.ViewData
    func buildAddressTableViewCellViewData() -> AddressTableViewCell.ViewData?
    func buildRatingTableViewCellViewData() -> RatingTableViewCell.ViewData?
    func buildPhotoGalleryTableViewCellViewData() -> PhotoGalleryTableViewCell.ViewData?
    func venueLocation() -> Location?
}

struct VenueDetailsViewModelInputs {
    var viewState = PublishSubject<ViewState>()
    var backButtonTapped = PublishSubject<Void>()
    var showMap = PublishSubject<(type: MapType, location: Location)>()
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
    private let venue: Venue
    private let venuePhotoURL: String?
    private let mapURLHandler: MapURLHandling
    private var viewData: VenueDetailsViewController.ViewData?
    
    init(useCase: VenueDetailsInteractable, venue: Venue, venuePhotoURL: String?, mapURLHandler: MapURLHandling) {
        self.useCase = useCase
        self.venue = venue
        self.venuePhotoURL = venuePhotoURL
        self.mapURLHandler = mapURLHandler
        
        setupObservables()
    }
    
    func buildVenueTableHeaderViewData() -> VenueDetailsTableStretchyHeader.ViewData {
        return VenueDetailsTableStretchyHeader.ViewData(title: venue.name, description: venue.categories.first?.name ?? "", imageURL: nil, imagePlaceholder: "restraunt-placeholder")
    }
    
    func buildRatingTableViewCellViewData() -> RatingTableViewCell.ViewData? {
        guard let viewData = viewData else { return nil }
        
        return RatingTableViewCell.ViewData(rating: viewData.venue.rating ?? 0.0, visitorsCount: Int(viewData.venue.stats?.visitsCount ?? 0), likesCount: viewData.venue.likes?.count ?? 0, checkInsCount: Int(viewData.venue.stats?.checkinsCount ?? 0), tipCount: viewData.venue.stats?.tipCount ?? 0)
        
    }
    
    func buildAddressTableViewCellViewData() -> AddressTableViewCell.ViewData? {
        guard let viewData = viewData else { return nil }
        
        let categories = viewData.venue.categories.map{$0.name}
        return AddressTableViewCell.ViewData(address: viewData.venue.location.address ?? "-", postCode: (viewData.venue.location.postalCode ?? "-") + (viewData.venue.location.city ?? "-"), hours: viewData.venue.hours?.status ?? "-", categories: categories.joined(separator: ", "))
    }
    
    func buildPhotoGalleryTableViewCellViewData() -> PhotoGalleryTableViewCell.ViewData? {
        guard let viewData = viewData, let groups = viewData.venue.photos?.groups, let photos = groups.first?.items else { return nil }

        return PhotoGalleryTableViewCell.ViewData(photos: photos)
    }
    
    func venueLocation() -> Location? {
        return viewData?.venue.location
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
                self.useCase.getVenueDetails(venueId: self.venue.id).subscribe { event in
                    if let venue = event.element?.venue, let category = venue.categories.first {
                        self.outputs.showVenueDetailsHeader.onNext(VenueDetailsTableStretchyHeader.ViewData(title: venue.name, description: category.name, imageURL: self.venuePhotoURL, imagePlaceholder: "restraunt-placeholder"))
                        self.viewData = VenueDetailsViewController.ViewData(venue: venue)
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
        
        inputs.showMap.subscribe(onNext: { [weak self] (type, location) in
            self?.mapURLHandler.openMap(location: location, type: type)
        }).disposed(by: disposeBag)
    }
}
