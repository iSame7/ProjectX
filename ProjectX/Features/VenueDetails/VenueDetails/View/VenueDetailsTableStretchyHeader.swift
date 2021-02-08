//
//  VenueDetailsTableViewHeader.swift
//  VenueDetails
//
//  Created by Sameh Mabrouk on 06/02/2021.
//

import UIKit
import DesignSystem
import Nuke

class VenueDetailsTableStretchyHeader: UIView {
    
    public struct ViewData {
        var title: String
        var description: String
        var imageURL: String?
        var imagePlaceholder: String
    }
    
    lazy var imageView: UIImageView = {
        let imageView: UIImageView = ImageViewFactory().build()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    lazy var shadowView: UIView = {
        UIView()
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 0
        stackView.backgroundColor = .red
        
        return stackView
    }()
    
    private lazy var titleLabel: Label = {
        LabelFactory().textAlignment(.left).style(style: .title3).textColor(with: DesignSystem.Colors.Palette.brandWhite.color).build()
    }()

    private lazy var descriptionLabel: Label = {
        LabelFactory().textAlignment(.left).style(style: .footNoteRegular).textColor(with: DesignSystem.Colors.Palette.brandWhite.color).build()
    }()
    
    
    private var imageViewHeiight = NSLayoutConstraint()
    private var imageViewBottom = NSLayoutConstraint()
    private var containerView = UIView()
    private var containerViewHeight = NSLayoutConstraint()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    @available(*, unavailable, message: "NSCoder and Interface Builder is not supported. Use Programmatic layout.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with viewData: ViewData) {
        titleLabel.text = viewData.title
        descriptionLabel.text = viewData.description
        
        let placeholderImage = UIImage(named: viewData.imagePlaceholder, in: Bundle(for: VenueDetailsTableStretchyHeader.self), with: nil)
        
        if let imagePath = viewData.imageURL, let imageURL = URL(string: imagePath) {
            Nuke.loadImage(with: imageURL, options: ImageLoadingOptions(placeholder: placeholderImage, transition: nil, failureImage: placeholderImage, failureImageTransition: nil, contentModes: nil), into: imageView, progress: nil, completion: nil)
        } else {
            imageView.image = placeholderImage
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        containerViewHeight.constant = scrollView.contentInset.top
        let offsetY = -(scrollView.contentOffset.y + scrollView.contentInset.top)
        containerView.clipsToBounds = offsetY <= 0
        imageViewBottom.constant = offsetY >= 0 ? 0 : -offsetY / 2
        imageViewHeiight.constant = max(offsetY + scrollView.contentInset.top, scrollView.contentInset.top)
    }
}

// MARK: - Setup UI

private extension VenueDetailsTableStretchyHeader {
    
    func setupUI() {
        setupSubviews()
        setupConstraints()
        
        shadowView.addGradient(colors: [UIColor.black.withAlphaComponent(0).cgColor, UIColor.black.withAlphaComponent(0.2).cgColor, UIColor.black.withAlphaComponent(0.3).cgColor])
    }
    
    func setupSubviews() {
        addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.addSubview(shadowView)
                
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(descriptionLabel)
        
        containerView.addSubview(stackView)
    }
    
    func setupConstraints() {
        containerView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        shadowView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalTo: containerView.widthAnchor),
            centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            heightAnchor.constraint(equalTo: containerView.heightAnchor),
            containerView.widthAnchor.constraint(equalTo: imageView.widthAnchor),
            shadowView.leftAnchor.constraint(equalTo: containerView.leftAnchor),
            shadowView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            shadowView.heightAnchor.constraint(equalToConstant: 60),
            shadowView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            stackView.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            stackView.rightAnchor.constraint(equalTo: containerView.rightAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 70)
        ])
        
        containerViewHeight = containerView.heightAnchor.constraint(equalTo: heightAnchor)
        containerViewHeight.isActive = true
        
        imageViewBottom = imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
        imageViewBottom.isActive = true
        
        imageViewHeiight = imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor)
        imageViewHeiight.isActive = true
    }
}
