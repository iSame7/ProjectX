//
//  ActionTableViewCell.swift
//  Components
//
//  Created by Ramitha Wirasinha on 3/19/20.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit
import RxSwift

class ActionTableViewCell: UITableViewCell, Dequeueable {
    
    private let disposeBag = DisposeBag()
    
    private lazy var button = UIButton()
    
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

extension ActionTableViewCell: TableViewCellConfigurable {
    func configure(with model: TableViewCellItemPresentable) {
        button.setTitle(model.title, for: .normal)
        button.setTitleColor(DesignSystem.Colors.Palette.secondary600.color, for: .normal)
        button.setImage(IconFactory<UIImage>(icon: .plus).build() , for: .normal)
        button.tintColor = DesignSystem.Colors.Palette.secondary600.color
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        button.titleLabel?.font = Font(type: .body(.medium)).instance
        separatorView.isHidden = !model.hasSeparator
        
        guard let actionButtonListener = model.actionListener else {
            button.isUserInteractionEnabled = false
            return
        }
        
        button.rx.tap.bind(to: actionButtonListener).disposed(by: disposeBag)
    }
}

// MARK: - Setup UI

private extension ActionTableViewCell {
    func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(button)
        addSubview(separatorView)
    }
    
    func setupConstraints() {
        button.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            button.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            button.leftAnchor.constraint(equalTo: leftAnchor, constant: 24),
            button.rightAnchor.constraint(equalTo: rightAnchor, constant: -28),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            separatorView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
