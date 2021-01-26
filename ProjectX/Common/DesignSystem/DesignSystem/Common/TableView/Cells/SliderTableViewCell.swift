//
//  LocationTableViewCell.swift
//  Filters
//
//  Created by Sameh Mabrouk on 10/02/2020.
//  Copyright © 2020 Sameh Mabrouk. All rights reserved.
//

import UIKit
import RxSwift

class SliderTableViewCell: UITableViewCell, Dequeueable {
    
    private let disposeBag = DisposeBag()
    
    private lazy var title: Label = {
        LabelFactory(style: .bodyRegular)
            .textColor(with: DesignSystem.Colors.Palette.brandBlack.color)
            .textAlignment(.left)
            .build()
    }()
    
    private lazy var details: Label = {
        LabelFactory(style: .bodyRegular)
            .textColor(with: DesignSystem.Colors.Palette.gray700.color)
            .textAlignment(.right)
            .build()
    }()
    
    private lazy var slider: UISlider = {
        SliderFactory().build()        
    }()
    
    private lazy var background: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = DesignSystem.Colors.Palette.gray100.color
        return backgroundView
    }()
    
    private var backgroundCorner: ItemBackgroundCorner?
    
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        background.setupBackgroundCorner(corner: backgroundCorner ?? .none)
    }
}

// MARK: - TableViewCellConfigurable

extension SliderTableViewCell: TableViewCellConfigurable {
    func configure(with model: TableViewCellItemPresentable) {
        title.text = model.title
        backgroundCorner = model.backgroundCorner
        details.text = model.subtitle
        slider.setValue(model.sliderValue ?? 40, animated: true)
        
        if let didChangeSliderValue = model.didChangeSliderValue {
            slider.rx.value
                .map { Int($0.rounded()) }
                .bind(to: didChangeSliderValue)
                .disposed(by: disposeBag)
        }
    }
}

// MARK: - Setup UI

private extension SliderTableViewCell {
    func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        
        slider.maximumValue = 100
        slider.minimumValue = 2
        slider.isContinuous = true
        
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        background.addSubview(title)
        background.addSubview(details)
        background.addSubview(slider)
        
        addSubview(background)
    }
    
    func setupConstraints() {
        background.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        details.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            background.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            background.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            background.topAnchor.constraint(equalTo: topAnchor),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),
            title.topAnchor.constraint(equalTo: background.topAnchor, constant: 17),
            title.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            details.centerYAnchor.constraint(equalTo: title.centerYAnchor),
            details.widthAnchor.constraint(equalToConstant: 100),
            details.rightAnchor.constraint(equalTo: background.rightAnchor, constant: -16),
            slider.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 9),
            slider.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            slider.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            slider.bottomAnchor.constraint(equalTo: background.bottomAnchor, constant: -10)
        ])
    }
}
