//
//  NoResultsCell.swift
//  ShiftOverview
//
//  Created by Sameh Mabrouk on 15/02/2020.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit
import DesignSystem
import RxSwift
import Utils

class NoResultsCell: UITableViewCell {
    
    public var data: EmptyStateable? {
        didSet {
            setViewData()
        }
    }
    
    lazy open var titleLabel: Label = {
        LabelFactory(text: Localize.ShiftOverview.Table.Cell.noResult.thereAreNoShiftsAvailable, style: .subtitleMedium)
            .textAlignment(.center)
            .textColor(with: DesignSystem.Colors.Palette.brandBlack.color)
            .build()
    }()
    
    lazy open var bodyLabel: Label = {
        let label = LabelFactory<Label>(text: Localize.ShiftOverview.Table.Cell.noResult.doYouWantToBeKeptInformedByEmail, style: .bodyRegular)
            .textAlignment(.center)
            .textColor(with: DesignSystem.Colors.Palette.gray700.color)
            .build()
        
        label.numberOfLines = 2
        
        return label
    }()
    
    lazy open var subscribeToWorkOnDayButton: Button = {
        let button = ButtonFactory<Button>(title: Localize.ShiftOverview.Table.Cell.noResult.keepMeUpdated, style: .custom)
            .backgroundColor(with: .clear)
            .font(of: Font(type: .body(.medium)))
            .titleColor(with: DesignSystem.Colors.Palette.secondary500.color, for: .normal)
            .build()
        
        button.setImage(IconFactory<UIImage>(icon: .bell).build().withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = DesignSystem.Colors.Palette.secondary500.color
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)

        button.isUserInteractionEnabled = false
        
        return button
    }()

    lazy open var roundedBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = DesignSystem.Colors.Palette.gray100.color
        
        view.layer.cornerRadius = 8.0
        view.clipsToBounds = true
        
        return view
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
    
    open func setupUI() {        
        roundedBackgroundView.addSubview(titleLabel)
        roundedBackgroundView.addSubview(bodyLabel)
        roundedBackgroundView.addSubview(subscribeToWorkOnDayButton)
        contentView.addSubview(roundedBackgroundView)
        selectionStyle = .none
    }

    open func setupConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        bodyLabel.translatesAutoresizingMaskIntoConstraints = false
        subscribeToWorkOnDayButton.translatesAutoresizingMaskIntoConstraints = false
        roundedBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            roundedBackgroundView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 40),
            roundedBackgroundView.heightAnchor.constraint(equalToConstant: 164),
            roundedBackgroundView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            roundedBackgroundView.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            roundedBackgroundView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            
            titleLabel.topAnchor.constraint(equalTo: roundedBackgroundView.topAnchor, constant: 24),
            titleLabel.leftAnchor.constraint(equalTo: roundedBackgroundView.leftAnchor, constant: 16),
            titleLabel.rightAnchor.constraint(equalTo: roundedBackgroundView.rightAnchor, constant: -16),
            titleLabel.heightAnchor.constraint(equalToConstant: 24),
            
            bodyLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            bodyLabel.leftAnchor.constraint(equalTo: roundedBackgroundView.leftAnchor, constant: 16),
            bodyLabel.rightAnchor.constraint(equalTo: roundedBackgroundView.rightAnchor, constant: -16),
            
            subscribeToWorkOnDayButton.topAnchor.constraint(equalTo: bodyLabel.bottomAnchor, constant: 12),
            subscribeToWorkOnDayButton.bottomAnchor.constraint(equalTo: roundedBackgroundView.bottomAnchor, constant: -30),
            subscribeToWorkOnDayButton.leftAnchor.constraint(equalTo: roundedBackgroundView.leftAnchor, constant: 16),
            subscribeToWorkOnDayButton.rightAnchor.constraint(equalTo: roundedBackgroundView.rightAnchor, constant: -16),
        ])
    }
    
    open func setViewData() {
        guard let guardedData = data else { return }
        
        let isSubscribed = (guardedData.isSubscribed ?? false)
        
        subscribeToWorkOnDayButton.setTitle(isSubscribed ? Localize.ShiftOverview.Table.Cell.noResult.stopUpdatingMe : Localize.ShiftOverview.Table.Cell.noResult.keepMeUpdated, for: .normal)
        
        subscribeToWorkOnDayButton.setImage(IconFactory<UIImage>(icon: isSubscribed ? .bellOff : .bell).build().withRenderingMode(.alwaysTemplate), for: .normal)
        
        subscribeToWorkOnDayButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: isSubscribed ? 14 : 16)
    }
    
    override open func prepareForReuse() {
        super.prepareForReuse()
        
        data = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
}
