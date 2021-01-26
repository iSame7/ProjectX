//
//  FilterCategoryViewController.swift
//  Filters
//
//  Created by Sameh Mabrouk on 10/02/2020.
//  Copyright © 2020 Sameh Mabrouk. All rights reserved.
//

import UIKit
import DesignSystem
import RxSwift

public class FilterCategoryViewController: TableViewController<FilterCategoryViewModel> {
    
    private let _bottomView = CategoryFilterFooterView()
    private let disposePage = DisposeBag()
    
    override public var bottomView: UIView {
        return _bottomView
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        title = viewModel.title
        
        addBackButton()
    }
    
    public override func setupObservers() {
        super.setupObservers()
        viewModel.didSelectAll.subscribe(onNext: { [weak self] in
            self?.reloadData()
        }).disposed(by: disposePage)
        
        viewModel.didDeselectAll.subscribe(onNext: { [weak self] in
            self?.reloadData()
        }).disposed(by: disposePage)
        
        _bottomView.setSelectAllButtonAction(observer: viewModel.didTapSelectAll)
        _bottomView.setDeselectAllButtonAction(observer: viewModel.didTapDeselectAll)
    }
    
    public override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        
        if parent == navigationController?.parent {
            viewModel.didDismissFilterCategory.onNext(())
        }
    }
}
