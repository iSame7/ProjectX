//
//  DefaultTableViewCell.swift
//  Components
//
//  Created by Sameh Mabrouk on 16/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit

class DefaultTableViewCell: UITableViewCell, Dequeueable {
    
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
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
}

// MARK: - TableViewCellConfigurable

extension DefaultTableViewCell: TableViewCellConfigurable {
    func configure(with model: TableViewCellItemPresentable) {
        title.text = model.title
        title.textAlignment = model.textAlignment
        separatorView.isHidden = !model.hasSeparator
        if let font = model.titleFont {
            title.font = font
        }
        if let textColor = model.titleTextColor {
            title.textColor = textColor
        }
    }
}

// MARK: - Setup UI

private extension DefaultTableViewCell {
    func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(title)
        addSubview(separatorView)
    }
    
    func setupConstraints() {
        title.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.leftAnchor.constraint(equalTo: leftAnchor, constant: 24),
            title.heightAnchor.constraint(equalToConstant: 22),
            title.rightAnchor.constraint(equalTo: rightAnchor, constant: -28),
            title.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
