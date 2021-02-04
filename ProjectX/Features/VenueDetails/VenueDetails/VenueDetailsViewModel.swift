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

protocol VenueDetailsViewModellable: ViewModellable {
    var disposeBag: DisposeBag { get }
    var inputs: VenueDetailsViewModelInputs { get }
    var outputs: VenueDetailsViewModelOutputs { get }
}

struct VenueDetailsViewModelInputs {}

struct VenueDetailsViewModelOutputs {}

class VenueDetailsViewModel: VenueDetailsViewModellable {

    let disposeBag = DisposeBag()
    let inputs = VenueDetailsViewModelInputs()
    let outputs = VenueDetailsViewModelOutputs()
    var useCase: VenueDetailsInteractable

    init(useCase: VenueDetailsInteractable) {
        self.useCase = useCase
    }
}

// MARK: - Observables

private extension VenueDetailsViewModel {

    func setupObservables() {}
}
