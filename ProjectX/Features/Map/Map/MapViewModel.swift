//
//  MapViewModel.swift
//  Map
//
//  Created Sameh Mabrouk on 27/01/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import RxSwift
import Utils

protocol MapViewModellable: class {
    var disposeBag: DisposeBag { get }
    var inputs: MapViewModelInputs { get }
    var outputs: MapViewModelOutputs { get }
}

struct MapViewModelInputs {}

struct MapViewModelOutputs {}

class MapViewModel: MapViewModellable {

    let disposeBag = DisposeBag()
    let inputs = MapViewModelInputs()
    let outputs = MapViewModelOutputs()
    var useCase: MapInteractable

    init(useCase: MapInteractable) {
        self.useCase = useCase
    }
}

// MARK: - Observables

private extension MapViewModel {

    func setupObservables() {}
}
