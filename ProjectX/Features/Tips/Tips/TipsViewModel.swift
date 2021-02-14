//
//  TipsViewModel.swift
//  Tips
//
//  Created Sameh Mabrouk on 14/02/2021.
//  Copyright © 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import RxSwift
import Utils
import Core
import DesignSystem
import FoursquareCore

protocol TipsViewModellable: ViewModellable {
    var disposeBag: DisposeBag { get }
    var inputs: TipsViewModelInputs { get }
    var outputs: TipsViewModelOutputs { get }
    
    func buildTableHeaderViewData() -> TableStretchyHeader.ViewData
    func buildTipTableCellViewData(userName: String, userImageURL: String?, createdAt: String, tipText: String) -> TipTableViewCell.ViewData
}

struct TipsViewModelInputs {
    var viewState = PublishSubject<ViewState>()
    var backButtonTapped = PublishSubject<Void>()
}

struct TipsViewModelOutputs {
    var showVenueDetailsHeader = PublishSubject<TableStretchyHeader.ViewData>()
    var showTips = PublishSubject<TipsViewController.ViewData>()
    var showVenueDetails = PublishSubject<Void>()
}

class TipsViewModel: TipsViewModellable {

    let disposeBag = DisposeBag()
    let inputs = TipsViewModelInputs()
    let outputs = TipsViewModelOutputs()
    
    private let tips: [TipItem]
    private let venuePhotoURL: String?
    
    init(tips: [TipItem], venuePhotoURL: String?) {
        self.tips = tips
        self.venuePhotoURL = venuePhotoURL
        
        setupObservables()
    }
    
    func buildTableHeaderViewData() -> TableStretchyHeader.ViewData {
        return TableStretchyHeader.ViewData(title: "", description: "", imageURL: nil, imagePlaceholder: "restraunt-placeholder")
    }
    
    func buildTipTableCellViewData(userName: String, userImageURL: String?, createdAt: String, tipText: String) -> TipTableViewCell.ViewData {
        return TipTableViewCell.ViewData(userName: userName, userImageURL: userImageURL, createdAt: createdAt, tipText: tipText)
    }
}

// MARK: - Observables

private extension TipsViewModel {

    func setupObservables() {
        observeInputs()
    }
    
    func observeInputs() {
        inputs.viewState.subscribe(onNext: { [weak self] state in
            guard let self = self else { return }
            
            switch state {
            case .loaded:
                self.outputs.showVenueDetailsHeader.onNext(TableStretchyHeader.ViewData(title: "Tips", description: "", imageURL: self.venuePhotoURL, imagePlaceholder: "restraunt-placeholder"))
                self.outputs.showTips.onNext(TipsViewController.ViewData(tips: self.tips))
            default:
                break
            }
        }).disposed(by: disposeBag)
        
        inputs.backButtonTapped.subscribe(onNext: { [weak self] in
            self?.outputs.showVenueDetails.onNext(())
        }).disposed(by: disposeBag)
    }
}
