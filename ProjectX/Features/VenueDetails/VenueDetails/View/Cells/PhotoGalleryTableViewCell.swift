//
//  PhotoGalleryTableViewCell.swift
//  VenueDetails
//
//  Created by Sameh Mabrouk on 11/02/2021.
//

import UIKit
import DesignSystem
import FoursquareCore

typealias ImageSelectionHandler = ((_ galleryPreview: PhotosViewController) -> Void)

class PhotoGalleryTableViewCell: UITableViewCell {

    struct ViewData {
        let photos: [Photo]
    }
    
    // MARK: - Properties
        
    static let reuseIdentifier = "PhotoGalleryTableViewCell"

    private var viewData: ViewData?
    var photos: [PhotoViewable]?

    var selectedImageClosure: ImageSelectionHandler?
    
    private lazy var label: Label = {
        let label: Label = LabelFactory().textAlignment(.left).style(style: .footNoteMedium).textColor(with: DesignSystem.Colors.Palette.gray200.color).build()
        label.text = "PHOTO FAVORITIES"
        label.numberOfLines = 0
        
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: PhotoGalleryLayout())
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier)
        return collectionView
    }()
    
    // MARK: - Initalizers
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // resize cell according to collection view size
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        if let viewModel = viewData, !viewModel.photos.isEmpty {
            collectionView.layoutIfNeeded()
            collectionView.frame = CGRect(x: 0, y: 0, width: targetSize.width , height: 1)
            return collectionView.collectionViewLayout.collectionViewContentSize
        } else {
            return CGSize(width: 0, height: 0)
        }
    }
    
    func setup(with viewData: ViewData, imageSelectionHandler: @escaping ImageSelectionHandler) {
        self.viewData = viewData
        selectedImageClosure = imageSelectionHandler
        var photos = [GalleryPhoto]()
        for photo in viewData.photos {
            photos.append(GalleryPhoto(imageURL: URL(string: "\(photo.prefix)500x500\(photo.suffix)"), thumbnailImageURL: URL(string: "\(photo.prefix)500x500\(photo.suffix)")))
        }
        
        self.photos = photos
        collectionView.reloadData()
    }
}


// MARK: - Setup UI

private extension PhotoGalleryTableViewCell {
    
    func setupUI() {
        selectionStyle = .none
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        contentView.addSubview(label)
        contentView.addSubview(collectionView)
    }
    
    func setupConstraints() {
        let marginGuide = contentView.layoutMarginsGuide
        
        label.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 5),
            label.leftAnchor.constraint(equalTo: marginGuide.leftAnchor),
            label.rightAnchor.constraint(equalTo: marginGuide.rightAnchor),
            collectionView.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 20),
            collectionView.leftAnchor.constraint(equalTo: marginGuide.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: marginGuide.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor)
        ])
    }
}

extension PhotoGalleryTableViewCell: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PhotoCollectionViewCell.reuseIdentifier, for: indexPath) as! PhotoCollectionViewCell
        if let photos = photos {
            cell.setup(with: photos[indexPath.item])
        }
        return cell
    }
}

extension PhotoGalleryTableViewCell: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let photos = photos, let cell = collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell {
            let currentPhoto = photos[indexPath.item]
            let galleryPreview = PhotosViewController(photos: photos, initialPhoto: currentPhoto, referenceView: cell)
            
            galleryPreview.referenceViewForPhotoWhenDismissingHandler = { photo in
                if let index = photos.firstIndex(where: {$0 === photo}) {
                    let indexPath = IndexPath(item: index, section: 0)
                    return collectionView.cellForItem(at: indexPath) as? PhotoCollectionViewCell
                }
                return nil
            }
            selectedImageClosure?(galleryPreview)

        }
    }
}
