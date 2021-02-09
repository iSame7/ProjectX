//
//  BookTableViewCell.swift
//  VenueDetails
//
//  Created by Sameh Mabrouk on 09/02/2021.
//

import UIKit
import DesignSystem

class RatingTableViewCell: UITableViewCell {
    
    struct ViewData {
        let rating: Double
        let visitorsCount: Int
        let likesCount: Int
        let checkInsCount: Int
        let tipCount: Int
    }
    
    // MARK: - Properties
    
    lazy var titleLabel: Label = {
        let label: Label = LabelFactory().textAlignment(.left).style(style: .footNoteMedium).textColor(with: DesignSystem.Colors.Palette.gray200.color).build()
        label.text = "RATING"
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var descriptionLabel: Label = {
        let label: Label = LabelFactory().textAlignment(.left).style(style: .footNoteMedium).textColor(with: DesignSystem.Colors.Palette.gray700.color).build()
        label.numberOfLines = 0
        
        return label
    }()

    private lazy var ratingView: UIView = {
        UIView()
    }()
    
    private lazy var ratingLabel: Label = {
        let label: Label = LabelFactory().textAlignment(.center).style(style: .subtitleBold).textColor(with: DesignSystem.Colors.Palette.orange500.color).build()
        label.numberOfLines = 0
        label.text = "9.5"
        
        return label
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 0
        
        return stackView
    }()
    
    private lazy var likesRatingProgressView: RatingProgressView = RatingProgressView(frame: .zero)
    
    private lazy var tipsRatingProgressView: RatingProgressView = RatingProgressView(frame: .zero)
    
    private lazy var checkInRatingProgressView: RatingProgressView = RatingProgressView(frame: .zero)
    
    private let ratingCircleWidth = CGFloat(100.0)
    private let ratingCircleHeight = CGFloat(100.0)
    
    // MARK: - Initalizers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(viewData: ViewData) {
        let ratingCircleViewWidth = ratingView.frame.width
        let ratingCircleViewHeight = ratingView.frame.height
        let circleView = RatingCircleView(frame: CGRect(x: ratingCircleViewWidth + 20, y: ratingCircleViewHeight + 5, width: ratingCircleWidth, height: ratingCircleHeight), rating: Double(viewData.rating * 10))
        ratingView.addSubview(circleView)
        circleView.animateCircle(duration: 1.0)

        ratingLabel.text = String(viewData.rating)
        descriptionLabel.text = "Rated \(viewData.rating) out of 10 based on \(viewData.visitorsCount > 0 ? String(viewData.visitorsCount) : "-") visitor"
        
        let likesPercentage = Double(viewData.likesCount) / Double(viewData.visitorsCount) * 100
        let tipsPercentage = Double(viewData.tipCount) / Double(viewData.visitorsCount) * 100
        let checkInPercentage = Double(viewData.checkInsCount) / Double(viewData.visitorsCount) * 100

        likesRatingProgressView.setup(title: viewData.likesCount > 0 && viewData.visitorsCount > 0 ? String(likesPercentage) + "% likes" : "- % likes", progress: Float(likesPercentage/100))
        tipsRatingProgressView.setup(title: viewData.tipCount > 0 && viewData.visitorsCount > 0 ? String(tipsPercentage) + "% tips" : "- % tips", progress: Float(tipsPercentage/100))
        checkInRatingProgressView.setup(title: viewData.checkInsCount > 0 ? String(checkInPercentage) + "% Check in" : "- % Check in", progress: Float(checkInPercentage/100))
    }
}

// MARK: - Setup UI

private extension RatingTableViewCell {
    
    func setupUI() {
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        ratingView.addSubview(ratingLabel)
        contentView.addSubview(ratingView)
        
        stackView.addArrangedSubview(likesRatingProgressView)
        stackView.addArrangedSubview(tipsRatingProgressView)
        stackView.addArrangedSubview(checkInRatingProgressView)
        
        contentView.addSubview(stackView)
    }
    
    func setupConstraints() {
        let marginGuide = contentView.layoutMarginsGuide
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            titleLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            descriptionLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            
            ratingView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            ratingView.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor),
            ratingView.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor, constant: -200),
            ratingView.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor),
            ratingView.heightAnchor.constraint(equalToConstant: 112),
            
            ratingLabel.centerXAnchor.constraint(equalTo: ratingView.centerXAnchor),
            ratingLabel.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
            
            stackView.leftAnchor.constraint(equalTo: ratingView.rightAnchor, constant: 50),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            stackView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10)
        ])
    }
}
