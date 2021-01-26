//
//  LocationTableViewCell.swift
//  DesignSystem
//
//  Created by Sameh Mabrouk on 13/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell, Dequeueable {
    private lazy var icon: UIImageView = {
        return ImageViewFactory(with: IconFactory(icon: .location).build())
            .contentMode(contentMode: .center)
            .build()
    }()
    
    private lazy var title: Label = {
        LabelFactory(style: .bodyRegular)
            .textColor(with: DesignSystem.Colors.Palette.brandBlack.color).textAlignment(.left)
            .build()
    }()
    
    private lazy var separatorView: Separator = {
        SeparatorFactory()
            .build()
    }()
    
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
}

// MARK: - TableViewCellConfigurable

extension LocationTableViewCell: TableViewCellConfigurable {
    func configure(with model: TableViewCellItemPresentable) {
        title.text = model.title
    }
}

// MARK: - Setup UI

private extension LocationTableViewCell {
    func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(icon)
        addSubview(title)
        addSubview(separatorView)
    }
    
    func setupConstraints() {
        icon.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            icon.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            icon.widthAnchor.constraint(equalToConstant: 24),
            icon.heightAnchor.constraint(equalToConstant: 24),
            title.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 16),
            title.heightAnchor.constraint(equalToConstant: 22),
            title.rightAnchor.constraint(equalTo: rightAnchor, constant: 28),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
