//
//  CollectionViewCell.swift
//  Map
//
//  Created by Sameh Mabrouk on 31/01/2021.
//

import UIKit
import DesignSystem
import Nuke

class CollectionViewCell: UICollectionViewCell {
    
    public struct CollectionViewData {
        var image: String?
        var title: String
        var categoryName: String
        var description: String
    }
    
    private lazy var imageView: UIImageView = {
        ImageViewFactory().build()
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 0
        
        return stackView
    }()
    
    private lazy var titleLabel: Label = {
        LabelFactory().textAlignment(.left).style(style: .title3).textColor(with: DesignSystem.Colors.Palette.orange500.color).build()
    }()
    
    private lazy var categoryNameLabel: Label = {
        LabelFactory().textAlignment(.left).style(style: .footNoteRegular).textColor(with: DesignSystem.Colors.Palette.gray700.color).build()
    }()
    
    private lazy var descriptionLabel: Label = {
        LabelFactory().textAlignment(.left).style(style: .footNoteRegular).textColor(with: DesignSystem.Colors.Palette.gray700.color).build()
    }()
    
    override init(frame: CGRect) {
       super.init(frame: frame)
       setupUI()
    }
       
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(viewData: CollectionViewData) {
        let restaurant: UIImage = IconFactory(icon: Icon.restaurant).build()
        if let imagePath = viewData.image, let imageURL = URL(string: imagePath) {
            Nuke.loadImage(with: imageURL, options: ImageLoadingOptions(placeholder: IconFactory(icon: Icon.restaurantPlaceholder).build(), transition: nil, failureImage: restaurant, failureImageTransition: nil, contentModes: nil), into: imageView, progress: nil, completion: nil)
        } else {
            imageView.image = IconFactory(icon: Icon.restaurantPlaceholder).build()
        }
        
        titleLabel.text = viewData.title
        categoryNameLabel.text = viewData.categoryName
        descriptionLabel.text = viewData.description
    }
}

// MARK: - Setup UI

private extension CollectionViewCell {
    func setupUI() {
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(imageView)
        
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(categoryNameLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
        addSubview(stackView)
    }
    
    func setupConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            imageView.widthAnchor.constraint(equalToConstant: 50),
            imageView.heightAnchor.constraint(equalToConstant: 50),
            imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            stackView.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -5)
        ])
    }
}
