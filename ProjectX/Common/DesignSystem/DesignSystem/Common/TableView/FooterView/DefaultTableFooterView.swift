//
//  DefaultTableFooterView.swift
//  Components
//
//  Created by Sameh Mabrouk on 14/09/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit

public protocol CutomTableViewFooterViewable: UIView {}

class DefaultTableFooterView: UITableViewHeaderFooterView {
    
    private var customView: CutomTableViewFooterViewable?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(view: CutomTableViewFooterViewable) {
        contentView.subviews.forEach { $0.removeFromSuperview() }
        
        customView = view
        contentView.addSubview(view)
        setNeedsLayout()
        setupConstraints()
    }

    func setupUI() {
//        contentView.backgroundColor = DesignSystem.Colors.Palette.brandWhite.color
    }

    func setupConstraints(){
        guard let customView = customView else { return }
        
        customView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customView.heightAnchor.constraint(equalTo: heightAnchor),
            customView.widthAnchor.constraint(equalTo: widthAnchor),
            customView.centerYAnchor.constraint(equalTo: centerYAnchor),
            customView.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
}
