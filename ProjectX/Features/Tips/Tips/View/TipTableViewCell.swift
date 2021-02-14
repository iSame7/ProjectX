//
//  TipTableViewCell.swift
//  Tips
//
//  Created by Sameh Mabrouk on 14/02/2021.
//

import UIKit
import DesignSystem
import Nuke

class TipTableViewCell: UITableViewCell {
    
    struct ViewData {
        let userName: String
        let userImageURL: String?
        let createdAt: String
        let tipText: String
    }
    
    // MARK: - Properties
        
    static let reuseIdentifier = "TipTableViewCell"

    private lazy var userImageView: UIImageView = {
        let imageView: UIImageView = ImageViewFactory().build()
        imageView.image = IconFactory(icon: Icon.userPlaceholder).build()
        
        return imageView
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 5
        
        return stackView
    }()
    
    lazy var userNameLabel: Label = {
        let label: Label = LabelFactory().textAlignment(.left).style(style: .bodyBold).textColor(with: DesignSystem.Colors.Palette.gray400.color).build()
        label.text = "John Murphy"
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var createdAtLabel: Label = {
        let label: Label = LabelFactory().textAlignment(.left).style(style: .footNoteMedium).textColor(with: DesignSystem.Colors.Palette.gray700.color).build()
        label.text = "April 22, 2019"
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var tipLabel: Label = {
        let label: Label = LabelFactory().textAlignment(.left).style(style: .footNoteMedium).textColor(with: DesignSystem.Colors.Palette.gray700.color).build()
        label.text = "This tiny little venue has tiny little prices for their delightful dumplings. The sesame pancakes are also great, and perfect to grab to-go on your way to picnic in the park, just a block west."
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
        if let imagePath = viewData.userImageURL, let imageURL = URL(string: imagePath) {
            Nuke.loadImage(with: imageURL, options: ImageLoadingOptions(placeholder: IconFactory(icon: Icon.userPlaceholder).build(), transition: nil, failureImage: IconFactory(icon: Icon.userPlaceholder).build(), failureImageTransition: nil, contentModes: nil), into: userImageView, progress: nil, completion: nil)
        } else {
            userImageView.image = IconFactory(icon: Icon.userPlaceholder).build()
        }
        
        userNameLabel.text = viewData.userName
        createdAtLabel.text = viewData.createdAt
        tipLabel.text = viewData.tipText
    }
}


// MARK: - Setup UI

private extension TipTableViewCell {
    
    func setupUI() {
        setupSubviews()
        setupConstraints()
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    func setupSubviews() {
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(createdAtLabel)
        contentView.addSubview(tipLabel)
    }
    
    func setupConstraints() {
        let marginGuide = contentView.layoutMarginsGuide
        
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        createdAtLabel.translatesAutoresizingMaskIntoConstraints = false
        tipLabel.translatesAutoresizingMaskIntoConstraints = false
                
        NSLayoutConstraint.activate([
            userImageView.topAnchor.constraint(equalTo: marginGuide.topAnchor),
            userImageView.leftAnchor.constraint(equalTo: marginGuide.leftAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 50),
            userImageView.heightAnchor.constraint(equalToConstant: 50),
            
            userNameLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor),
            userNameLabel.leftAnchor.constraint(equalTo: userImageView.rightAnchor, constant: 10),
            userNameLabel.rightAnchor.constraint(equalTo: marginGuide.rightAnchor),
            
            createdAtLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 5),
            createdAtLabel.leftAnchor.constraint(equalTo: userNameLabel.leftAnchor),
            createdAtLabel.rightAnchor.constraint(equalTo: marginGuide.rightAnchor),
            
            tipLabel.topAnchor.constraint(equalTo: createdAtLabel.bottomAnchor, constant: 5),
            tipLabel.leftAnchor.constraint(equalTo: createdAtLabel.leftAnchor),
            tipLabel.rightAnchor.constraint(equalTo: marginGuide.rightAnchor),
            tipLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: -5)
        ])
    }
}
