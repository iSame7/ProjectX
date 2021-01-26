//
//  FiltersTableViewCell.swift
//  Filters
//
//  Created by Sameh Mabrouk on 09/02/2020.
//  Copyright © 2020 Sameh Mabrouk. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell, Dequeueable {
    
    private lazy var title: Label = {
        LabelFactory(style: .bodyRegular)
            .textColor(with: DesignSystem.Colors.Palette.brandBlack.color)
            .textAlignment(.left)
            .build()
    }()
    
    private lazy var subtitle: Label = {
        LabelFactory(style: .bodyRegular)
            .textColor(with: DesignSystem.Colors.Palette.gray700.color)
            .textAlignment(.right)
            .build()
    }()
    
    private lazy var chevron: UIImageView = {
        ImageViewFactory(with: IconFactory(icon: .chevron).build())
            .imageColor(color: DesignSystem.Colors.Palette.gray400.color)
            .contentMode(contentMode: .center)
            .build()
    }()
    
    private lazy var separatorView: Separator = {
        SeparatorFactory()
            .setColor(DesignSystem.Colors.Palette.brandWhite.color)
            .build()
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

extension FilterTableViewCell: TableViewCellConfigurable {
    func configure(with model: TableViewCellItemPresentable) {
        title.text = model.title
        subtitle.isHidden = (model.subtitle?.isEmpty ?? false)
        subtitle.text = model.subtitle
        subtitle.textColor = (model.subtitle?.contains("0") == false) ? DesignSystem.Colors.Palette.brandBlack.color : DesignSystem.Colors.Palette.gray700.color
        backgroundCorner = model.backgroundCorner
        separatorView.isHidden = !model.hasSeparator
    }
}

// MARK: - Setup UI

private extension FilterTableViewCell {
    func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        background.addSubview(title)
        background.addSubview(subtitle)
        background.addSubview(chevron)
        addSubview(background)
        addSubview(separatorView)
    }
    
    func setupConstraints() {
        background.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        chevron.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            background.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            background.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            background.topAnchor.constraint(equalTo: topAnchor),
            background.heightAnchor.constraint(equalToConstant: 56),
            background.bottomAnchor.constraint(equalTo: bottomAnchor),
            title.centerYAnchor.constraint(equalTo: background.centerYAnchor),
            title.leadingAnchor.constraint(equalTo: background.leadingAnchor, constant: 16),
            title.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            subtitle.centerYAnchor.constraint(equalTo: centerYAnchor),
            subtitle.widthAnchor.constraint(equalToConstant: 104),
            subtitle.rightAnchor.constraint(equalTo: background.rightAnchor, constant: -48),
            chevron.widthAnchor.constraint(equalToConstant: 24),
            chevron.heightAnchor.constraint(equalToConstant: 24),
            chevron.trailingAnchor.constraint(equalTo: background.trailingAnchor, constant: -16),
            chevron.centerYAnchor.constraint(equalTo: centerYAnchor),            
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
