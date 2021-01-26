//
//  FiltersViewController.swift
//  Filters
//
//  Created by Sameh Mabrouk on 06/02/2020.
//  Copyright © 2020 Sameh Mabrouk. All rights reserved.
//

import Foundation
import Core
import UIKit
import DesignSystem
import RxSwift
import Utils

public class FiltersViewController: TableViewController<FilterViewModel> {
    
    private let _bottomView = FilterTableFooterView()
    private let disposePage = DisposeBag()
    
    override public var bottomView: UIView {
        return _bottomView
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.title
        
        setupNavigationBar()
        
        addCloseBarButtonItem()
    }
    
    public override func setupObservers() {
        super.setupObservers()
        
        viewModel.didUpdateContent.subscribe(onNext: { [weak self] in
            self?.refreshData()
        }).disposed(by: disposePage)
        
        viewModel.didResetAll.subscribe(onNext: { [weak self] in
            self?.reloadData()
        }).disposed(by: disposePage)
                
        _bottomView.setResetButtonAction(observer: viewModel.didTapResetAll)
        _bottomView.setApplyButtonAction(observer: viewModel.didTapApplyButton)
    }
}

private extension FiltersViewController {
    func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage.imageWithColor(color: DesignSystem.Colors.Palette.brandWhite.color), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage.imageWithColor(color: DesignSystem.Colors.Palette.gray200.color)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Font(type: .subtitle(.medium)).instance, NSAttributedString.Key.foregroundColor: DesignSystem.Colors.Palette.brandBlack.color]
    }
}

// MARK: - CloseBarButtonActionHandling

extension FiltersViewController: CloseBarButtonActionHandling {
    public func closeButtonTapped() {
        viewModel.didTapClose.onNext(())
    }
}
