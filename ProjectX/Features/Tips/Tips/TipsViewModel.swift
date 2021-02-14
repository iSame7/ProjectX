//
//  TipsViewModel.swift
//  Tips
//
//  Created Sameh Mabrouk on 14/02/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import RxSwift
import Utils

protocol TipsViewModellable: class {
    var disposeBag: DisposeBag { get }
    var inputs: TipsViewModelInputs { get }
    var outputs: TipsViewModelOutputs { get }
}

struct TipsViewModelInputs {}

struct TipsViewModelOutputs {}

class TipsViewModel: TipsViewModellable {

    let disposeBag = DisposeBag()
    let inputs = TipsViewModelInputs()
    let outputs = TipsViewModelOutputs()
    var useCase: TipsInteractable

    init(useCase: TipsInteractable) {
        self.useCase = useCase
    }
}

// MARK: - Observables

private extension TipsViewModel {

    func setupObservables() {}
}
