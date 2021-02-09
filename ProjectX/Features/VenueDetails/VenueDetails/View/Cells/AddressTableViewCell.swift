//
//  AddressTableViewCell.swift
//  VenueDetails
//
//  Created by Sameh Mabrouk on 09/02/2021.
//

import UIKit
import DesignSystem

class AddressTableViewCell: UITableViewCell {
    
    struct ViewData {
        let address: String
        let postCode: String
        let hours: String
        let categories: String
    }
    
    // MARK: - Properties

    private lazy var addressStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 0
        
        return stackView
    }()
        
    lazy var addressHeaderLabel: Label = {
        let label: Label = LabelFactory().textAlignment(.left).style(style: .footNoteMedium).textColor(with: DesignSystem.Colors.Palette.gray200.color).build()
        label.text = "ADDRESS"
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var addressLabel: Label = {
        let label: Label = LabelFactory().textAlignment(.left).style(style: .footNoteMedium).textColor(with: DesignSystem.Colors.Palette.gray700.color).build()
        label.text = "Dijksgracht 4"
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var postCodeLabel: Label = {
        let label: Label = LabelFactory().textAlignment(.left).style(style: .footNoteMedium).textColor(with: DesignSystem.Colors.Palette.gray700.color).build()
        label.text = "1019 BS Amsterdam"
        label.numberOfLines = 0
        
        return label
    }()
    
    let addressSeparatorView = SeparatorFactory<Separator>().setColor(DesignSystem.Colors.Palette.gray900.color).build()

    private lazy var hoursStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 0
        
        return stackView
    }()
    
    lazy var hoursHeaderLabel: Label = {
        let label: Label = LabelFactory().textAlignment(.left).style(style: .footNoteMedium).textColor(with: DesignSystem.Colors.Palette.gray200.color).build()
        label.text = "HOURS"
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var hoursLabel: Label = {
        let label: Label = LabelFactory().textAlignment(.left).style(style: .footNoteMedium).textColor(with: DesignSystem.Colors.Palette.gray700.color).build()
        label.text = "Open Until 1 AM"
        label.numberOfLines = 0
        
        return label
    }()
    
    let hoursSeparatorView = SeparatorFactory<Separator>().setColor(DesignSystem.Colors.Palette.gray900.color).build()

    private lazy var categoriesStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 0
        
        return stackView
    }()
    
    lazy var categoriesHeaderLabel: Label = {
        let label: Label = LabelFactory().textAlignment(.left).style(style: .footNoteMedium).textColor(with: DesignSystem.Colors.Palette.gray200.color).build()
        label.text = "CATEGORIES"
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var categoriesLabel: Label = {
        let label: Label = LabelFactory().textAlignment(.left).style(style: .footNoteMedium).textColor(with: DesignSystem.Colors.Palette.gray700.color).build()
        label.text = "Restaurant, Bar"
        label.numberOfLines = 0
        
        return label
    }()
    
    // MARK: - Initalizers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with viewData: ViewData) {
        addressLabel.text = viewData.address
        postCodeLabel.text = viewData.postCode
        hoursLabel.text = viewData.hours
        categoriesLabel.text = viewData.categories
    }
}


// MARK: - Setup UI

private extension AddressTableViewCell {
    
    func setupUI() {
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addressStackView.addArrangedSubview(addressHeaderLabel)
        addressStackView.addArrangedSubview(addressLabel)
        addressStackView.addArrangedSubview(postCodeLabel)
        contentView.addSubview(addressStackView)
        contentView.addSubview(addressSeparatorView)
        
        hoursStackView.addArrangedSubview(hoursHeaderLabel)
        hoursStackView.addArrangedSubview(postCodeLabel)
        contentView.addSubview(hoursStackView)
        contentView.addSubview(hoursSeparatorView)
        
        categoriesStackView.addArrangedSubview(categoriesHeaderLabel)
        categoriesStackView.addArrangedSubview(categoriesLabel)
        contentView.addSubview(categoriesStackView)
    }
    
    func setupConstraints() {
        let marginGuide = contentView.layoutMarginsGuide
        
        addressStackView.translatesAutoresizingMaskIntoConstraints = false
        hoursStackView.translatesAutoresizingMaskIntoConstraints = false
        categoriesStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            addressStackView.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: 10),
            addressStackView.rightAnchor.constraint(equalTo: marginGuide.rightAnchor),
            addressStackView.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 5),
            
            addressSeparatorView.topAnchor.constraint(equalTo: addressStackView.bottomAnchor, constant: 5),
            addressSeparatorView.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: 10),
            addressSeparatorView.widthAnchor.constraint(equalToConstant: 150),

            hoursStackView.topAnchor.constraint(equalTo: addressStackView.bottomAnchor, constant: 10),
            hoursStackView.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: 10),
            hoursStackView.rightAnchor.constraint(equalTo: marginGuide.rightAnchor),
            
            hoursSeparatorView.topAnchor.constraint(equalTo: hoursStackView.bottomAnchor, constant: 5),
            hoursSeparatorView.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: 10),
            hoursSeparatorView.widthAnchor.constraint(equalToConstant: 150),
            
            categoriesStackView.topAnchor.constraint(equalTo: hoursStackView.bottomAnchor, constant: 10),
            categoriesStackView.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: 16),
            categoriesStackView.rightAnchor.constraint(equalTo: marginGuide.rightAnchor),
            categoriesStackView.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: -5),
        ])
    }
}
