//
//  CustomCell.swift
//  Components
//
//  Created by Sameh Mabrouk on 22/03/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell, Dequeueable {
    
    private var customCellView: CustomTableViewCellViewable?
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    func configure(view: CustomTableViewCellViewable) {
        removeExistingSubviews()
        addSubview(view)
        setNeedsLayout()
        customCellView = view
        setupConstraints()
    }
}

// MARK: - TableViewCellConfigurable

extension CustomTableViewCell: TableViewCellConfigurable {
    func configure(with model: TableViewCellItemPresentable) {
        customCellView?.configure(with: model)
    }
}

private extension CustomTableViewCell {
    func setupUI() {
        selectionStyle = .none
    }
}

private extension CustomTableViewCell {
    func setupConstraints(){
        guard let customCellView = customCellView else { return }
        
        customCellView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customCellView.heightAnchor.constraint(equalTo: heightAnchor, constant: -2),
            customCellView.widthAnchor.constraint(equalTo: widthAnchor, constant: -40),
            customCellView.centerYAnchor.constraint(equalTo: centerYAnchor),
            customCellView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func removeExistingSubviews() {
        subviews.forEach { $0.removeFromSuperview() }
    }
}
