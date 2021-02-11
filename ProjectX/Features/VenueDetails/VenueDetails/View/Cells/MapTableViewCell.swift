//
//  MapTableViewCell.swift
//  VenueDetails
//
//  Created by Sameh Mabrouk on 10/02/2021.
//

import UIKit
import DesignSystem

class MapTableViewCell: UITableViewCell {

    // MARK: - Properties
        
    lazy var label: Label = {
        let label: Label = LabelFactory().textAlignment(.left).style(style: .footNoteMedium).textColor(with: DesignSystem.Colors.Palette.gray700.color).build()
        label.text = "Directions"
        label.numberOfLines = 0
        
        return label
    }()
    
    lazy var icon: UIImageView = {
        let icon: UIImageView = ImageViewFactory().build()
        icon.image = IconFactory(icon: .compass).build()
        
        return icon
    }()
    
    // MARK: - Initalizers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - Setup UI

private extension MapTableViewCell {
    
    func setupUI() {
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        contentView.addSubview(icon)
        contentView.addSubview(label)
    }
    
    func setupConstraints() {
        let marginGuide = contentView.layoutMarginsGuide
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            icon.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 5),
            icon.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: 130),
            icon.widthAnchor.constraint(equalToConstant: 20),
            icon.heightAnchor.constraint(equalToConstant: 20),
            
            label.leftAnchor.constraint(equalTo: icon.rightAnchor, constant: 8),
            label.centerYAnchor.constraint(equalTo: icon.centerYAnchor)
        ])
    }
}
