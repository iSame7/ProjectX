//
//  SelectorCell.swift
//  Components
//
//  Created by Sameh Mabrouk on 10/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit

public enum CellSelectionStyle {
    case checkMark
    case checkBox
}

class MultipleSelectorCell: UITableViewCell, Dequeueable {
    private lazy var title: Label = {
        LabelFactory(style: .bodyRegular)
            .textColor(with: DesignSystem.Colors.Palette.brandBlack.color)
            .textAlignment(.left)
            .build()
    }()
    
    private lazy var checkmark: UIImageView = {
        ImageViewFactory(with: IconFactory(icon: .checkmark).build())
            .contentMode(contentMode: .center)
            .build()
    }()
    
    private lazy var checkBox: UIImageView = {
        ImageViewFactory(with: IconFactory(icon: .checkBoxChecked).build())
            .contentMode(contentMode: .center)
            .build()
    }()
    
    private lazy var separatorView: Separator = {
        SeparatorFactory()
            .build()
    }()
    
    private lazy var containerView = UIView()
    private var cellSelectionStyle = CellSelectionStyle.checkMark
    private var containerViewPadding: CGFloat = 0
    public var backgroundCorner: ItemBackgroundCorner?
        
    required init?(coder: NSCoder) {
        preconditionFailure("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.setupBackgroundCorner(corner: backgroundCorner ?? .none)
    }
}

// MARK: - TableViewCellConfigurable

extension MultipleSelectorCell: TableViewCellConfigurable {
    func configure(with model: TableViewCellItemPresentable) {
        containerView.setupBackgroundCorner(corner: model.backgroundCorner ?? .none)
        title.text = model.title
        title.textColor = model.isChecked && cellSelectionStyle == .checkMark ? DesignSystem.Colors.Palette.secondary500.color : DesignSystem.Colors.Palette.brandBlack.color
        cellSelectionStyle = model.cellSelectionStyle
        checkmark.isHidden = !model.isChecked || cellSelectionStyle != .checkMark
        checkBox.isHidden = cellSelectionStyle != .checkBox
        checkBox.image = model.isChecked ? IconFactory(icon: .checkBoxChecked).build() : IconFactory(icon: .checkBoxUnchecked).build()
        handleSelectionStyle(model.cellSelectionStyle)
        backgroundCorner = model.backgroundCorner
        setupConstraints()
    }
}

// MARK: - Setup UI

private extension MultipleSelectorCell {
    func handleSelectionStyle(_ selectionStyle: CellSelectionStyle) {
        switch selectionStyle {
        case .checkMark:
            containerView.backgroundColor = DesignSystem.Colors.Palette.brandWhite.color
            containerViewPadding = 0
        case .checkBox:
            containerView.backgroundColor = DesignSystem.Colors.Palette.gray100.color
            containerViewPadding = 40
            separatorView.backgroundColor = DesignSystem.Colors.Palette.brandWhite.color
        }
    }
    
    func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        setupSubviews()
    }
    
    func setupSubviews() {
        addSubview(containerView)
        containerView.addSubview(title)
        containerView.addSubview(checkmark)
        containerView.addSubview(separatorView)
        containerView.addSubview(checkBox)
    }
    
    func setupConstraints() {
        title.translatesAutoresizingMaskIntoConstraints = false
        checkmark.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabelLeftAnchor = cellSelectionStyle == .checkBox ? checkBox.rightAnchor : leftAnchor
        
        NSLayoutConstraint.activate([
            containerView.heightAnchor.constraint(equalTo: heightAnchor),
            containerView.widthAnchor.constraint(equalTo: widthAnchor, constant: -containerViewPadding),
            containerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            checkBox.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 20),
            checkBox.widthAnchor.constraint(equalToConstant: 24),
            checkBox.heightAnchor.constraint(equalToConstant: 24),
            checkBox.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            title.leftAnchor.constraint(equalTo: titleLabelLeftAnchor, constant: 20),
            title.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -40),
            title.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 17.5),
            title.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            checkmark.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -20),
            checkmark.widthAnchor.constraint(equalToConstant: 24),
            checkmark.heightAnchor.constraint(equalToConstant: 24),
            checkmark.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            separatorView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            separatorView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        ])
    }
}
