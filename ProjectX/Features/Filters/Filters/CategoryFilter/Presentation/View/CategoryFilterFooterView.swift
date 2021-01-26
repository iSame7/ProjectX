//
//  CategoryFilterFooterView.swift
//  Filters
//
//  Created by Sameh Mabrouk on 11/02/2020.
//  Copyright © 2020 Sameh Mabrouk. All rights reserved.
//

import UIKit
import DesignSystem
import RxSwift
import Utils

public class CategoryFilterFooterView: UIView {
    
    private var disposeBag = DisposeBag()
    
    private lazy var deselectAllButton: Button = {
        return ButtonFactory(title: Localize.FilterCategories.Button.deselectAll, style: .secondary(contentHorizontalAlignment: .left))
            .build()
    }()
    
    private lazy var selectAllButton: Button = {
        return ButtonFactory(title: Localize.FilterCategories.Button.selectAll, style: .secondary(contentHorizontalAlignment: .right))
            .build()
    }()
    
    private lazy var separatorView: Separator = {
        SeparatorFactory()
            .setColor(DesignSystem.Colors.Palette.gray200.color)
            .build()
    }()
    
    init() {
        super.init(frame: .zero)
        
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    public func setSelectAllButtonAction(observer: PublishSubject<Void>) {
        selectAllButton.rx.tap.bind(onNext: { _ in
            observer.onNext(())
        }).disposed(by: disposeBag)
    }
    
    public func setDeselectAllButtonAction(observer: PublishSubject<Void>) {
        deselectAllButton.rx.tap.bind(onNext: { _ in
            observer.onNext(())
        }).disposed(by: disposeBag)
    }
}

// MARK: - Setup UI

private extension CategoryFilterFooterView {
    func setupUI() {
        backgroundColor = DesignSystem.Colors.Palette.brandWhite.color
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(separatorView)
        addSubview(deselectAllButton)
        addSubview(selectAllButton)
    }
    
    func setupConstraints() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        deselectAllButton.translatesAutoresizingMaskIntoConstraints = false
        selectAllButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.topAnchor.constraint(equalTo: topAnchor),
            deselectAllButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            deselectAllButton.widthAnchor.constraint(equalToConstant: 170),
            deselectAllButton.topAnchor.constraint(equalTo: topAnchor, constant: 13),
            deselectAllButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -49),
            selectAllButton.leftAnchor.constraint(equalTo: deselectAllButton.rightAnchor, constant: 20),
            selectAllButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            selectAllButton.topAnchor.constraint(equalTo: topAnchor, constant: 13),
            selectAllButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -49)
        ])
    }
}
