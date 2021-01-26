//
//  IconTextTableViewCell.swift
//  Components
//
//  Created by Sameh Mabrouk on 08/09/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit

public class IconTextTableViewCell: UITableViewCell, TableViewCellConfigurable, Dequeueable {
    
    private lazy var iconView = {
        ImageViewFactory<UIImageView>()
            .imageColor(color: DesignSystem.Colors.Palette.secondary500.color)
            .contentMode(contentMode: .center)
            .build()
    }()
    
    private lazy var label = {
        LabelFactory<Label>(style: .bodyRegular)
            .textColor(with:DesignSystem.Colors.Palette.brandBlack.color)
            .numberOf(lines: 0)
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
            .setColor(DesignSystem.Colors.Palette.gray200.color)
            .build()
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with model: TableViewCellItemPresentable) {
        guard let icon = model.icon else { return }
        
        iconView.image = IconFactory(icon: icon).build()
        label.text = model.title
        
        layoutIfNeeded()
    }
}

// MARK: - Setup UI

private extension IconTextTableViewCell {
    
    func setupUI() {
        selectionStyle = .none
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(iconView)
        addSubview(label)
        addSubview(chevron)
        addSubview(separatorView)
    }
    
    func setupConstraints() {
        chevron.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            iconView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            iconView.widthAnchor.constraint(equalToConstant: 24),
            iconView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            
            label.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            label.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -16),
            
            chevron.widthAnchor.constraint(equalToConstant: 24),
            chevron.heightAnchor.constraint(equalToConstant: 24),
            chevron.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            chevron.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            separatorView.topAnchor.constraint(equalTo: iconView.bottomAnchor, constant: 16),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
