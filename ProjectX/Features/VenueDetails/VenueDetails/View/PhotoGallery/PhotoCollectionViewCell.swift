//
//  PhotoCollectionViewCell.swift
//  VenueDetails
//
//  Created by Sameh Mabrouk on 11/02/2021.
//

import UIKit
import Nuke
import DesignSystem

class PhotoCollectionViewCell: UICollectionViewCell {
        
    struct ViewData {
        let imageURL: String?
    }
    
    private lazy var imageView: UIImageView = {
        ImageViewFactory().build()
    }()

    static let reuseIdentifier = "GalleryCollectionViewCell"
    
    func setup(with viewData: ViewData) {
        if let imagePath = viewData.imageURL, let imageURL = URL(string: imagePath) {
            Nuke.loadImage(with: imageURL, options: ImageLoadingOptions(placeholder: #imageLiteral(resourceName: "restaurantPlaceholder"), transition: nil, failureImage: #imageLiteral(resourceName: "restaurant"), failureImageTransition: nil, contentModes: nil), into: imageView, progress: nil, completion: nil)
        } else {
            imageView.image = #imageLiteral(resourceName: "placeholder")
        }
    }
    
    func setup(with photo: PhotoViewable) {
        photo.loadThumbnailImageWithCompletionHandler { [weak photo] (image, error) in
            if let image = image {
                if let photo = photo as? GalleryPhoto {
                    photo.thumbnailImage = image
                }
                self.imageView.image = image
            }
        }
    }
}

// MARK: - Setup UI

extension PhotoCollectionViewCell {
    
    func setupUI() {
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        contentView.addSubview(imageView)
    }
    
    func setupConstraints() {
        let marginGuide = contentView.layoutMarginsGuide
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 0),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}
