//
//  TableFooterView.swift
//  Filters
//
//  Created by Sameh Mabrouk on 10/02/2020.
//  Copyright © 2020 Sameh Mabrouk. All rights reserved.
//

import UIKit
import DesignSystem
import RxSwift
import Utils

public class FilterTableFooterView: UIView {
    
    private var disposeBag = DisposeBag()
    
    private lazy var resetButton: Button = {
        return ButtonFactory(title: Localize.Filters.Button.resetFilters, style: .secondary(contentHorizontalAlignment: .left))
            .build()
    }()
    
    private lazy var applyButton: Button = {
        return ButtonFactory(title: Localize.Filters.Button.apply, style: .primary)
            .cornerRadius(of: 5.0)
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
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setResetButtonAction(observer: PublishSubject<Void>) {
        resetButton.rx.tap.bind(onNext: { _ in
            observer.onNext(())
        }).disposed(by: disposeBag)
    }
    
    func setApplyButtonAction(observer: PublishSubject<Void>) {
        applyButton.rx.tap.bind(onNext: { _ in
            observer.onNext(())
        }).disposed(by: disposeBag)
    }
}

// MARK: - Setup UI

private extension FilterTableFooterView {
    func setupUI() {
        backgroundColor = DesignSystem.Colors.Palette.brandWhite.color
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(separatorView)
        addSubview(resetButton)
        addSubview(applyButton)
    }
    
    func setupConstraints() {
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        applyButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.topAnchor.constraint(equalTo: topAnchor),
            resetButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            resetButton.widthAnchor.constraint(equalToConstant: 170),
            resetButton.topAnchor.constraint(equalTo: topAnchor, constant: 19),
            applyButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            applyButton.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            applyButton.heightAnchor.constraint(equalToConstant: 48),
            applyButton.widthAnchor.constraint(equalToConstant: 164),
            applyButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            resetButton.centerYAnchor.constraint(equalTo: applyButton.centerYAnchor)
        ])
    }
}
