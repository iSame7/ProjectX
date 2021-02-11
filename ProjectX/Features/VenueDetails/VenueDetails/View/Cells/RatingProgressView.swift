//
//  RatingProgressView.swift
//  VenueDetails
//
//  Created by Sameh Mabrouk on 08/02/2021.
//

import UIKit
import DesignSystem

class RatingProgressView: UIView {
 
    // MARK: - Properties
    
    private lazy var label: Label = {
        let label: Label = LabelFactory().textAlignment(.left).style(style: .footNoteMedium).textColor(with: DesignSystem.Colors.Palette.gray400.color).build()
        return label
    }()
    
    private lazy var progressView: UIProgressView = {
       let progressView = UIProgressView()
        progressView.progressTintColor = DesignSystem.Colors.Palette.orange500.color
        
        return progressView
    }()
    
    // MARK: - View lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    @available(*, unavailable, message: "NSCoder and Interface Builder is not supported. Use Programmatic layout.")
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(title: String, progress: Float) {
        label.text = title
        progressView.progress = progress
    }
}

// MARK: - Setup UI

private extension RatingProgressView {
    
    func setupUI() {
        setupSubviews()
        setupConstraints()
    }
    
    func setupSubviews() {
        addSubview(label)
        addSubview(progressView)
    }
    
    func setupConstraints() {
        label.translatesAutoresizingMaskIntoConstraints = false
        progressView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: leftAnchor),
            label.rightAnchor.constraint(equalTo: rightAnchor),
            label.heightAnchor.constraint(equalToConstant: 17),
            progressView.leftAnchor.constraint(equalTo: leftAnchor),
            progressView.rightAnchor.constraint(equalTo: rightAnchor),
            progressView.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 3)
        ])
    }
}
