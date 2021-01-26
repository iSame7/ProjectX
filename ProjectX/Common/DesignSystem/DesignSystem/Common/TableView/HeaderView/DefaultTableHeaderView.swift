//
//  TemperDefaultTableHeaderView.swift
//  Filters
//
//  Created by Sameh Mabrouk on 10/02/2020.
//  Copyright © 2020 Sameh Mabrouk. All rights reserved.
//

import UIKit

class DefaultTableHeaderView: UITableViewHeaderFooterView {
    
    private lazy var title: Label = {
        LabelFactory(style: .subtitleMedium)
            .textColor(with: DesignSystem.Colors.Palette.brandBlack.color)
            .textAlignment(.left)
            .numberOf(lines: 0)
            .build()
    }()
    
    private lazy var subtitle: Label = {
        LabelFactory(style: .bodyRegular)
            .textColor(with: DesignSystem.Colors.Palette.gray700.color)
            .textAlignment(.left)
            .numberOf(lines: 0)
            .build()
    }()
    
    private lazy var titleBottomAnchorConstraint: NSLayoutConstraint = {
        title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        subtitle.removeFromSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with text: String, subtitleText: String? = nil, font: UIFont?) {
        title.text = text
        
        if let subtitleText = subtitleText, !subtitleText.isEmpty {
            subtitle.text = subtitleText
            setupSubTitle()
            setupSubtitleConstraints()
        }
        
        guard let font = font else { return }
        title.font = font
    }
    
    func configure(with text: String, labelStyle: Label.Style, textColor: UIColor) {
        title.text = text
        title.setStyle(style: labelStyle)
        title.textColor = textColor
    }

    func setupUI() {
        contentView.backgroundColor = DesignSystem.Colors.Palette.brandWhite.color
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        contentView.addSubview(title)
    }
    
    func setupSubTitle() {
        contentView.addSubview(subtitle)
    }
    
    func setupConstraints() {
        title.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleBottomAnchorConstraint
        ])
    }
    
    func setupSubtitleConstraints(){
        subtitle.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.deactivate([titleBottomAnchorConstraint])
        NSLayoutConstraint.activate([
            subtitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 8),
            subtitle.leadingAnchor.constraint(equalTo: title.leadingAnchor),
            subtitle.trailingAnchor.constraint(equalTo: title.trailingAnchor),
            subtitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
}
