//
//  ShiftOverviewCell.swift
//  ShiftOverview
//
//  Created by Sameh Mabrouk on 1/23/20.
//  Copyright © 2020 Temper. All rights reserved.
//

import UIKit
import DesignSystem
import SkeletonView
import Nuke
import Utils

class ShiftOverviewCell: UITableViewCell {
    
    public var data: RegularShiftItem? {
        didSet {
            setViewData()
        }
    }
    lazy private var categorySectionStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .horizontal
        stackView.spacing = 4
        
        return stackView
    }()
    
    lazy private var categoryWithDistanceLabel: Label = {
        LabelFactory(text: "loading", style: .footNoteMedium)
            .textColor(with: DesignSystem.Colors.Palette.secondary500.color)
            .build()
    }()
    
    lazy private var highChanceView: UIView = {
        let view = UIView()
        view.backgroundColor = DesignSystem.Colors.Palette.secondary500.color
        view.layer.cornerRadius = 2
        
        return view
    }()
    
    lazy private var highChanceLabel: Label = {
        LabelFactory(text: Localize.ShiftOverview.Table.Cell.shiftoverview.highChance, style: .caption1Medium)
            .textColor(with: .white)
            .build()
    }()
    
    lazy private var jobTitleLabel: Label = {
        LabelFactory(text: "loading", style: .bodyMedium)
            .build()
    }()
    
    private lazy var flexpoolIcon: UIImageView = {
        return ImageViewFactory(with: IconFactory(icon: .flexpool).build())
            .imageColor(color: DesignSystem.Colors.Palette.gold500.color)
            .contentMode(contentMode: .center)
            .build()
    }()
    
    lazy private var startEndTimeLabel: Label = {
       LabelFactory(text: "loading", style: .footNoteRegular)
            .textColor(with: DesignSystem.Colors.Palette.gray700.color)
            .build()
    }()
    
    lazy private var earningsPerHourLabel: Label = {
        LabelFactory(text: "€,--", style: .bodyMedium)
            .textAlignment(.right)
            .build()
    }()
    
    lazy private var roundedImageView = {
        ImageViewFactory<UIImageView>(with: nil, frame: nil)
            .cornerRadius(of: CGFloat(8))
            .contentMode(contentMode: .scaleAspectFill)
            .build()
    }()
    
    lazy private var jobTitleView = UIView()
    
    lazy private var detailsStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    lazy private var layoutView: UIView = {
       UIView()
    }()
    
    lazy private var footerView: UIView = {
       UIView()
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
        setupConstraints()
        
        layoutIfNeeded()
        
        showLoading()
    }
    
    func setupUI() {
        categorySectionStackView.isSkeletonable = true
        jobTitleView.isSkeletonable = true
        detailsStackView.isSkeletonable = true
        startEndTimeLabel.isSkeletonable = true
        footerView.isSkeletonable = false
        earningsPerHourLabel.isSkeletonable = true
        layoutView.isSkeletonable = true
        roundedImageView.isSkeletonable = true

        selectionStyle = .none
        
        highChanceView.addSubview(highChanceLabel)
        
        categorySectionStackView.addArrangedSubview(highChanceView)
        categorySectionStackView.addArrangedSubview(categoryWithDistanceLabel)
        
        jobTitleView.addSubview(jobTitleLabel)
        jobTitleView.addSubview(flexpoolIcon)
        
        detailsStackView.addArrangedSubview(categorySectionStackView)
        detailsStackView.addArrangedSubview(jobTitleView)
        detailsStackView.addArrangedSubview(startEndTimeLabel)
        
        footerView.addSubview(detailsStackView)
        footerView.addSubview(earningsPerHourLabel)
        
        layoutView.addSubview(roundedImageView)
        layoutView.addSubview(footerView)
        
        contentView.addSubview(layoutView)
    }

    func setupConstraints() {
        highChanceLabel.translatesAutoresizingMaskIntoConstraints = false
        jobTitleView.translatesAutoresizingMaskIntoConstraints = false
        jobTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        flexpoolIcon.translatesAutoresizingMaskIntoConstraints = false
        
        layoutView.translatesAutoresizingMaskIntoConstraints = false
        roundedImageView.translatesAutoresizingMaskIntoConstraints = false
        footerView.translatesAutoresizingMaskIntoConstraints = false
        detailsStackView.translatesAutoresizingMaskIntoConstraints = false
        earningsPerHourLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            highChanceLabel.leftAnchor.constraint(equalTo: highChanceView.leftAnchor, constant: 4),
            highChanceLabel.rightAnchor.constraint(equalTo: highChanceView.rightAnchor, constant: -4),
            highChanceLabel.topAnchor.constraint(equalTo: highChanceView.topAnchor, constant: 2),
            highChanceLabel.bottomAnchor.constraint(equalTo: highChanceView.bottomAnchor, constant: -2),
            
            jobTitleLabel.leftAnchor.constraint(equalTo: jobTitleView.leftAnchor),
            jobTitleLabel.topAnchor.constraint(equalTo: jobTitleView.topAnchor),
            jobTitleLabel.bottomAnchor.constraint(equalTo: jobTitleView.bottomAnchor),
            flexpoolIcon.leftAnchor.constraint(equalTo: jobTitleLabel.rightAnchor),
            flexpoolIcon.topAnchor.constraint(equalTo: jobTitleView.topAnchor),
            flexpoolIcon.bottomAnchor.constraint(equalTo: jobTitleView.bottomAnchor),
            
            layoutView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.size.width - 40),
            layoutView.heightAnchor.constraint(equalToConstant: 264 + 16),
            layoutView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            layoutView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            roundedImageView.topAnchor.constraint(equalTo: layoutView.topAnchor, constant: 16),
            roundedImageView.leftAnchor.constraint(equalTo: layoutView.leftAnchor),
            roundedImageView.rightAnchor.constraint(equalTo: layoutView.rightAnchor),
            roundedImageView.heightAnchor.constraint(equalToConstant: 194),
            
            footerView.topAnchor.constraint(equalTo: roundedImageView.bottomAnchor, constant: 8),
            footerView.leftAnchor.constraint(equalTo: layoutView.leftAnchor),
            footerView.rightAnchor.constraint(equalTo: layoutView.rightAnchor),
            footerView.heightAnchor.constraint(equalToConstant: 62),
            
            detailsStackView.leftAnchor.constraint(equalTo: footerView.leftAnchor),
            detailsStackView.topAnchor.constraint(equalTo: footerView.topAnchor),
            detailsStackView.bottomAnchor.constraint(equalTo: footerView.bottomAnchor),
            detailsStackView.widthAnchor.constraint(equalTo: footerView.widthAnchor, multiplier: 0.75),

            earningsPerHourLabel.rightAnchor.constraint(equalTo: footerView.rightAnchor),
            earningsPerHourLabel.widthAnchor.constraint(equalToConstant: 75),
            earningsPerHourLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
        ])
    }
    
    public func showLoading() {
        categorySectionStackView.showAnimatedGradientSkeleton()
        startEndTimeLabel.showAnimatedGradientSkeleton()
        earningsPerHourLabel.showAnimatedGradientSkeleton()
        roundedImageView.showAnimatedGradientSkeleton()
        jobTitleView.showAnimatedGradientSkeleton()
    }
    
    public func stopLoading() {
        categorySectionStackView.hideSkeleton()
        startEndTimeLabel.hideSkeleton()
        earningsPerHourLabel.hideSkeleton()
        roundedImageView.hideSkeleton()
        jobTitleView.hideSkeleton()
    }
    
    private func setViewData() {
        guard let guardedData = data else { return }
        
        stopLoading()
        
        categoryWithDistanceLabel.text = "\(guardedData.category)"
        categoryWithDistanceLabel.text?.append(guardedData.category.isEmpty || guardedData.distance.isEmpty ? "" : " · ")
        categoryWithDistanceLabel.text?.append("\(guardedData.distance) KM")
        jobTitleLabel.text = guardedData.title
        startEndTimeLabel.text = guardedData.duration
        flexpoolIcon.isHidden = !guardedData.isAutoAcceptedWhenApplied
        highChanceView.isHidden = !guardedData.isHighChance
        
        earningsPerHourLabel.text = guardedData.earningsPerHour
        
        guard let url = URL(string: guardedData.imageUrl) else {
            return
        }
        
        Nuke.loadImage(with: url, into: roundedImageView)
    }
}
