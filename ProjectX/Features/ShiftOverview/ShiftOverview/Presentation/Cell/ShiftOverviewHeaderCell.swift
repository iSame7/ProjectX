//
//  ShiftOverviewHeaderCell.swift
//  ShiftOverview
//
//  Created by Sameh Mabrouk on 13/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit
import DesignSystem

class ShiftOverviewHeaderCell: UITableViewCell {
    
    public var data: HeaderItem? {
        didSet {
            bindDataToView()
        }
    }

    public private(set) lazy var dateLabel: Label = {
        LabelFactory(style: .subtitleRegular)
            .textColor(with: DesignSystem.Colors.Palette.gray700.color)
            .build()
    }()
    
    required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupConstraints()
        layoutIfNeeded()
    }
    
    func setupUI() {
        selectionStyle = .none
        
        contentView.addSubview(dateLabel)
    }
    
    func setupConstraints() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            dateLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            dateLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20),
            dateLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 20),
            dateLabel.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    public func bindDataToView() {
        guard let guardedData = data else { return }
            
        dateLabel.text = guardedData.date
    }
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        
        data = nil
        dateLabel.text = ""
    }
}
